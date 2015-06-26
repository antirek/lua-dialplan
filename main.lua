
local redis = require 'redis'

local host = "127.0.0.1"
local port = 6379

client = redis.connect(host, port)
peers = client:hgetall('peer')

function inner(t)
	local v = {}
	for key, value in pairs(peers) do
    	v[key] = inner_call(value);
	end;
	return v
end;


function inner_call(e)
	return function ()
		--app.playback('beep')
		app.dial(e)
		app.noop('value')
		app.hangup()
	end;
end;


local D = {
	extensions = {
		["maga"] = {
			include = {'inner', 'outbound'}
		};
		["inner"] =inner(conf);
	};

	hints = {

	};
};


Dialplan = {
	getExtensions = function ()
		return D.extensions
	end;

	getHints = function ()
		return D.hints
	end;
};
