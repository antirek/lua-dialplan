
local mongo = require 'mongo'
local db = mongo.Connection.New()
db:connect('localhost')

local inspect = require 'inspect'

file = io.open("/tmp/test.lua.log", "a+")
io.output(file)


function inner_call (context, extension)
	
	peername = channel.CHANNEL("peername"):get()
	name = channel.CALLERID("name"):get()
	num = channel.CALLERID("num"):get()
	all = channel.CALLERID("all"):get()
	app.noop("extension "..extension)

	local q1 = db:query("test.values", {peername = peername}):results();
	local settings = {
		["peer"] = q1{1};
	};

	app.noop("peer:"..settings.peer.vpbxId)
	
	local q2 = db:query("test.values", { vpbxId = settings.peer.vpbxId, peername = extension}):results();
	settings["peers"] = q2
	local target = settings.peers{1}.peername
	app.noop('target'..target)
	

	if (target ~= '') then
		--app.playback('beep')
		app.dial('SIP/'..target)
	else 
		app.hangup()
	end;

--[[ 
	app.noop("channel = "..peername)
	app.noop("callerid name = "..name)
	app.noop("callerid num = "..num)
	app.noop("callerid all = "..all)
	app.noop("callerid vpbxId = "..settings.peer.vpbxId)
	app.noop("callerid vpbx size = "..settings.peers)
	
	app.playback('beep')
	app.dial('SIP/'..extension)
	app.noop(context)
	app.noop(extension)
	app.hangup()

	]]

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
			['_XXXX'] = inner_call
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