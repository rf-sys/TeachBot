# redis connect to ENV['REDIS_URL'] or, otherwise, to localhost by default
$redis_connection = Redis.new