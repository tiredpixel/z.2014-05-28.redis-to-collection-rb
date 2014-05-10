require 'set'

require_relative '../helper'
require_relative '../../lib/redis-to-collection/dumpling'


describe RedisToCollection::Dumpling do
  
  describe "#dump" do
    before do
      @redis = RedisToCollection::Test::Redis.connect
      
      @dumpling = RedisToCollection::Dumpling.new(@redis)
      
      @container = {
        :format  => RedisToCollection::Dumpling::CONTAINER_FORMAT,
        :version => RedisToCollection::Dumpling::CONTAINER_VERSION,
      }
    end
    
    after do
      RedisToCollection::Test::Redis.flush_namespace(@redis)
    end
    
    it "dumps STRING" do
      @redis.set("I will show you fear", "in a handful of dust.")
      
      @dumpling.dump.must_equal @container.merge({:data => [
        {
          :k => "I will show you fear",
          :t => :s,
          :v => "in a handful of dust.",
        },
      ]})
    end
    
    it "dumps HASH" do
      @redis.hmset("sections",
        "I.",   "THE BURIAL OF THE DEAD",
        "II.",  "A GAME OF CHESS",
        "III.", "THE FIRE SERMON",
        "IV.",  "DEATH BY WATER",
        "V.",   "WHAT THE THUNDER SAID"
      )
      
      @dumpling.dump.must_equal @container.merge({:data => [
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
      ]})
    end
    
    it "dumps LIST" do
      @redis.rpush("203", ["Twit", "twit", "twit", "Jug", "jug", "jug", "jug", "jug", "jug"])
      
      @dumpling.dump.must_equal @container.merge({:data => [
        {
          :k => "203",
          :t => :l,
          :v => ["Twit", "twit", "twit", "Jug", "jug", "jug", "jug", "jug", "jug"],
        },
      ]})
    end
    
    it "dumps SET" do
      @redis.sadd("canoe", ["Highbury", "Richmond", "Kew"])
      
      @dumpling.dump.must_equal @container.merge({:data => [
        {
          :k => "canoe",
          :t => :e,
          :v => ["Highbury", "Richmond", "Kew"],
        },
      ]})
    end
    
    it "dumps ZSET" do
      @redis.zadd("thunder", [
        [327, "Of thunder of spring over distant mountains"],
        [342, "But dry sterile thunder without rain"],
        [399, "Then spoke the thunder"],
      ])
      
      @dumpling.dump.must_equal @container.merge({:data => [
        {
          :k => "thunder",
          :t => :z,
          :v => [
            ["Of thunder of spring over distant mountains", 327],
            ["But dry sterile thunder without rain",        342],
            ["Then spoke the thunder",                      399],
          ],
        },
      ]})
    end
    
    it "dumps multiple" do
      @redis.set("Who is the third", "who walks always beside you?")
      
      @redis.rpush("363", ["Gliding", "wrapt", "in", "a", "brown", "mantle", "hooded"])
      
      dump1 = @dumpling.dump
      
      dump2 = @container.merge({:data => [
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
      ]})
      
      # ignore internal order
      dump1[:data] = dump1[:data].to_set
      dump2[:data] = dump2[:data].to_set
      
      dump1.must_equal dump2
    end
    
    it "dumps with pattern" do
      @dumpling = RedisToCollection::Dumpling.new(@redis, 'city*')
      
      @redis.set("What is the city", "over the mountains")
      
      @redis.sadd("city", ["Jerusalem", "Athens", "Alexandria", "Vienna", "London"])
      
      dump1 = @dumpling.dump
      
      dump2 = @container.merge({:data => [
        {
          :k => "city",
          :t => :e,
          :v => ["Jerusalem", "Athens", "Alexandria", "Vienna", "London"],
        },
      ]})
      
      dump1[:data].count.must_equal 1
      
      # ignore internal order
      dump1[:data].first[:v] = dump1[:data].first[:v].to_set
      dump2[:data].first[:v] = dump2[:data].first[:v].to_set
      
      dump1.must_equal dump2
    end
  end
  
end
