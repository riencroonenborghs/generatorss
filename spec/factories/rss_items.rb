FactoryBot.define do
  factory :rss_item do
    trait :twitter_user do
      itemable_type { "TwitterUser" }
      itemable_id { create(:twitter_user).id }
    end

    trait :youtube_channel do
      itemable_type { "YoutubeChannel" }
      itemable_id { create(:youtube_channel).id }
    end

    title { "MyString" }
    link { "MyString" }
    published_at { "2022-03-12 13:13:17" }
    description { "MyText" }
    media_title { "MyString" }
    media_url { "MyString" }
    media_type { "MyString" }
    media_width { 1 }
    media_height { 1 }
    media_thumbnail_url { "MyString" }
    media_thumbnail_width { 1 }
    media_thumbnail_height { 1 }
    guid { "MyString" }
  end
end
