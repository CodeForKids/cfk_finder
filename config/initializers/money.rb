# encoding : utf-8

require 'money'
require 'money/bank/google_currency'
Money::Bank::GoogleCurrency.ttl_in_seconds = 86400

Money::Currencies = Money::Currency.all.collect{ |c| ["#{c.name} (#{c.iso_code})", c.iso_code, {'data-symbol' => c.symbol}] }

MoneyRails.configure do |config|
  config.default_currency = :cad
  config.default_bank = Money::Bank::GoogleCurrency.new
end
