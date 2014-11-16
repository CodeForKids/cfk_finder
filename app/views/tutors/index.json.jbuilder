json.array!(@tutors) do |tutor|
  json.extract! tutor, :id, :first_name, :last_name, :date_of_birth, :max_students
  json.url tutor_url(tutor, format: :json)
end
