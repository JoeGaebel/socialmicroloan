USERS_COUNT = 15
POSTS_COUNT = 5

joe = User.create!({
  name:  'Joe Gaebel',
  email: 'joe@socialmicro.loan',
  password:              'password',
  password_confirmation: 'password',
  admin: true,
  activated: true,
  activated_at: Time.zone.now
})

puts "created Joe!"


boat_life = Campaign.create!({
  id: 1,
  creator: joe,
  title: 'Boat Life 2016',
  subtitle: "Rent in SF is crazy. I'm gonna live in a boat.",
  description: "Rent is $2k per month. Boats? Boats are cheap. I need money to buy a boat, and live on it. I've got a good job I'll pay the loan back in no time.",
  goal_date: 2.weeks.from_now,
  repayment_length: 3,
  interest_percent: 15,
  goal_amount: 4000,
  pledged_amount: 0,
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

puts "created users"

users = User.order(:created_at).take(USERS_COUNT/3)
POSTS_COUNT.times do
  users.each do |user|
    content = Faker::Hipster.sentence(4, false, 4)
    user.microposts.create!(content: content)
  end
end

users = User.all
user  = users.first
following = users[2..USERS_COUNT]
followers = users[3..USERS_COUNT]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }


Users.all.each do |user|
  user.support(boat_life)
end
