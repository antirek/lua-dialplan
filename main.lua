
local mongo = require 'mongo'
local inspect = require 'inspect'

local config = require('/home/sergey/Projects/lua-dialplan/config');


local db = mongo.Connection.New()
db:connect('localhost')
file = io.open("/tmp/q.txt", "a+")
io.output(file)


function getVpbxIdByPeername (peername)
	local q1 = db:query("test.peers", {peername = peername}):results();
	local settings = {
		["peer"] = q1{1};
	};

	app.noop("vpbxId: "..settings.peer.vpbxId)
	return settings.peer.vpbxId;
end;

function findTargetByExtensionAndVpbxId (extension, vpbxId)
	local q2 = db:query("test.extensions", {
		vpbxId = vpbxId, 
		extension = extension
	}):results();
	
	local settings = {
		["peers"] = q2;
	}
	return settings.peers{1}.target;
end;

function inner_call (context, extension)
	peername = channel.CHANNEL("peername"):get()
	name = channel.CALLERID("name"):get()
	num = channel.CALLERID("num"):get()
	all = channel.CALLERID("all"):get()
	app.noop("extension: "..extension)

	local vpbxId = getVpbxIdByPeername(peername);
	local target = findTargetByExtensionAndVpbxId(extension, vpbxId);

	app.noop('target: '..target["value"])
	
	if (target ~= '') then	
		app.dial(target["value"])
	else 
		app.hangup()
	end;

end;


local Dialplan = {
	getExtensions = function () 
		return {
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
	end;

	getHints = function ()
		return {

		};
	end;
};

return Dialplan;