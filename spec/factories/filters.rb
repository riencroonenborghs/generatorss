FactoryBot.define do
  factory :filter do
    user
    comparison { "eq" }
    value { "foo" }
  end
end
