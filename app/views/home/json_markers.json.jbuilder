json.array!(@events) do |event|
  json.extract! event, :id, :name, :description, :spots_available, :materials_needed, :tax_rate
  json.price humanized_money_with_symbol(event.price)
  json.partial! 'addresses/address', address: event.address
  json.extract! event, :created_at, :updated_at
  json.url polymorphic_url([event.owner, event])
end
