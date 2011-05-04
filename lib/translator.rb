require 'twitter'
require 'nestful'

class Tweet
  attr_accessor :text, :status_id
  def initialize(status_id, text)
    @status_id = status_id
    @text = text
  end
end

class Translator

  def GOOGLE_TRANSLATE_URL
    'https://www.googleapis.com/language/translate/v2'
  end

  attr_accessor :history_file, :fetched, :GOOGLE_API_KEY, :translated_tweets

  def initialize(options = {})
    @history_file = options[:history_file]
    @GOOGLE_API_KEY = options[:google_api_key]
  end

  def fetch
    Twitter.user_timeline("mingkki21").tap { |t| @fetched = t }
  end

  def history
    read_history.split("\n").reverse
  end

  def new_tweets
    fetched.reject { |t| history.include?(t.id.to_s) }
  end

  def post_new_tweets
    translated_tweets.reverse.each do |t|
      begin
        Twitter.update(t.text)
        write_history(t)
      rescue
        puts "Error writing tweet with ID #{t.status_id}"
      end
    end
  end

  def translate!
    new_tweets.each do |t|
      params = {
        key: @GOOGLE_API_KEY,
        source: 'ko',
        target: 'en',
        q: t.text
      }
      response = Nestful.get self.GOOGLE_TRANSLATE_URL, params: params
      json  = JSON.parse(response)
      translated = json['data']['translations'].first['translatedText']
      translated.gsub!(/@ /, '@')
      translated_tweets << Tweet.new(t.id, translated)
    end
  end

  def translated_tweets
    @translated_tweets ||= []
  end

  private

  def read_history
    File.read(history_file)
  end

  def write_history(tweet)
    File.open(history_file, 'a') { |f| f.puts "#{tweet.status_id}\n" }
  end

end
