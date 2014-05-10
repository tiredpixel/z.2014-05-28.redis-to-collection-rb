module RedisToCollection
  
  REDIS_TYPES = {
    :string => :s,
    :hash   => :h,
    :list   => :l,
    :set    => :e,
    :zset   => :z,
  }.freeze
  
end
