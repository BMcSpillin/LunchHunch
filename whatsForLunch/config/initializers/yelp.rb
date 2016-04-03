require 'yelp'

client = Yelp::Client.new({
          consumer_key: ENV['YELP_CONSUMER_KEY']
          consumer_secret: ENV['YELP_CONSUMER_SECRET']
          token: ENV['YELP_TOKEN']
          token_secret: ENV['YELP_TOKEN_SECRET']
          })
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
# Yelp.client.search('', { term: 'food' })
  