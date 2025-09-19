FactoryBot.define do
  # Base user
  factory :user, class: User do
    sequence(:email_address) { |n| "user#{n}@example.com" }
    sequence(:full_name)     { |n| "Test User #{n}" }
    password { "password_123" }

    # Nested factories (inherit the defaults above)
    factory :admin_user do
      after(:create) { |user| user.add_role(:admin) }
    end

    factory :guest_user do
      after(:create) { |user| user.add_role(:guest) }
    end

    factory :customer_user do
      after(:create) { |user| user.add_role(:customer) }
    end
  end
end
