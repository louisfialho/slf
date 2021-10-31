require File.expand_path('config/environment', __dir__)

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

    url = "https://twitter.com/dickiebush/status/1416405127531991040"

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

      p @tweets

      text_content = text_init_tweet

      if @tweets.empty? == false
        @tweets = @tweets.flatten
        @tweets.reverse_each do |tweet|
          if ((tweet["conversation_id"] == $conversation_id) && (tweet["in_reply_to_user_id"] == $author_top_tweet) && (tweet["author_id"] == $author_top_tweet))
            text_content += "\n\n#{tweet["text"]}"
          end
        end
      end

      p text_content
