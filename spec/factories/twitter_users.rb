FactoryBot.define do
  factory :twitter_user do
    last_loaded { 1.day.ago }
    twitter_id { rand(100_000..999_999).to_s }
    name { Faker::Name.first_name.downcase }
    username { Faker::Name.first_name.downcase }
    description { "Some description" }
    profile_image_url { Faker::Internet.url }
    url { Faker::Internet.url }
    verified { false }

    trait :unloaded do
      last_loaded { nil }
    end
  end
end
