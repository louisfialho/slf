require 'net/http'
require 'telegram/bot'
require 'uri'
require 'open-uri'
require 'nokogiri'


def is_redirect?(url_str)
  Net::HTTP.get_response(URI.parse(url_str)).is_a?(Net::HTTPRedirection)
end

def final_url(url_str)
  open(url_str) do |resp|
    return resp.base_uri.to_s
  end
end

def working_url?(url_str)
    begin
      Net::HTTP.get_response(URI.parse(url_str)).is_a?(Net::HTTPSuccess)
    rescue
      false
    end
end

def item_name(url)
  html_file = URI.open(url)
  html_doc = Nokogiri::HTML(html_file)
  if url.include? 'www.youtube'
    return html_doc.at('meta[name="title"]')['content'] # works for YouTube
  else
    return html_doc.css('head title').inner_text # works for spotify and more
  end
  # does not work for Techcrunch
end

p item_name(final_url('https://youtu.be/zR11FLZ-O9M'))
#p working_url?(final_url('https://youtu.be/zR11FLZ-O9M'))
