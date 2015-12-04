class PhoneSyncForm < Reform::Form
  property :numbers, virtual: true

  validate :numbers_have_country_code
  validate :numbers_arent_taken

  def initialize user, *args
    super
    self.numbers = user_numbers
  end

  def to_s
    numbers
  end

  def save
    old = Set.new model.phones.pluck :condensed
    new = Set.new condensed

    (old - new).each { |n| Phone.for(number: n).update! user: nil }
    (new - old).each { |n| Phone.for(number: n).update! user: model }
  end

  def changed?
    self.numbers != user_numbers
  end

  private

  def user_numbers
    model.phones.pluck(:number).join ", "
  end

  def condensed
    numbers.split(/[,\n]/).map { |n| Phone.condense n }
  end

  def numbers_have_country_code
    unless condensed.all? { |c| c.start_with? '+' }
      errors.add :numbers, "should include a country code (e.g. +1 for the US)"
    end
  end

  def numbers_arent_taken
    taken = Phone.where(condensed: condensed).where.not user: [model, nil]
    if taken.any?
      errors.add :numbers, "phone numbers are already in use: #{taken.pluck(:number).join ', '}"
    end
  end
end
