require_relative 'search'

search1 = Search.new("bla", "10")
search1.tweet_block = Search.pull_tweets(search1)

search1.tweet_block.each { |t| puts t["text"] }