require 'json'

require_relative 'helper'
require_relative '../lib/redis-to-collection'


describe RedisToCollection do
  
  before do
    @redis = RedisToCollection::Test::Redis.connect
    
    @container = {
      :format  => 'redis-to-collection',
      :version => 1,
    }
    
    @data = [
      {
        :k => "And crawled head downward",
        :t => :s,
        :v => "down a blackened wall",
      },
      {
        :k => "The river bears no",
        :t => :h,
        :v => {
          "empty"     => "bottles",
          "sandwich"  => "papers",
          "silk"      => "handkerchiefs",
          "cardboard" => "boxes",
          "cigarette" => "ends",
        },
      },
      {
        :k => "London Bridge is",
        :t => :l,
        :v => ["falling down", "falling down", "falling down"],
      },
      {
        :k => "165",
        :t => :e,
        :v => ["HURRY", "UP", "PLEASE", "ITS", "TIME"],
      },
      {
        :k => "And if it rains",
        :t => :z,
        :v => [
          ["The hot water", 10.0],
          ["a closed car",  4.0], 
        ],
      },
    ]
    
    @dump = @container.merge({:data => @data})
  end
  
  after do
    RedisToCollection::Test::Redis.flush_namespace(@redis)
  end
  
  describe "::dump" do
    it "dumps dump of correct length" do
      @loadling = RedisToCollection::Loadling.new(@redis)
      
      @loadling.load(@dump)
      
      dump2 = RedisToCollection.dump(@redis)
      
      dump2.to_json.length.must_equal @dump.to_json.length
    end
  end
  
  describe "::load" do
    it "loads dump of correct keys count" do
      RedisToCollection.load(@redis, @dump)
      
      @redis.keys.count.must_equal 5
    end
  end
  
end
