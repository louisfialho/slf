class Item < ApplicationRecord

  #acts_as_list
  require 'net/http'
  require 'uri'
  require 'open-uri'
  require 'nokogiri'
  require 'json' # tweet parsing
  require 'typhoeus' # tweet parsing

  has_and_belongs_to_many :shelves
  has_and_belongs_to_many :spaces

  MEDIA = ['book', 'podcast', 'video', 'blogpost', 'newsletter', 'news_article', 'academic_article', 'tweet', 'audio_book', 'code_repository', 'e_book', 'online_course', 'blog', 'web', 'other']

  before_validation :extract_url, :get_redirect_if_exists, on: :create # makes sure the persisted value is a url (no additional character), and, in case of a redirect, the final redirect
  validates :url, presence: true, url: true # see custom class
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
      self.medium = item_medium(url) if medium.blank?
      self.position = 1
    end

    def item_name(url)
      html_file = URI.open(url)
      html_doc = Nokogiri::HTML(html_file, nil, Encoding::UTF_8.to_s) # should manage UTF8 html_doc.encoding = 'UTF-8'
      if url.include? 'www.youtube'
        item_name = html_doc.at('meta[name="title"]')['content'] # works for YouTube
      elsif url.match?(/twitter\.com\/(?:#!\/)?(\w+)\/status(es)?\/(\d+)/)  # matches https://twitter.com/username/status/1047925106423603200
        if tweet_name(url).include? 'https'
          item_name = tweet_name(url).gsub(/(?:f|ht)tps?:\/[^\s]+/, '')
        else
          item_name = tweet_name(url)
        end
      else
        item_name = html_doc.css('head title').inner_text # works for spotify and more
      # does not work for Techcrunch
      end
      return item_name #split.map(&:capitalize).join(' ') # caps each word
    rescue
      "No name found"
    end

    def item_medium(url)
      if url.include? 'www.youtube'
        return 'video'
      elsif ['spotify.com/episode', 'spotify.com/show', 'podcasts.apple', 'pca.st', 'podcasts.google'].any? { |keyword| url.include? keyword }
        return 'podcast'
      elsif ['ww.amazon', 'ww.goodreads'].any? { |keyword| url.include? keyword }
        return 'book'
      elsif ['blog', 'medium.com', 'stratechery.com', 'linkedin.com/pulse', 'paulgraham.com', 'mirror.xyz', 'item.to', 'darkblueheaven.com', 'dev.to'].any? { |keyword| url.include? keyword }
        return 'blogpost'
      elsif ['newsletter', 'substack.com', 'every.to', 'notboring.co'].any? { |keyword| url.include? keyword }
        return 'newsletter'
      elsif ['techcrunch.com', 'news.ycombinator.com', 'nytimes.com', 'wsj.com', 'wired.com', 'ft.com', 'sifted.etu', 'bbc.com/news'].any? { |keyword| url.include? keyword }
        return 'news_article'
      elsif ['wikipedia.org', 'technologyreview.com', 'hbr.org', 'whitepaper'].any? { |keyword| url.include? keyword }
        return 'academic_article'
      elsif url.include? 'twitter.com'
        return 'tweet'
      elsif ['audible', 'blinkist.com'].any? { |keyword| url.include? keyword }
        return 'audio_book'
      elsif ['coursera.org', 'edx.org', 'udacity.com'].any? { |keyword| url.include? keyword }
        return 'online_course'
      elsif url.include? 'github.com'
        return 'code_repository'
      else
        return 'other'
      end
    end

    def tweet_name(url)
      # takes URL as input, and outputs name of the tweet object
      tweet_id = url.match(/twitter\.com\/(?:#!\/)?(\w+)\/status(es)?\/(\d+)/)[3]

      bearer_token = ENV["BEARER_TOKEN"]
      tweet_lookup_url = "https://api.twitter.com/2/tweets"

      params = {
        "ids": tweet_id,
        # "expansions": "author_id" #referenced_tweets.id
        # "tweet.fields": "attachments,author_id,conversation_id,created_at,entities,geo,id,in_reply_to_user_id,lang",
        # "user.fields": "name"
        # "media.fields": "url",
        # "place.fields": "country_code",
        # "poll.fields": "options"
      }

      response = tweet_lookup(tweet_lookup_url, bearer_token, params)
      return JSON.parse(response.body)['data'][0]['text']
    end

    def tweet_lookup(url, bearer_token, params)
      options = {
        method: 'get',
        headers: {
          "User-Agent": "v2TweetLookupRuby",
          "Authorization": "Bearer #{bearer_token}"
        },
        params: params
      }

      request = Typhoeus::Request.new(url, options)
      response = request.run

      return response
    end
end


# User input, peut être dirty
# 1. Before val:
# -extraction url si il y a: on persiste l'url
# -redirection url si il y a: on persiste le final redirect.
# 2. During val:
# -si pas un url: error
# -si url marche pas: error
# 3. After val:
# -on a un url qui marche, et si redirect redirect.
# -on prend le name et medium a partir de cet url.
