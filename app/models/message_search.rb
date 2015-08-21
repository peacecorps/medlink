class MessageSearch
  include Virtus.model
  include ActiveModel::Model

  attribute :user,        User
  attribute :country_ids, Array[Integer]
  attribute :direction,   Symbol, default: :incoming
  attribute :validity,    Symbol, default: :both

  def direction_choices
    %i( incoming outgoing both )
  end

  def validity_choices
    %i( valid invalid both )
  end

  def country_choices
    Country.all
  end

  def messages
    in_country direction_filter by_validity
  end

private

  def by_validity
    if validity == :valid
      SMS.joins("left outer join requests on requests.message_id = messages.id").where("requests.id is not null")
    elsif validity == :invalid
      SMS.joins("left outer join requests on requests.message_id = messages.id").where("requests.id is null")
    else
      SMS.all
    end
  end

  def direction_filter scope
    if direction == :incoming
      scope.incoming
    elsif direction == :outgoing
      SMS.outgoing # all outgoing messages are valid
    else
      scope
    end
  end

  def in_country scope
    if user.pcmo?
      scope.joins(:user).where(users: { country_id: user.country_id })
    elsif country_ids.any? &:present?
      scope.joins(:user).where(users: { country_id: country_ids })
    else
      scope
    end
  end
end
