require_relative '../helper'
require_relative '../../lib/redis-to-collection/version'


describe "RedisToCollection::VERSION" do
  
  it "uses major.minor.patch" do
    RedisToCollection::VERSION.must_match /\A\d+\.\d+\.\d+\z/
  end
  
end
