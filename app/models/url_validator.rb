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
    rescue
      false
  # rescue URI::InvalidURIError
  #   false
  # rescue URI::BadURIError
  #   false
  end

  # def self.working_url?(url_str)
  #   url = URI.parse(url_str)
  #   Net::HTTP.start(url.host, url.port) do |http|
  #     http.head(url.request_uri).code != 404
  #   end
  # rescue
  #   false
  # end

  def validate_each(record, attribute, value)
    if self.class.url?(value) == false # url: 'abc' is not validated
      record.errors.add(attribute, "is not a URL")
    end
  end

  # def validate_each(record, attribute, value)
  #   unless value.present? && self.class.compliant?(value) && self.class.working_url?(value)
  #     record.errors.add(attribute, "is not a valid HTTP URL")
  #   end
  # end
end
