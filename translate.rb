require 'rubygems'
require 'twitter'
require 'yaml'

credentials = YAML.load_file('credentials.yml')
YOUR_CONSUMER_KEY       = credentials['YOUR_CONSUMER_KEY']
YOUR_CONSUMER_SECRET    = credentials['YOUR_CONSUMER_SECRET']
YOUR_OAUTH_TOKEN        = credentials['YOUR_OAUTH_TOKEN']
YOUR_OAUTH_TOKEN_SECRET = credentials['YOUR_OAUTH_TOKEN_SECRET']

Twitter.configure do |config|
  config.consumer_key = YOUR_CONSUMER_KEY
  config.consumer_secret = YOUR_CONSUMER_SECRET
  config.oauth_token = YOUR_OAUTH_TOKEN
  config.oauth_token_secret = YOUR_OAUTH_TOKEN_SECRET
end

#Twitter.update("second post")
puts Twitter.user_timeline("mingkki21").first.text

