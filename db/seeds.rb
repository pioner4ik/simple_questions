3.times do |n|
  User.create!(
    email: "mir#{n+1}@mail.ru",
    password: "123456",
    password_confirmation: "123456",
    admin: false)
end

3.times do |n|
  Question.create!(title: "Valid title#{n}", body: "Good body#{n}", user: User.find(n+1))
end

2.times do |n|
  Question.create!(title: "Invalid title#{n}", body: "Bad body#{n}", user: User.find(n+1))
end
