# coding: utf-8
$VERBOSE = nil # silence annoying warnings for posting UTF-8 chars in params
require 'rubygems'
require 'yaml'
require_relative 'lib/translator'

credentials = YAML.load_file('credentials.yml')

GOOGLE_API_KEY             = credentials['GOOGLE_API_KEY']
TWITTER_CONSUMER_KEY       = credentials['TWITTER_CONSUMER_KEY']
TWITTER_CONSUMER_SECRET    = credentials['TWITTER_CONSUMER_SECRET']
TWITTER_OAUTH_TOKEN        = credentials['TWITTER_OAUTH_TOKEN']
TWITTER_OAUTH_TOKEN_SECRET = credentials['TWITTER_OAUTH_TOKEN_SECRET']

Twitter.configure do |config|
  config.consumer_key       = TWITTER_CONSUMER_KEY
  config.consumer_secret    = TWITTER_CONSUMER_SECRET
  config.oauth_token        = TWITTER_OAUTH_TOKEN
  config.oauth_token_secret = TWITTER_OAUTH_TOKEN_SECRET
end

translator = Translator.new(google_api_key: GOOGLE_API_KEY, history_file: "minzy.txt")
translator.fetch
translator.translate!
translator.post_new_tweets
