require File.expand_path('config/environment', __dir__)

require 'uri'
require 'net/http'
require 'openssl'
require 'json'

url = URI("https://lexper.p.rapidapi.com/v1.1/extract?url=https://cdixon.org/2013/08/04/the-idea-maze")

http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE



request = Net::HTTP::Get.new(url)
request["x-rapidapi-key"] = 'e09ea11b6amsh74eb3c011223295p1aa55bjsnc595811962a2'
request["x-rapidapi-host"] = 'lexper.p.rapidapi.com'

response = http.request(request)
puts JSON.parse(response.body)
