
function inner()
	return {
		["1200"] = inner_call("1200");
		["1300"] = inner_call("1300");
		["1400"] = inner_call("1400");
	}
end;


local conf = {
	["1200"] = "SIP/1234";
	["1300"] = "SIP/3333";
};


function inner2(t)
	local v = {}
	for key, value in pairs(t) do
    	v[key] = inner_call(value);
	end;
	return v
end;


function inner_call(e)
	return function ()
		app.playback('beep')
		app.noop(e)
		app.hangup()
	end;
end;


local D = {
	extensions = {
		["maga"] = inner2(conf);
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
