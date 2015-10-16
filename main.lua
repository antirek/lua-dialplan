
local config = require('dialplan.config');
local dbHelper = require('dialplan.lib.db');


function info ()
    peername = channel.CHANNEL("peername"):get()
    name = channel.CALLERID("name"):get()
    num = channel.CALLERID("num"):get()
    all = channel.CALLERID("all"):get()
end

function inner_call (target)
    -- info();
    
    if (target) then  
        app.dial(target, 10);        
    else 
        app.hangup(34);
    end;
    app.hangup();
end;

function inner_call_device (context, extension) 
    local device = dbHelper.findDeviceByExtension(extension);
    inner_call(device);
end;

function inner_call_mobile (context, extension) 
    local mobile = dbHelper.findMobileByExtension(extension);
    inner_call(mobile);
end

function hangupHandler (context, extension)
    app.noop('hangup handle');
    app.noop(context);
    local dialstatus = channel["DIALSTATUS"]:get();
    app.noop("dialstatus: "..dialstatus);
end;

local Dialplan = {
    getExtensions = function ()
        return {
            ["internal"] = {
                include = {"inner", "outbound", "services"};
            };

            ["ivr"] = {
                ["_XXX"] = ivr;
            };

            ["services"] = {
                ["*10"] = alarm;
            };
            
            ["inner"] = {                
                ["_XXX."] = inner_call_device;
                ["_*XXX."] = inner_call_mobile;
                ["h"] = hangupHandler;
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