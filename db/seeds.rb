puts "\n!! All passwords are '1234678'\n"
puts "\n### Creating Parents(Parents) ###"

5.times do
  email = Faker::Internet.email

  parent = Parent.create({
      first_name: Faker::Name.first_name,
      last_name:  Faker::Name.last_name })

  user = User.create({ email: Faker::Internet.email,
                       password: "12345678",
                       password_confirmation: "12345678",
                       role_type: "Parent",
                       role_id: parent.id })

  puts "\nCreated a Parent with the email #{email}..."

  (1..5).to_a.sample.times do
    kid = Kid.create({
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      gender: ["Male","Female","Other"].sample,
      date_of_birth: Faker::Date.between(15.years.ago, 10.years.ago),
      parent_id: parent.id
    })
    puts "~> Created a Kid for the Parent #{parent.name} (#{parent.id}) with the name #{kid.name}..."
  end
end

puts "\n### Creating Tutors ###\n"

5.times do
  email = Faker::Internet.email

  tutor = Tutor.create({
      first_name: Faker::Name.first_name,
      last_name:  Faker::Name.last_name,
      date_of_birth: Faker::Date.between(50.years.ago, 20.years.ago) })

  user = User.create({ email: Faker::Internet.email,
                       password: "12345678",
                       password_confirmation: "12345678",
                       role_type: "Tutor",
                       role_id: tutor.id })

  puts "\nCreated a Tutor with the email #{email}..."
end
