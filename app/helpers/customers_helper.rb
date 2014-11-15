module CustomersHelper
  def delete_phrase(customer)
    "Are you sure you want to delete the customer profile for #{customer.name}?"
  end
end
