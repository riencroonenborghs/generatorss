FactoryBot.define do
  factory :discord_channel do
    channel_id { 1 }
    guild_id { 1 }
    name { "name" }
    description { "description" }
  end
end
