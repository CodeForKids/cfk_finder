json.array!(@events) do |event|
  json.extract! event, :id, :name, :description, :spots_available, :materials_needed, :price, :tax_rate
  json.partial! 'addresses/address', address: event.address
  json.extract! event, :created_at, :updated_at
end
