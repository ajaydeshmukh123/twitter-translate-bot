require 'translator'

describe Translator do

  before { Twitter.stub(:update) }
  before { Nestful.stub(:get) }
  before { translator.stub(:read_history).and_return(old_tweets) }

  let(:translator) { Translator.new }
  subject { translator }

  it { should be }

  let(:translated) { double(:translated, text: "tres", status_id: 3) }
  let(:translated_response) {
    '{
        "data": {
            "translations": [
                {
                    "translatedText": "tres"
                }
            ]
        }
    }'
  }

  let(:fetched_new_tweet) { double(:fetched_new_tweet, id: 3, text: "three") }
  let(:fetched_old_tweet) { double(:fetched_old_tweet, id: 2) }
  let(:tweets) { [fetched_new_tweet, fetched_old_tweet] }
  let(:old_tweets) { "1\n2" }

  before do
    Twitter.stub(:user_timeline).with("mingkki21").and_return(tweets)
  end

  describe "initialization" do
    let(:history_file) { double(:history_file) }
    let(:google_api_key) { double(:google_api_key) }
    subject { Translator.new(history_file: history_file, google_api_key: google_api_key) }
    its(:history_file) { should == history_file }
    its(:GOOGLE_API_KEY) { should == google_api_key }
  end

  describe ".fetch" do
    before { translator.fetch }
    its(:fetched) { should == tweets }
  end

  describe "getting known tweets" do
    before { translator.stub(:read_history).and_return(old_tweets) }

    subject { translator.history }
    it { should == ["2", "1"] }
  end

  describe "determining new tweets" do
    before { translator.stub(:read_history).and_return(old_tweets) }
    before { translator.fetch }
    subject { translator.new_tweets }
    it { should == [fetched_new_tweet] }
  end

  describe "posting new tweets" do
    before { translator.translated_tweets = [translated] }
    before { Twitter.should_receive(:update).with(translated.text) }
    let(:new_tweets) { translator.new_tweets }

    context "when successful" do
      it "writes successfully posted tweets to a file" do
        translator.should_receive(:write_history).with(translated)
        translator.post_new_tweets
      end
    end
  end

  describe "translating tweets" do
    let(:params) { {key: translator.GOOGLE_API_KEY, source: 'ko', target: 'en', q: fetched_new_tweet.text } }
    before { translator.fetch }
    before { Nestful.should_receive(:get).with(translator.GOOGLE_TRANSLATE_URL, params: params).and_return(translated_response) }
    it do
      translator.translate!
      tweet = translator.translated_tweets.first
      tweet.text.should == translated.text
      tweet.status_id.should == translated.status_id
    end
  end
end
