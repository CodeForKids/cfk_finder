json.extract! @tutor, :id, :first_name, :last_name, :date_of_birth, :max_students, :email
json.partial! 'addresses/address', address: @tutor.address
json.extract! @tutor, :created_at, :updated_at
