class UrlValidator < ActiveModel::EachValidator

  # summary: 3 steps:
  # 1. We extract the URL if there is one before validation, and end up with a string
  # 2. We test that the string is a valid url (here)
  # 3. We test that the valid url is a working url (here)

  require 'net/http'
  require 'uri'
  require 'open-uri'
  require 'nokogiri'

  def self.url?(value)
    uri = URI.parse(value)
    uri.is_a?(URI::HTTP) && !uri.host.nil?
  rescue URI::InvalidURIError
    false
  rescue URI::BadURIError
    false
  end

  def self.working_url?(url_str)
    if is_redirect?(url_str)
      url_str = final_url(url_str)
    end
    Net::HTTP.get_response(URI.parse(url_str)).is_a?(Net::HTTPSuccess)
    rescue
      false
  end

  def validate_each(record, attribute, value)
    if self.class.url?(value) == false # url: 'abc' is not validated
      record.errors.add(attribute, "is not a URL")
    elsif (self.class.url?(value) == true) && (self.class.working_url?(value) == false) # url: 'https://www.yoube.com/...' is not validated but 'https://youtu.be/8rXD5-xhemo' is.
      record.errors.add(attribute, "is not a valid URL")
    end
  end

  private

  def self.is_redirect?(url_str)
    Net::HTTP.get_response(URI.parse(url_str)).is_a?(Net::HTTPRedirection)
    rescue
      false
  end

  def self.final_url(url_str)
    URI.open(url_str) do |resp|
      return resp.base_uri.to_s
    end
  end

  # def validate_each(record, attribute, value)
  #   unless value.present? && self.class.compliant?(value) && self.class.working_url?(value)
  #     record.errors.add(attribute, "is not a valid HTTP URL")
  #   end
  # end
end
