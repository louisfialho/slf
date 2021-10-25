require File.expand_path('config/environment', __dir__)

# get URL
url = "https://twitter.com/cdixon/status/1442201623338438659"
# extract tweet ID
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
author_id = JSON.parse(response.body)["data"][0]["author_id"]

params = {
  "query": "conversation_id:#{conversation_id} from:#{author_id} to:#{author_id}",
  "max_results": 100,
  "tweet.fields": "created_at"
}

options = {
  method: 'get',
  headers: {
    "User-Agent": "v2TweetLookupRuby",
    "Authorization": "Bearer #{ENV["BEARER_TOKEN"]}"
  },
  params: params
}

request = Typhoeus::Request.new("https://api.twitter.com/2/tweets/search/recent", options)

response = request.run

tweets = JSON.parse(response.body)["data"]

text_content = ""

tweets.reverse_each do |tweet|
  text_content += "\n #{tweet["text"]}"
end

# for each tweet in array, extract text (remove images etc), cleaner (e.g. 1/int) append 1 or 2 br + text to text_content

p text_content

#assigner à item text content

