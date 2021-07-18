require 'json'
require 'httparty'

url = 'https://lexper.p.rapidapi.com/v1.1/extract'

query = {
    'url' =>  'https://1729.com/how-to-start-a-new-country/',  # url to extract
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
    'timeout' =>  20.to_s #   request timeout in seconds.
}

headers = {
    'x-rapidapi-key' => 'e09ea11b6amsh74eb3c011223295p1aa55bjsnc595811962a2',
    'x-rapidapi-host' => 'lexper.p.rapidapi.com'
}

options  = {
    query: query,
    headers: headers
}

response = HTTParty.get(url, options)

if response.code != 200
    puts "Bad status code #{response.code}"
end

puts JSON.parse(response.body)["article"]["text"]
