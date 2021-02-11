require 'net/http'
require 'telegram/bot'
require 'uri'
require 'open-uri'
require 'nokogiri'

def working_url?(url_str)
  begin
    Net::HTTP.get_response(URI.parse(url_str)).is_a?(Net::HTTPSuccess)
  rescue
    false
  end
end

def final_url(url_str)
  open(url_str) do |resp|
    return resp.base_uri.to_s
  end
end

p working_url?('https://youtu.be/zR11FLZ-O9M')

# https://youtu.be/zR11FLZ-O9M
# URLs that need to be redirected do not yield HTTPSuccess.
# For URLs that need to be redirected, we need to find the final redirection first.
# First check if a URL needs to be redirected
# If it needs to, find the final url.
# Then check if the final_url is working as usual
# If it does need to be redirected, check if it is a working_url
