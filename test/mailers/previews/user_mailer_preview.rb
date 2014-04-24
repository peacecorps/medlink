class UserMailerPreview < ActionMailer::Preview
  include DeliveryMethod::Choices

  def fulfillment
    mailer = nil

    ActiveRecord::Base.transaction do
      country = Country.where(name: "United States").first

      user = User.where(
        email:      "user@example.com",
        first_name: "User",
        last_name:  "Name"
      ).first_or_initialize
      user.save! validate: false

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

      mailer = UserMailer.fulfillment response.id

      raise ActiveRecord::Rollback
    end

    mailer
  end
end
