require_relative 'constants'


module RedisToCollection
  class Dumpling
    
    CONTAINER_FORMAT  = 'redis-to-collection'.freeze
    CONTAINER_VERSION = 1
    
    def initialize(redis, pattern = nil)
      @redis   = redis
      @pattern = pattern || '*'
    end
    
    def dump
      container = {
        :format  => CONTAINER_FORMAT,
        :version => CONTAINER_VERSION,
        :data    => [],
      }
      
      @redis.keys(@pattern).each do |key|
        type = @redis.type(key).to_sym
        
        datum = {
          :k => key,
          :t => RedisToCollection::REDIS_TYPES[type],
          :v => send("dump_#{type}_value", key)
        }
        
        container[:data] << datum
      end
      
      container
    end
    
    private
    
    def dump_string_value(key)
      @redis.get(key)
    end
    
    def dump_hash_value(key)
      @redis.hgetall(key)
    end
    
    def dump_list_value(key)
      @redis.lrange(key, 0, -1)
    end
    
    def dump_set_value(key)
      @redis.smembers(key)
    end
    
    def dump_zset_value(key)
      @redis.zrange(key, 0, -1, :withscores => true)
    end
    
  end
end
