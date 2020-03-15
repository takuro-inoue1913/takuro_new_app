User.create!(name:  "Example User",
             username: "smple user",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar" ,
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

99.times do |n|
  name  = Faker::Name.name
  username = Faker::Code.ean
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               username: username,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end