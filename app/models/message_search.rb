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
    # TODO: unless direction == :incoming || validity == :both ... ?
    valid direct in_country
  end

private

  def valid scope
    if validity == :valid
      scope.
        joins("left outer join requests on requests.message_id = messages.id").
        where("requests.id is not null")
    elsif validity == :invalid
      scope.
        joins("left outer join requests on requests.message_id = messages.id").
        where("requests.id is null")
    else
      scope
    end
  end

  def direct scope
    if direction == :incoming
      scope.incoming
    elsif direction == :outgoing
      scope.outgoing
    else
      scope
    end
  end

  def in_country
    if user.pcmo?
      SMS.joins(:user).where(users: { country_id: user.country_id })
    elsif country_ids.any? &:present?
      SMS.joins(:user).where(users: { country_id: country_ids })
    else
      SMS.all
    end
  end
end
