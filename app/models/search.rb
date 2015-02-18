require_relative '/home/action/climate_tweets/app/controllers/twitterpull'

class Search < ActiveRecord::Base
  has_many :tweets, dependent: :destroy
  validates :query, presence: true
  validates :count, presence: true
  validates :tweet_block, presence: true
  
  def self.pull_tweets(search)
    TwitterPull.pull(search["query"], search["count"].to_i)
  end
  
end