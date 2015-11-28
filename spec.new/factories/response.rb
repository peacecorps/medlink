FactoryGirl.define do
  factory :response do
    user
    country    { user.country }
    extra_text "N.B. - stuff"

    transient do
      order_count    0
      delivery_count 1
      with_methods   []
    end

    after :create do |response, evaluator|
      create_list :order, evaluator.order_count, response: response
      create_list :order, evaluator.delivery_count, response: response, delivery_method: DeliveryMethod::Delivery
    end

    after :build do |response, evaluator|
      evaluator.with_methods.each do |method|
        response.orders << build(:order, delivery_method: method)
      end
    end
  end
end
