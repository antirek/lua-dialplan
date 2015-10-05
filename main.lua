
local mongo = require 'mongo'
local db = mongo.Connection.New()
db:connect('localhost')

file = io.open("/tmp/test.lua.log", "a+")
io.output(file)

function inner_call()
	return function (context, extension)
		local c1 = db:count('test.values')
		io.write('count')
		io.write(c1)
		
		app.playback('beep')
		app.dial('SIP/'..extension)
		app.noop(context)
		app.noop(extension)
		app.hangup()
	end;
end;


local D = {
	extensions = {
		["maga"] = {
			include = {'inner', 'outbound'};
		};
		
		["inner"] = {
			["_XXX"] = inner_call()
		};
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