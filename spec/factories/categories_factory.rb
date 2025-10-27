FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "Category #{SecureRandom.hex(4)}" }
    description { "Sample description for category." }
  end
end
