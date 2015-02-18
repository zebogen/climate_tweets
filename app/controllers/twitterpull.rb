require 'oauth'
require 'json'

module TwitterPull
  
  def TwitterPull.pull(inp_query, inp_count)

    consumer_key = OAuth::Consumer.new(
      "wcs1zGACZ8pBMLGUWDJwLvVPt",
      "q2OycC0G2cFNBZrkqP5Z2UXClDlcg63BqDEMP9OrRGeYZoCX5v")
    access_token = OAuth::Token.new(
      "1628440405-T5dufqnbYGMZ8kYOkHMvZaiE6b6lM4vCTDByBUG",
      "xCyHQ1bgcgsJ2tKBTPn4NISHQZWB6xJtaRBaqo3W6sdhH")

    baseurl = "https://api.twitter.com"
    path    = "/1.1/search/tweets.json"
    query   = URI.encode_www_form(
      "q" => inp_query,
      "count" => 100
    )
    address = URI("#{baseurl}#{path}?#{query}")
    request = Net::HTTP::Get.new address.request_uri
    tweets = nil
    tweet_max = inp_count
    total_tweets = 0
    tweet_block = []

    # Set up HTTP.
    http             = Net::HTTP.new address.host, address.port
    http.use_ssl     = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER

    # Issue the request.
    request.oauth! http, consumer_key, access_token
    http.start
    response = http.request request
    puts response

    while total_tweets < tweet_max and response.code == '200' do
      
      tweet_count = 0
      tweets = JSON.parse(response.body)
      max_id = tweets["statuses"][0]["id"]
      tweets["statuses"].each do |t|
        max_id = t["id"] if t["id"] < max_id
        tweet_count += 1
     #   userhash = t["user"]
     #   tweethash = {
     #     "id" => t["id"],
     #     "text" => t["text"],
     #     "user" => userhash["screen_name"],
     #     "time" => t["created_at"]
     #   }
     #   tweet_block << tweethash
        tweet_block << t["text"]
      end
      
      total_tweets += tweet_count
      
      query = URI.encode_www_form(
        "q" => inp_query,
        "count" => 100,
        "max_id" => max_id
      )
      address = URI("#{baseurl}#{path}?#{query}")
      request = Net::HTTP::Get.new address.request_uri

      request.oauth! http, consumer_key, access_token
      response = http.request request

      while response.code == '429' do
        puts "Too many requests... sleeping for 15 seconds."
        sleep 15
        request.oauth! http, consumer_key, access_token
        response = http.request request
      end

    end

    puts response if response.code != '200'

    return tweet_block
  end
end