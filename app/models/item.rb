class Item < ApplicationRecord

  #acts_as_list
  require 'net/http'
  require 'uri'
  require 'open-uri'
  require 'nokogiri'
  require 'json' # tweet parsing
  require 'openssl'
  require 'typhoeus' # tweet parsing

  has_and_belongs_to_many :shelves
  has_and_belongs_to_many :spaces

  MEDIA = ['book', 'podcast', 'video', 'blogpost', 'newsletter', 'news_article', 'academic_article', 'tweet', 'thread', 'audio_book', 'code_repository', 'e_book', 'online_course', 'blog', 'web', 'other']

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
      self.position = 1
      if self.url.include? 'twitter.com'
        handle_tweet(self.url)
      else
        self.name = item_name(url) if name.blank?
        self.medium = item_medium(url) if medium.blank?
        unless ["video", "podcast", "tweet", "online_course", "book", "audio_book", "code_repository"].include?(self.medium)
          self.text_content = item_text_content(url) if text_content.blank?
        end
      end
    end

    def handle_tweet(url)

      tweet_id = url.match(/twitter\.com\/(?:#!\/)?(\w+)\/status(es)?\/(\d+)/)[3]

      params = {
        "ids": tweet_id,
        "tweet.fields": "conversation_id,author_id"
      }

      options = {
        method: 'get',
        headers: {
          "User-Agent": "v2TweetLookupRuby",
          "Authorization": "Bearer #{ENV["BEARER_TOKEN"]}"
        },
        params: params
      }

      request = Typhoeus::Request.new("https://api.twitter.com/2/tweets", options)

      response = request.run

      $conversation_id = JSON.parse(response.body)["data"][0]["conversation_id"]
      author_init_tweet = JSON.parse(response.body)["data"][0]["author_id"]

      params = {
        "ids": $conversation_id,
        "tweet.fields": "author_id,created_at"
      }

      options = {
        method: 'get',
        headers: {
          "User-Agent": "v2TweetLookupRuby",
          "Authorization": "Bearer #{ENV["BEARER_TOKEN"]}"
        },
        params: params
      }

      request = Typhoeus::Request.new("https://api.twitter.com/2/tweets", options)

      response = request.run

      $date = JSON.parse(response.body)["data"][0]["created_at"]
      $author_top_tweet = JSON.parse(response.body)["data"][0]["author_id"]
      text_init_tweet = JSON.parse(response.body)["data"][0]["text"]

      @tweets = []

      paginating(token=nil)

      text_content = text_init_tweet

      if @tweets.empty? == false
        @tweets = @tweets.flatten
        @tweets.reverse_each do |tweet|
          if ((tweet["conversation_id"] == $conversation_id) && (tweet["in_reply_to_user_id"] == $author_top_tweet) && (tweet["author_id"] == $author_top_tweet))
            text_content += "\n\n#{tweet["text"]}"
          end
        end
      end

      if text_content == text_init_tweet
        self.medium = "tweet"
      else
        self.medium = "thread"
      end
      self.name = text_init_tweet
      self.text_content = text_content
    end

    def paginating(token)
      if token.nil?
        params = {
          "exclude": "retweets",
          "since_id": $conversation_id,
          "end_time": (DateTime.parse($date) + 1).to_time.iso8601,
          "tweet.fields": "conversation_id,in_reply_to_user_id,created_at,author_id",
          "max_results": 100
        }
      else
        params = {
          "exclude": "retweets",
          "since_id": $conversation_id,
          "end_time": (DateTime.parse($date) + 1).to_time.iso8601,
          "tweet.fields": "conversation_id,in_reply_to_user_id,created_at,author_id",
          "max_results": 100,
          "pagination_token": token
        }
      end

      options = {
        method: 'get',
        headers: {
          "User-Agent": "v2TweetLookupRuby",
          "Authorization": "Bearer #{ENV["BEARER_TOKEN"]}"
        },
        params: params
      }

      request = Typhoeus::Request.new("https://api.twitter.com/2/users/#{$author_top_tweet}/tweets", options)

      response = request.run

      if JSON.parse(response.body).key?("data")
        @tweets << JSON.parse(response.body)["data"]
      end

      if JSON.parse(response.body)["meta"]["next_token"]
        paginating(JSON.parse(response.body)["meta"]["next_token"])
      end
    end

    def item_text_content(url) # Ujeebu API, 750 requests per month max
      request_url = 'https://lexper.p.rapidapi.com/v1.1/extract'

      query = {
          'url' =>  url,  # url to extract
          'text' =>  1.to_s, # return extracted text
          'html' =>  0.to_s, # extract html
          'media' =>  0.to_s, # extract media
          'feeds' =>  0.to_s, # do not extract RSS feeds
          'images' =>  0.to_s, # extract all images present in HTML
          'author' =>  0.to_s, # extract article's author
          'pub_date' =>  0.to_s, # extract article's publish date
          'js' =>  0.to_s,     # do not run js
          'js_wait' =>  0.to_s, # when JavaScript is enabled, indicates how many seconds the API should wait for the JS interpreter before starting the extraction.
          'strip_tags' =>  'form,style', #  tags to strip from the extracted HTML
          'timeout' =>  240.to_s #   request timeout in seconds.
      }

      headers = {
          'x-rapidapi-key' => ENV["RAPID_API_KEY"],
          'x-rapidapi-host' => ENV["RAPID_API_HOST"]
      }

      options  = {
          query: query,
          headers: headers
      }

      response = HTTParty.get(request_url, options)

      if response.code != 200
          puts "Bad status code #{response.code}"
      end

      return JSON.parse(response.body)["article"]["text"]
    end

    def item_name(url)
      html_file = URI.open(url)
      html_doc = Nokogiri::HTML(html_file, nil, Encoding::UTF_8.to_s) # should manage UTF8 html_doc.encoding = 'UTF-8'
      if url.include? 'www.youtube'
        item_name = html_doc.at('meta[name="title"]')['content'] # works for YouTube
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
      elsif ['spotify.com/episode', 'spotify.com/show', 'podcasts.apple', 'pca.st', 'podcasts.google', 'deezer.com/en/episode', 'podcast'].any? { |keyword| url.include? keyword }
        return 'podcast'
      elsif ['ww.amazon', 'ww.goodreads'].any? { |keyword| url.include? keyword }
        return 'book'
      elsif ['blog', 'medium.', 'towardsdatascience.com', 'stratechery.com', 'readthegeneralist.com', 'firstround.com', 'linkedin.com/pulse', 'paulgraham.com', 'mirror.xyz', 'item.to', 'darkblueheaven.com', 'dev.to'].any? { |keyword| url.include? keyword }
        return 'blogpost'
      elsif ['newsletter', 'substack.com', 'every.to', 'notboring.co'].any? { |keyword| url.include? keyword }
        return 'newsletter'
      elsif ['techcrunch.com', 'economist.com', 'news.ycombinator.com', 'nytimes.com', 'wsj.com', 'wired.com', 'ft.com', 'sifted.etu', 'bbc.com/news', 'lemonde.fr', 'entrepreneur.com'].any? { |keyword| url.include? keyword }
        return 'news_article'
      elsif ['wikipedia.org', 'technologyreview.com', 'hbr.org', 'whitepaper'].any? { |keyword| url.include? keyword }
        return 'academic_article'
      elsif ['audible', 'blinkist.com'].any? { |keyword| url.include? keyword }
        return 'audio_book'
      elsif ['coursera.org', 'edx.org', 'udacity.com', 'udemy.com'].any? { |keyword| url.include? keyword }
        return 'online_course'
      elsif url.include? 'github.com'
        return 'code_repository'
      else
        return 'blogpost'
      end
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
