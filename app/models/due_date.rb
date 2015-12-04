class DueDate
  def self.cutoff
    now = Time.now
    oldest = now.at_beginning_of_month
    now.day < 3 ? oldest - 1.month : oldest
  end

  def initialize obj
    @obj = obj
  end

  def due
    @obj.created_at.at_beginning_of_month.next_month + 3.days
  end

  def to_s
    due.strftime "%B %d"
  end
end
