class User
  class Upload
    attr_reader :added, :global_errors, :row_errors, :headers

    def initialize country_id, io, overwrite: false
      @country_id, @io, @overwrite = country_id, io, overwrite
      @added, @global_errors, @row_errors = [], [], []
    end

    def errors
      @global_errors + @row_errors
    end

    def run!
      raise ArgumentError, "Please provide a CSV file" unless @io
      raise ArgumentError, "CSV file is empty" if @io.size.zero?

      begin
        @country = Country.find @country_id
      rescue
        raise ArgumentError, "Please select a country"
      end

      file = @io.read
      unless file.lines[0].split(',').include? "email"
        raise ArgumentError, "CSV file missing header"
      end

      CSV.parse(file, headers: true) do |row|
        @headers ||= check_headers row.to_hash
        add_user_from_row row.to_hash
      end
    rescue => e
      @global_errors << e
    end

    private

    def check_headers row
      user = User.new
      row.each do |k,v|
        unless user.respond_to?("#{k}=") || k.start_with?("phone")
          @global_errors << NotImplementedError.new("Unrecognized header: #{k}")
        end
      end
      row.keys
    end

    def add_user_from_row row
      return if row.values.all?(&:empty?)
      pcv_id = row["pcv_id"]

      user   = User.where(pcv_id: pcv_id).first if @overwrite
      user ||= User.new pcv_id: pcv_id

      if new_user = user.new_record?
        user.country  = @country
        user.password = user.password_confirmation = SecureRandom.hex
      end

      phones = []
      row.each do |k,v|
        if user.respond_to? "#{k}="
          user.send "#{k}=", v
        elsif k && k.start_with?("phone")
          user.phones.new number: v if v.present?
        end
      end

      if user.save
        @added << user if new_user
      else
        @row_errors << [row, user.errors.full_messages.to_sentence]
      end
    end
  end
end
