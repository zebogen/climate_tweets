require_relative 'twitterpull'

tweet_block = TwitterPull.pull("foo", 10)

tweet_block.each { |t| puts t["text"] }