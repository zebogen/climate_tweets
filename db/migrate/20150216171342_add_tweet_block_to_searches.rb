class AddTweetBlockToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :tweet_block, :array
  end
end
