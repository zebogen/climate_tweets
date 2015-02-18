class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.datetime :date_time
      t.integer :tweet_id
      t.string :text
      t.string :user_id
      t.string :screen_name
      t.integer :retweets
      t.timestamps
    end
  end
end
