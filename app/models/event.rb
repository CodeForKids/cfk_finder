class Event < ActiveRecord::Base
  has_one :address, as: :owner
  accepts_nested_attributes_for :address
  belongs_to :owner, polymorphic: true

  monetize :price_cents, with_model_currency: :price_currency

  before_save :set_price
  before_save :format_tax

  def address_attributes=(attributes)
    address = self.address || self.build_address
    address.update(attributes)
  end

  def currency
    Money::Currency.find(price_currency)
  end

  private

  def set_price
    self.price_cents = self.price_cents * currency.subunit_to_unit
  end

  def format_tax
    if self.tax_rate > 1
      self.tax_rate = self.tax_rate / 100
    end
  end
end
