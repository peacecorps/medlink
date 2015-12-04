module Report
  def self.all
    [Report::OrderHistory, Report::Users, Report::PcmoResponseTimes]
  end

  def self.named name
    all.find { |klass| klass.title.downcase == name } || raise("No #{name} report")
  end
end
