require 'autoexpire_cache_dalli'
require 'dalli'

Geocoder.configure(
 timeout: 5,
 lookup: :telize,
 ip_lookup: :telize,
 units: :km,
 cache: AutoexpireCacheDalli.new(Dalli::Client.new)
)
