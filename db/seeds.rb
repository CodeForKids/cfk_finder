def create_parents()
  puts "\n### Creating Parents(Parents) ###"

  5.times do
    email = Faker::Internet.email

    parent = Parent.create({
        first_name: Faker::Name.first_name,
        last_name:  Faker::Name.last_name })

    random_address(parent)

    user = User.create({ email: email,
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
        date_of_birth: random_date(15.years.ago, 10.years.ago),
        parent_id: parent.id
      })
      puts "~> Created a Kid for the Parent #{parent.name} (#{parent.id}) with the name #{kid.name}..."
    end
  end
end

def create_tutors()
  puts "\n### Creating Tutors ###\n"

  5.times do
    email = Faker::Internet.email

    tutor = Tutor.create({
        first_name: Faker::Name.first_name,
        last_name:  Faker::Name.last_name,
        date_of_birth: random_date(50.years.ago, 20.years.ago) })

    random_address(tutor)

    user = User.create({ email: email,
                         password: "12345678",
                         password_confirmation: "12345678",
                         role_type: "Tutor",
                         role_id: tutor.id })

    puts "\nCreated a Tutor with the email #{email}..."
  end
end

def random_address(object)
  address_csv = @text.sample.split(", ")
  address = object.build_address({
    address1: address_csv[0],
    address2: "",
    city: address_csv[1],
    postal_code: address_csv[3].gsub("-"," "),
    province: address_csv[2],
    country: "Canada"
  })
  address.save(validate: false)
end

def random_date(date1, date2)
  Time.at((date2.to_f - date1.to_f)*rand + date1.to_f)
end

def load_addresses()
  @text = []
  File.open(File.join(Rails.root, 'db', 'addresses.txt')) do |f|
    f.each_line do |line|
      @text << line
    end
  end
end

puts "\n!! All passwords are '1234678'\n"
load_addresses()
create_parents()
create_tutors()
