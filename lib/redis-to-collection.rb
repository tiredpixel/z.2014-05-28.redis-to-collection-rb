require_relative 'redis-to-collection/version'
require_relative 'redis-to-collection/constants'
require_relative 'redis-to-collection/dumpling'
require_relative 'redis-to-collection/loadling'


module RedisToCollection
  
  def self.dump(redis, pattern = nil)
    RedisToCollection::Dumpling.new(redis, pattern).dump
  end
  
  def self.load(redis, container)
    RedisToCollection::Loadling.new(redis).load(container)
  end
  
end
