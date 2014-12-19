require 'test_helper'

class AddressTest < ActiveSupport::TestCase
  setup do
    @address = addresses(:one)
  end

  test "full_street_address" do
    assert_equal "150 Elgin, Suite 600, K1N5T5, Ottawa, Ontario, Canada", @address.full_street_address
  end

  test "latlong" do
    assert_equal "123.0, 123.0", @address.lat_long
  end

  test "has_url?" do
    assert_not @address.has_url?, "Address had a url!"
  end
end
