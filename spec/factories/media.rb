FactoryGirl.define do
  factory :media do
    sequence(:account)     { |n| "account=#{n}" }
  	name                  { "media_name" }
    introduction          { "media introduction" }
  end
end