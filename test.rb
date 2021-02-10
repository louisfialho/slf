require "net/http"

def working_url?(url_str)
    begin
      Net::HTTP.get_response(URI.parse(url_str)).is_a?(Net::HTTPSuccess)
    rescue
      false
    end
end

puts working_url?('https://www.yoube.com/watch?v=dEv99vxKjVI&ab_channel=LexFridman')
