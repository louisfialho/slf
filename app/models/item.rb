class Item < ApplicationRecord

  require 'net/http'
  require 'uri'
  require 'open-uri'
  require 'nokogiri'

  has_and_belongs_to_many :shelves
  has_and_belongs_to_many :spaces

  MEDIUM = ['book', 'podcast', 'video', 'web', 'other']
  STATUS = [1, 2, 3] # 1 = not started
  RANK = [1, 2, 3] # 1 = high prio

  validates :url, presence: true, url: true # see custom class
  validates :rank, :inclusion => 1..3, allow_nil: true
  validates :status, :inclusion => 1..3, allow_nil: true

  before_validation :extract_url, :get_redirect_if_exists, on: :create # makes sure the persisted value is a url (no additional character), and, in case of a redirect, the final redirect
  after_validation :set_params

  private

    def extract_url # if the url passed by the user contains text, it's up to us to handle it and extract only the URL, before we validate it
      if url.to_s.downcase.include? "http"
        self.url = URI.extract(url.to_s, ['http', 'https']).first
      end
    end

    def get_redirect_if_exists
      if is_redirect?(url)
        self.url = final_url(url)
      end
    end

    def is_redirect?(url)
      Net::HTTP.get_response(URI.parse(url)).is_a?(Net::HTTPRedirection)
      rescue
        false
    end

    def final_url(url)
      URI.open(url) do |resp|
        return resp.base_uri.to_s
      end
    end

    def set_params
      self.name = item_name(url) if name.blank?
      self.medium = "other" if medium.blank?
      self.status = 1 if status.blank?
      self.rank = 2 if rank.blank?
    end

    def item_name(url)
      html_file = URI.open(url)
      html_doc = Nokogiri::HTML(html_file)
      if url.include? 'www.youtube'
        return html_doc.at('meta[name="title"]')['content'] # works for YouTube
      else
        return html_doc.css('head title').inner_text # works for spotify and more
      # does not work for Techcrunch
      end
    rescue
      "No name found"
    end
end
