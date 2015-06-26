local base = _G
app_local = base.app



module('Factory')


Context = {}

Context.app = ""

function Context:setApp (appIn)
	self.app = appIn
end

function Context:getApp ()
	return self.app
end


local context = {}
base.setmetatable(context, {__index = Context})



function getName (name)	
	return name .. '.mp3'
end

function playback (app, filename)
	app.playback(filename)
end


--[[
function beep()
	base.channel['DIALPLAN_VAR']:set(getName("qw"))
	base.app.verbose(base.channel.DIALPLAN_VAR:get())
	playback(base.app, 'beep')
	base.app.dial("SIP/89135292926@sipnet")
	base.app.hangup()
end
]]--

beep = function ()
	app = context:getApp()
	app.answer()
	playback(app, 'beep')
end;

function getExtension (app)
	--base.print(app)
	context.setApp(app)

	--a = app;
	return {
		["1200"] = beep;
	}
end

