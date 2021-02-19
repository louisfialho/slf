require 'net/http'
require 'uri'
require 'open-uri'
require 'nokogiri'

  def url?(value)
    uri = URI.parse(value)
    uri.is_a?(URI::HTTP) && !uri.host.nil?
  rescue URI::InvalidURIError
    false
  rescue URI::BadURIError
    false
  end

  def working_url?(url_str)
    if is_redirect?(url_str)
      url_str = final_url(url_str)
    end
    Net::HTTP.get_response(URI.parse(url_str)).is_a?(Net::HTTPSuccess)
    rescue
      false
  end

  def is_redirect?(url_str)
    Net::HTTP.get_response(URI.parse(url_str)).is_a?(Net::HTTPRedirection)
    rescue
      false
  end

  def final_url(url_str)
    URI.open(url_str) do |resp|
      return resp.base_uri.to_s
    end
  end

p url?('https://youtu.be/8rXD5-xhemo')
