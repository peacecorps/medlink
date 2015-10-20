class User::Upload
  class Row
    def initialize country:, headers:
      @country, @headers, @cells = country, headers, []
    end

    def add_user data, overwrite:
      return if data.values.all?(&:empty?)
      pcv_id = data["pcv_id"]

      @user   = User.where(pcv_id: pcv_id).first if overwrite
      @user ||= User.new pcv_id: pcv_id

      if @user.new_record?
        @user.country  = @country
        @user.password = @user.password_confirmation = SecureRandom.hex
      end

      @cells = @headers.map do |header|
        Cell.new user: @user, field: header.value, value: data[header.value]
      end
    end

    def valid?
      @user && @user.valid?
    end
    def save!
      @user.save!
    end

    def each
      @user.try :valid?
      @cells.each { |cell| yield cell }
    end
  end

  class Cell
    attr_reader :user, :field, :value

    def initialize user:, field:, value:
      @user, @field, @value = user, field, value
      update_user
      freeze
    end

    def update_user
      if field.start_with?("phone") && value
        user.phones.new number: value
      elsif user.respond_to? "#{field}="
        user.send "#{field}=", value
      end
    end

    def errors
      user.errors.messages[field.to_sym]
    end
  end

  class Header
    attr_reader :value

    def initialize value:
      @value = value
    end

    def errors
      unless User.column_names.include?(value) || value.to_s.start_with?("phone")
        ["is not a recognized column"]
      end
    end
  end

  attr_reader :users, :country, :headers, :rows

  def initialize country:, overwrite: false
    @country, @overwrite = country, overwrite
    @headers, @rows, @errors = [], [], []
  end

  def overwrite?
    @overwrite
  end

  def global_errors
    @errors
  end

  def successful?
    @errors.empty? && @rows.all?(&:valid?)
  end

  def run! file
    raise ArgumentError, "Please provide a CSV file" unless file

    csv = CSV.parse(file.read, headers: true)
    @headers = parse_headers csv

    csv.each_with_index do |csv_row, i|
      row = Row.new country: country, headers: headers
      row.add_user csv_row.to_hash, overwrite: overwrite?
      rows.push row
    end

    commit if successful?
  rescue => e
    @errors.push e
  end

private

  def parse_headers csv
    raise ArgumentError, "Missing headers" unless csv.headers.any?
    csv.headers.map { |column| Header.new value: column }
  end

  def commit
    @rows.each &:save!
  end
end
