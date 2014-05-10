require_relative 'constants'


module RedisToCollection
  class Loadling
    
    def initialize(redis)
      @redis = redis
    end
    
    def load(container)
      format = container[:format].tr('-', '_')
      
      send("load_#{format}_#{container[:version]}", container)
    end
    
    private
    
    def load_redis_to_collection_1(container)
      container[:data].each do |datum|
        type = RedisToCollection::REDIS_TYPES.key(datum[:t])
        
        send("load_#{type}", datum[:k], datum[:v])
      end
    end
    
    def load_string(key, value)
      @redis.set(key, value)
    end
    
    def load_hash(key, value)
      @redis.hmset(key, value.to_a.flatten)
    end
    
    def load_list(key, value)
      @redis.rpush(key, value)
    end
    
    def load_set(key, value)
      @redis.sadd(key, value)
    end
    
    def load_zset(key, value)
      @redis.zadd(key, value.map(&:reverse))
    end
    
  end
end
