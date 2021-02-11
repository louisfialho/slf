require 'net/http'

def is_redirect?(url_str)
  Net::HTTP.get_response(URI.parse(url_str)).is_a?(Net::HTTPRedirection)
end

def new_uri(url_str)
  return Net::HTTP.get_response(URI.parse(url_str))['Location']
end

p is_redirect?('https://youtu.be/ghwaIiE3Nd8')
p new_uri('https://youtu.be/ghwaIiE3Nd8')


