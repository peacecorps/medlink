class Report
  attr_accessor :rows

  def to_csv opts={}
    CSV.generate(opts) do |csv|
      csv << columns
      cleaned_rows.each { |values| csv << values }
    end
  end

  def cleaned_rows
    rows.map do |obj|
      format(obj).values.map { |v| clean v }
    end.select { |values| values.any? &:present? }
  end

  def clean value
    raise "Unconverted ActiveRecord in CSV" if value.is_a?(ActiveRecord::Base)
    value.to_s.gsub("\n", " ")
  end

  private #---------

  # This is a hack to get the column names even if we don't have any
  #   rows to print out. It may be too clever, but it is at least localized.
  class NullObject
    def method_missing(*args, &block); self; end
  end
  def columns
    format(NullObject.new).keys
  end
end
