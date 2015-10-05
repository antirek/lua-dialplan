
local mongo = require 'mongo'
local db = mongo.Connection.New()
db:connect('localhost')


file = io.open("/tmp/test.lua.log", "a+")
io.output(file)

function inner_call (context, extension)
	-- local c1 = db:count('test.values')
	-- io.write('count')
	-- io.write(c1)
	if (extension:len() == 4) then 
		app["goto"]('outbound', extension, 1);  --its goto to native dialplan of asterisk
	end;

	local peername = channel.CHANNEL("peername"):get()
	name = channel.CALLERID("name"):get()
	num = channel.CALLERID("num"):get()
	all = channel.CALLERID("all"):get()
	
	app.noop("channel = "..peername)
	app.noop("callerid name = "..name)
	app.noop("callerid num = "..num)
	app.noop("callerid all = "..all)
	
	app.playback('beep')
	app.dial('SIP/'..extension)
	app.noop(context)
	app.noop(extension)
	app.hangup()
end;


local D = {
	extensions = {
		["maga"] = {
			include = {'inner', 'outbound2'};			
		};
		
		["inner"] = {
			["_XXX"] = inner_call
		};

		["outbound2"] = {
			['_XXXX'] = inner_call;
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