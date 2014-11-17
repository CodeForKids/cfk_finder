class Address < ActiveRecord::Base
  belongs_to :owner, :polymorphic => true

  geocoded_by :full_street_address
  after_validation :geocode

  def full_street_address
    [address1, address2, postal_code, city, province, country].reject(&:blank?).join(", ")
  end

  def lat_long
    [latitude, longitude].reject(&:blank?).join(", ")
  end
end
