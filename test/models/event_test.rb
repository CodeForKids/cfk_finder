require 'test_helper'

class EventTest < ActiveSupport::TestCase

  test 'currency' do
    assert_equal Money::Currency.find("CAD"), events(:canada).currency
    assert_equal Money::Currency.find("JPY"), events(:japan).currency
  end

  test 'set_price converts to subunits' do
    @canada = events(:canada)
    @canada.price_cents = 15000
    @canada.save

    assert_equal 1500000, @canada.price_cents
    assert_equal "$",  @canada.price.symbol

    @japan = events(:japan)
    @japan.price_cents = 15000
    @japan.save

    assert_equal 15000, @japan.price_cents
    assert_equal "¥", @japan.price.symbol
  end

  test 'format_tax' do
    @canada = events(:canada)
    @canada.tax_rate = 15
    @canada.save
    assert_equal 0.15, @canada.tax_rate

    @canada.tax_rate = 0.18
    @canada.save
    assert_equal 0.18, @canada.tax_rate

  end
end
