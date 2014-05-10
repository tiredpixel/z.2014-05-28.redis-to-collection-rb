require 'minitest/autorun'
require 'securerandom'
require 'redis'
require 'redis-namespace'


module RedisToCollection
  module Test
    
    def self.config
      @config ||= {
        :redis => {
          :url       => ENV['REDIS_URL'],
          :namespace => 'redis-to-collection-rb:test',
        },
      }
    end
    
    module Redis
      
      def self.connect
        redis = ::Redis::Namespace.new(self.randomize_namespace,
          :redis => ::Redis.connect(
            :url => RedisToCollection::Test.config[:redis][:url]
          )
        )
        
        flush_namespace(redis) # very, very likely already empty
        
        redis
      end
      
      def self.flush_namespace(redis)
        # only namespaced keys removed because Redis::Namespace
        redis.keys('*').each { |k| redis.del(k) }
      end
      
      private
      
      def self.randomize_namespace
        "#{RedisToCollection::Test.config[:redis][:namespace]}:#{SecureRandom.hex}"
      end
      
    end
    
  end
end
