require 'test_helper'

class EventsHelperTest < ActionView::TestCase
  test 'format_tax_rate' do
    assert_equal "15.0", format_tax_rate(0.15)
    assert_equal nil, format_tax_rate(nil)
  end

  test 'number_to_percent' do
    assert_equal "15%", number_to_percent(0.15000)
    assert_equal "15.00000001%", number_to_percent(0.1500000001)
    assert_equal "15.1%", number_to_percent(0.1510)
  end
end
