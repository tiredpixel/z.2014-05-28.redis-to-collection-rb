require_relative 'redis-to-collection/version'
require_relative 'redis-to-collection/constants'
require_relative 'redis-to-collection/dumpling'


module RedisToCollection
  
  def self.dump(redis, pattern = nil)
    RedisToCollection::Dumpling.new(redis, pattern).dump
  end
  
end
