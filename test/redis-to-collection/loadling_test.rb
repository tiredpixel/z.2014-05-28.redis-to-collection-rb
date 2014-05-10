require 'set'

require_relative '../helper'
require_relative '../../lib/redis-to-collection/loadling'


describe RedisToCollection::Loadling do
  
  describe "#load" do
    before do
      @redis = RedisToCollection::Test::Redis.connect
      
      @loadling = RedisToCollection::Loadling.new(@redis)
    end
    
    after do
      RedisToCollection::Test::Redis.flush_namespace(@redis)
    end
    
    describe "redis-to-collection/1" do
      before do
        @container = {
          :format  => 'redis-to-collection',
          :version => 1,
        }
      end
      
      it "loads STRING" do
        @loadling.load(@container.merge({:data => [
          {
            :k => "I will show you fear",
            :t => :s,
            :v => "in a handful of dust.",
          },
        ]}))
        
        @redis.keys.count.must_equal 1
        
        @redis.get("I will show you fear").must_equal "in a handful of dust."
      end
      
      it "loads HASH" do
        @loadling.load(@container.merge({:data => [
          {
            :k => "sections",
            :t => :h,
            :v => {
              "I."   => "THE BURIAL OF THE DEAD",
              "II."  => "A GAME OF CHESS",
              "III." => "THE FIRE SERMON",
              "IV."  => "DEATH BY WATER",
              "V."   => "WHAT THE THUNDER SAID",
            },
          },
        ]}))
        
        @redis.keys.count.must_equal 1
        
        @redis.hgetall("sections").must_equal({
          "I."   => "THE BURIAL OF THE DEAD",
          "II."  => "A GAME OF CHESS",
          "III." => "THE FIRE SERMON",
          "IV."  => "DEATH BY WATER",
          "V."   => "WHAT THE THUNDER SAID",
        })
      end
      
      it "loads LIST" do
        @loadling.load(@container.merge({:data => [
          {
            :k => "203",
            :t => :l,
            :v => ["Twit", "twit", "twit", "Jug", "jug", "jug", "jug", "jug", "jug"],
          },
        ]}))
        
        @redis.keys.count.must_equal 1
        
        @redis.lrange("203", 0, -1).must_equal ["Twit", "twit", "twit", "Jug", "jug", "jug", "jug", "jug", "jug"]
      end
      
      it "loads SET" do
        @loadling.load(@container.merge({:data => [
          {
            :k => "canoe",
            :t => :e,
            :v => ["Highbury", "Richmond", "Kew"],
          },
        ]}))
        
        @redis.keys.count.must_equal 1
        
        @redis.smembers("canoe").to_set.must_equal ["Highbury", "Richmond", "Kew"].to_set
      end
      
      it "loads ZSET" do
        @loadling.load(@container.merge({:data => [
          {
            :k => "thunder",
            :t => :z,
            :v => [
              ["Of thunder of spring over distant mountains", 327],
              ["But dry sterile thunder without rain",        342],
              ["Then spoke the thunder",                      399],
            ],
          },
        ]}))
        
        @redis.keys.count.must_equal 1
        
        @redis.zrange("thunder", 0, -1, :withscores => true).must_equal [
          ["Of thunder of spring over distant mountains", 327],
          ["But dry sterile thunder without rain",        342],
          ["Then spoke the thunder",                      399],
        ]
      end
      
      it "loads multiple" do
        @loadling.load(@container.merge({:data => [
          {
            :k => "Who is the third",
            :t => :s,
            :v => "who walks always beside you?",
          },
          {
            :k => "363",
            :t => :l,
            :v => ["Gliding", "wrapt", "in", "a", "brown", "mantle", "hooded"],
          },
        ]}))
        
        @redis.keys.count.must_equal 2
        
        @redis.get("Who is the third").must_equal "who walks always beside you?"
        
        @redis.lrange("363", 0, -1).must_equal ["Gliding", "wrapt", "in", "a", "brown", "mantle", "hooded"]
      end
    end
  end
  
end
