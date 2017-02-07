FactoryGirl.define do
  factory :user do
    name { Faker::Name.first_name }
    email { "#{ name }@example.com" }
    password 'password'
    password_confirmation { password || 'password' }
    admin { false }
    activated { true }

    factory :supporting_user do
      transient do
        campaigns_count 2
      end

      after(:create) do |user, evaluator|
        evaluator.campaigns_count.times do
          user.supported_campaigns << create(:campaign)
        end
      end
    end
  end
end
