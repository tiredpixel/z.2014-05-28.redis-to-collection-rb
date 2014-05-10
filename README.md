# Redis To Collection (Ruby)

[![Gem Version](https://badge.fury.io/rb/redis-to-collection.png)](http://badge.fury.io/rb/redis-to-collection)
[![Build Status](https://travis-ci.org/tiredpixel/redis-to-collection-rb.png?branch=master,stable)](https://travis-ci.org/tiredpixel/redis-to-collection-rb)
[![Code Climate](https://codeclimate.com/github/tiredpixel/redis-to-collection-rb.png)](https://codeclimate.com/github/tiredpixel/redis-to-collection-rb)

[Redis](http://redis.io/) to a collection. There and back again.

Redis To Collection dumps Redis to and loads Redis from a collection. Only a
tiny subset of the Redis data structure is supported, and that is how it is
intended to remain. This is not supposed to be used as any form of backup
(please, please don't do this); rather, it is a very small tool to assist with
using fixtures in testing. To that end, the collection format is intentionally
verbose, and should be quite readable with a little practice.

More sleep lost by [tiredpixel](http://www.tiredpixel.com).


## Installation

Install using:

    gem 'redis-to-collection'

The default Ruby version supported is defined in `.ruby-version`.
Any other versions supported are defined in `.travis.yml`.


## Usage

Create a Redis connection and require Redis To Collection:

    require 'redis'
    
    redis = Redis.new
    
    require 'redis-to-collection'

Dump all Redis keys to a collection:

    collection = RedisToCollection.dump(redis)

Or dump a subset of Redis keys to a collection:

    collection = RedisToCollection.dump(redis, '*PATTERN*')

Load a collection to Redis:

    RedisToCollection.load(redis, collection)

That's it!


## Examples

Load the following example collection to Redis:

    collection = {:format=>"redis-to-collection", :version=>1, :data=>[{:k=>"And crawled head downward", :t=>:s, :v=>"down a blackened wall"}, {:k=>"The river bears no", :t=>:h, :v=>{"empty"=>"bottles", "sandwich"=>"papers", "silk"=>"handkerchiefs", "cardboard"=>"boxes", "cigarette"=>"ends"}}, {:k=>"London Bridge is", :t=>:l, :v=>["falling down", "falling down", "falling down"]}, {:k=>"165", :t=>:e, :v=>["HURRY", "UP", "PLEASE", "ITS", "TIME"]}, {:k=>"And if it rains", :t=>:z, :v=>[["The hot water", 10.0], ["a closed car", 4.0]]}]}
    
    RedisToCollection.load(redis, collection)

### JSON

Dump all Redis keys to create a JSON fixture:

    require 'json'
    
    puts JSON.pretty_generate(RedisToCollection.dump(redis))

    {
      "format": "redis-to-collection",
      "version": 1,
      "data": [
        {
          "k": "165",
          "t": "e",
          "v": [
            "ITS",
            "PLEASE",
            "UP",
            "HURRY",
            "TIME"
          ]
        },
        {
          "k": "And crawled head downward",
          "t": "s",
          "v": "down a blackened wall"
        },
        {
          "k": "The river bears no",
          "t": "h",
          "v": {
            "empty": "bottles",
            "sandwich": "papers",
            "silk": "handkerchiefs",
            "cardboard": "boxes",
            "cigarette": "ends"
          }
        },
        {
          "k": "London Bridge is",
          "t": "l",
          "v": [
            "falling down",
            "falling down",
            "falling down"
          ]
        },
        {
          "k": "And if it rains",
          "t": "z",
          "v": [
            [
              "a closed car",
              4.0
            ],
            [
              "The hot water",
              10.0
            ]
          ]
        }
      ]
    }

### YAML

Dump all Redis keys to create a YAML fixture:

    require 'yaml'
    
    puts RedisToCollection.dump(redis).to_yaml

    ---
    :format: redis-to-collection
    :version: 1
    :data:
    - :k: '165'
      :t: :e
      :v:
      - ITS
      - PLEASE
      - UP
      - HURRY
      - TIME
    - :k: And crawled head downward
      :t: :s
      :v: down a blackened wall
    - :k: The river bears no
      :t: :h
      :v:
        empty: bottles
        sandwich: papers
        silk: handkerchiefs
        cardboard: boxes
        cigarette: ends
    - :k: London Bridge is
      :t: :l
      :v:
      - falling down
      - falling down
      - falling down
    - :k: And if it rains
      :t: :z
      :v:
      - - a closed car
        - 4.0
      - - The hot water
        - 10.0


## Stay Tuned

We have a [Librelist](http://librelist.com) mailing list!
To subscribe, send an email to <redis.to.collection@librelist.com>.
To unsubscribe, send an email to <redis.to.collection-unsubscribe@librelist.com>.
There be [archives](http://librelist.com/browser/redis.to.collection/).
That was easy.

You can also become a [watcher](https://github.com/tiredpixel/redis-to-collection-rb/watchers)
on GitHub. And don't forget you can become a [stargazer](https://github.com/tiredpixel/redis-to-collection-rb/stargazers) if you are so minded. :D


## Contributions

Contributions are embraced with much love and affection!
Please fork the repository and wizard your magic.
Then send me a pull request. Simples!
If you'd like to discuss what you're doing or planning to do, or if you get
stuck on something, then just wave. :)

Do whatever makes you happy. We'll probably still like you. :)


## Blessing

May you find peace, and help others to do likewise.


## Licence

© [tiredpixel](http://www.tiredpixel.com) 2014.
It is free software, released under the MIT License, and may be redistributed
under the terms specified in `LICENSE`.
