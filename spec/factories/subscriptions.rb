FactoryBot.define do
  factory :subscription do
    user
    subscriptable_type { "TwitterUser" }
    subscriptable_id { twitter_user.id }
  end
end
