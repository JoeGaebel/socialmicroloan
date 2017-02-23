FactoryGirl.define do
  factory :campaign_support do
    user { create(:user) }
    campaign { create(:campaign) }
    support_amount { 10 }
  end
end
