require 'yelp'

Yelp.client.configure do |config|
  config.consumer_key = 'dCpGp51-37Rf-bmHLVFOPw'
  config.consumer_secret = '2Sa0MpY8FnuDOHu7f4ea13-Nu_8'
  config.token = 'qTDqHExUkSTyL-H09xlR4hclmVUZAd0a'
  config.token_secret = 'm7jd9Hhxii6Ad9PYPYrp4xBcdh8'
end

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
