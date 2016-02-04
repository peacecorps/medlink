module Report
  class InvalidName < StandardError
    def initialize name
      @name = name
    end

    def to_s
      names = Report.names.map { |n| "`#{n}`" }.join ", "
      "`#@name` - should be one of #{names}"
    end
  end

  def self.all
    [Report::OrderHistory, Report::Users, Report::PcmoResponseTimes]
  end

  def self.names
    all.map { |klass| klass.title.downcase }
  end

  def self.named name
    all.find { |klass| klass.title.downcase == name } || raise(InvalidName.new name)
  end
end
