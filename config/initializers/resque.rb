# redis connect to ENV['REDIS_URL'] or, otherwise, to localhost by default
Resque.redis = Redis.new