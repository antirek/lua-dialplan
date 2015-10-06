
local mongo = require 'mongo'
local db = mongo.Connection.New()
db:connect('localhost')

local inspect = require 'inspect'

local config = require('/home/sergey/Projects/lua-dialplan/config');

file = io.open("/tmp/q.txt", "a+")
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
	
	local q2 = db:query("test.values", {
		vpbxId = settings.peer.vpbxId, 
		peername = extension
	}):results();
	
	settings["peers"] = q2
	local target = settings.peers{1}.peername
	app.noop('target'..target)
	
	if (target ~= '') then	
		app.dial('SIP/'..target)
	else 
		app.hangup()
	end;

end;


local D = {
	extensions = {
		["internal"] = {
			include = {"inner", "outbound"};			
		};

		["ivr"] = {
			["_XXX"] = ivr;
		};
		
		["inner"] = {
			["_XXX"] = inner_call;
			["_XXXX"] = inner_call;
		};

		["outbound"] = {
			["112"] = emergency;
			["_8XXXXXXXXXX"] = outbound;
		};

		["incoming"] = {
			["_XXXXXXXXXX"] = incoming;
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


return Dialplan;