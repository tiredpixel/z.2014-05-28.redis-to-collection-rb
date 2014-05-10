# Redis To Collection (Ruby) Changelog

This changelog documents the main changes between released versions.
For a full list of changes, consult the commit history.


## 0.1.0

- first release!
- dump all Redis keys (`RedisToCollection.dump(redis)`)
- dump some Redis keys (`RedisToCollection.dump(redis, '*PATTERN*')`)
- load to Redis (`RedisToCollection.load(redis, collection)`)
- support for Redis strings, hashes, lists, sets, sorted sets
