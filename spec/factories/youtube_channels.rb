FactoryBot.define do
  factory :youtube_channel do
    last_loaded { 1.day.ago }
    rss_url { Faker::Internet.url }
    url { Faker::Internet.url }
    image_url { Faker::Internet.url }
    name { Faker::Internet.name }

    trait :unloaded do
      last_loaded { nil }
    end
  end
end
