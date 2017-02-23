USERS_COUNT = 5

joe = User.create!({
  name:  'Joe Gaebel',
  email: 'joe@socialmicro.loan',
  password:              'password',
  password_confirmation: 'password',
  admin: true,
  activated: true,
  activated_at: Time.zone.now,
  publishable_key: 'pk_test_Xu7tPv4iaR5HAhpW5aMBAUsw',
  secret_key: 'sk_test_D3i9SYfZppcHll9nW1aRzLEW',
  stripe_user_id: 'acct_19ptbjCn5n634585',
  currency: 'cad'
})

puts "created Joe!"

eddie = User.create({
  name: 'Eddie A.',
  email: 'eddie@example.com',
  password: 'password',
  activated: true,
  activated_at: Time.zone.now
})

puts "created Eddie!"

boat_life = Campaign.create({
  creator: joe,
  title: 'Boat Life 2016',
  subtitle: "Rent in SF is crazy. I'm gonna live in a boat.",
  description: "Rent is $2k per month. Boats? Boats are cheap. I need money to buy a boat, and live on it. I've got a good job I'll pay the loan back in no time.",
  goal_date: 2.weeks.from_now,
  repayment_length: 3,
  interest_percent: 5,
  goal_amount: 3000,
  picture:  File.open("#{Rails.root}/spec/fixtures/boat.jpg")
})

puts "created Boat Life!"

USERS_COUNT.times do |n|
  User.create!({
    name: Faker::Name.name,
    email: "example-#{n+1}@example.com",
    password: 'password',
    password_confirmation: 'password',
    activated: true,
    activated_at: Time.zone.now
  })
end

puts "created Users"
