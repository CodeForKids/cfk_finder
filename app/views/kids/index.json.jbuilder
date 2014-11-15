json.array!(@kids) do |kid|
  json.extract! kid, :id, :first_name, :last_name, :gender, :date_of_birth
  json.url kid_url(kid, format: :json)
end
