FactoryGirl.define do
  factory :campaign, aliases: [:supported_campaign] do
    creator { create(:user) }
    title { 'Boat Life 2016' }
    subtitle { "Rent in SF is crazy. I'm gonna live in a boat." }
    description {
      "Rent is $2k per month. Boats? Boats are cheap. I need money to " +
      "buy a boat, and live on it. I've got a good job, " +
      "I'll pay the loan back in no time."
    }

    goal_date { 2.weeks.from_now }
    repayment_length { 3 }
    interest_percent { 15 }

    goal_amount { 4000 }

    picture { File.open("#{Rails.root}/spec/fixtures/boat.jpg") }
  end
end
