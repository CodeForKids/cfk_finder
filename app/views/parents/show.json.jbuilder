json.extract! @parent, :id, :first_name, :last_name, :email
json.partial! 'addresses/address', address: @parent.address
json.extract! @parent, :kids, :created_at, :updated_at
