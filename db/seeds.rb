User.create!(name: "LocDepTrai",
             email: "admin@gmail.com",
             password: "123123",
             password_confirmation: "123123",
             activated: 1)
20.times do |n|
  name  = Faker::Name.name
  email = "loc#{n+1}@gmail.com"
  password = "123123"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password,
               activated: 1)
end