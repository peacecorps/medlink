class UserMailerPreview < ActionMailer::Preview
  include DeliveryMethod::Choices

  def fulfillment
    transiently do
      country  = Country.where(name: "United States").first
      response = Response.new(
        country:    country,
        user:       user,
        extra_text: "Extra response text"
      )
      response.save!

      (2..5).to_a.sample.times do
        response.orders.new(
          country:         country,
          user:            user,
          supply:          Supply.all.sample,
          delivery_method: DeliveryMethod.to_a.sample
        ).save! validate: false
      end

      UserMailer.fulfillment response.id
    end
  end

  def welcome
    transiently { UserMailer.welcome user.id }
  end

  private

  def transiently &block
    result = nil
    ActiveRecord::Base.transaction do
      result = block.call
      raise ActiveRecord::Rollback
    end
    result
  end

  def user
    @_user ||= User.where(
      email:      "user@example.com",
      first_name: "User",
      last_name:  "Name"
    ).first_or_initialize.tap { |u| u.save! validate: false }
  end
end
