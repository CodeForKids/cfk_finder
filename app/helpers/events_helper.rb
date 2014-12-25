module EventsHelper
  def format_tax_rate(tax_rate)
    tax_rate ? (tax_rate * 100).to_s : nil
  end

  def number_to_percent(number)
    number_to_percentage(number * 100, precision: 10, strip_insignificant_zeros: true)
  end
end
