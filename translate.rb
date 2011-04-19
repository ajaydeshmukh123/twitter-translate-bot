# coding: utf-8
require 'rubygems'
require 'yaml'
require 'twitter'
require 'nestful'

GOOGLE_TRANSLATE_URL    = 'https://www.googleapis.com/language/translate/v2'

credentials = YAML.load_file('credentials.yml')

GOOGLE_API_KEY             = credentials['GOOGLE_API_KEY']
TWITTER_CONSUMER_KEY       = credentials['TWITTER_CONSUMER_KEY']
TWITTER_CONSUMER_SECRET    = credentials['TWITTER_CONSUMER_SECRET']
TWITTER_OAUTH_TOKEN        = credentials['TWITTER_OAUTH_TOKEN']
TWITTER_OAUTH_TOKEN_SECRET = credentials['TWITTER_OAUTH_TOKEN_SECRET']

Twitter.configure do |config|
  config.consumer_key = TWITTER_CONSUMER_KEY
  config.consumer_secret = TWITTER_CONSUMER_SECRET
  config.oauth_token = TWITTER_OAUTH_TOKEN
  config.oauth_token_secret = TWITTER_OAUTH_TOKEN_SECRET
end

tweet_in_korean = Twitter.user_timeline("mingkki21").first.text

params = {
  key: GOOGLE_API_KEY,
  source: 'ko',
  target: 'en',
  q: tweet_in_korean
}

response = Nestful.get GOOGLE_TRANSLATE_URL, params: params
json = JSON.parse(response)
first_result = json['data']['translations'].first['translatedText']
puts "#{tweet_in_korean} -> #{first_result}"
