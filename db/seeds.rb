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
  description: File.read("#{Rails.root}/spec/fixtures/boatlife2016.txt"),
  goal_date: 2.weeks.from_now,
  repayment_length: 3,
  interest_percent: 5,
  goal_amount: 3000,
  picture:  File.open("#{Rails.root}/spec/fixtures/boat.jpg")
})

puts "created Boat Life!"

expired = Campaign.create({
  creator: eddie,
  title: 'Supermoto :motorcycle:',
  subtitle: "I'm gonna buy a sweet motorcycle",
  description: "I can't wait to get on the track with this bad boy",
  goal_date: 2.weeks.from_now,
  repayment_length: 3,
  interest_percent: 5,
  goal_amount: 5000,
  picture:  File.open("#{Rails.root}/spec/fixtures/supermoto.jpg")
})

expired.update_column(:goal_date, 2.weeks.ago)

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
