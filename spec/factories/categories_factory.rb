FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "Category #{n}" }
    description { "Sample description for category." }
  end
end
