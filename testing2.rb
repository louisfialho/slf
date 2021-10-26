require File.expand_path('config/environment', __dir__)

# LIMITED TO 3200 tweets for a given thread author

# next_token 7140dibdnow9c7btw3z2ge6gzb63vdf4414xfmzop916d


# input tweet

url = "https://twitter.com/DeepBlueCrypto/status/1442854657898991623"

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

conversation_id = JSON.parse(response.body)["data"][0]["conversation_id"]
author_init_tweet = JSON.parse(response.body)["data"][0]["author_id"]

# top tweet (might = input tweet)

params = {
  "ids": conversation_id,
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

date = JSON.parse(response.body)["data"][0]["created_at"]
author_top_tweet = JSON.parse(response.body)["data"][0]["author_id"]
text_init_tweet = JSON.parse(response.body)["data"][0]["text"]

# check que author top tweet = author init tweet? (sinon pas un thread)

# search
# jai le top tweet, sa date et auteur
# je cherche ts les tweets de cet auteur

params = {
  "exclude": "retweets",
  "since_id": conversation_id,
  "end_time": (DateTime.parse(date) + 1).to_time.iso8601,
  "tweet.fields": "conversation_id,in_reply_to_user_id,created_at,author_id",
  "max_results": 100
}

options = {
  method: 'get',
  headers: {
    "User-Agent": "v2TweetLookupRuby",
    "Authorization": "Bearer #{ENV["BEARER_TOKEN"]}"
  },
  params: params
}

request = Typhoeus::Request.new("https://api.twitter.com/2/users/#{author_top_tweet}/tweets", options)

response = request.run

tweets = JSON.parse(response.body)["data"]

p JSON.parse(response.body)

text_content = text_init_tweet

tweets.reverse_each do |tweet|
  if ((tweet["conversation_id"] == conversation_id) && (tweet["in_reply_to_user_id"] == author_top_tweet) && (tweet["author_id"] == author_top_tweet))
    text_content += "\n #{tweet["text"]}"
  end
end

p text_content

# paginate if needed using next_token
# add param pagination_token = next_token
# To receive all results, this process can be repeated until no next_token is included in the response.

# while next_token is included in the response ['meta']['next_token']
# extract content, extract next token
# make a call with next token


# order date asc (reverse)
