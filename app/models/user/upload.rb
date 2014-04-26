class User
  class Upload
    attr_reader :errors, :added

    def initialize country, io, overwrite: false
      raise ArgumentError, "Please provide a CSV file" unless io
      raise ArgumentError, "CSV file is empty" if io.size.zero?
      @country, @io, @errors, @overwrite, @added = country, io, "", overwrite, []
    end

    def run!
      file = @io.read

      unless file.lines[0].split(',').include? "email"
        raise ArgumentError, "CSV file missing header"
      end

      CSV.parse(file, headers: true) do |row|
        pcv_id = row.to_hash["pcv_id"]

        user   = User.where(pcv_id: pcv_id).first if @overwrite
        user ||= User.new pcv_id: pcv_id

        if new_user = user.new_record?
          user.country  = @country
          user.password = user.password_confirmation = SecureRandom.hex
        end

        phones = []
        row.to_hash.each do |k,v|
          if user.respond_to? "#{k}="
            user.send "#{k}=", v
          elsif k.start_with? "phone"
            phones << v if v.present?
          else
            raise NotImplementedError, "Unrecognized header: #{k}"
          end
        end

        if user.save
          phones.each do |number|
            Phone.where(user_id: user.id, number: number).first_or_create!
          end
          @added << user if new_user
        else
          @errors << row.push(user.errors.full_messages.to_sentence).to_s
        end
      end
    end
  end
end
