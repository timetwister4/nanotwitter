require_relative '../tweetprocessor.rb'

t= TweetProcessor.new

s = "I am a @potato"

puts t.make_links(s)
