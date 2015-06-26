
local redis = require 'redis'

local host = "127.0.0.1"
local port = 6379

client = redis.connect(host, port)


--my = client.get('mykey')
my = 'hello'
peers = client:hgetall('peer')


print(peers)

for key, value in pairs(peers) do
	print(key, value)
	print(key, peers[key])
end;

print(peers["key"])