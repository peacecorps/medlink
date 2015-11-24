FactoryGirl.define do
  factory :response do
    user
    country { user.country }

    transient do
      order_count 1
    end

    after :create do |response, evaluator|
      create_list :order, evaluator.order_count, response: response
    end
  end
end
