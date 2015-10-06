
local config = require('dialplan.config');
local dbHelper = require('dialplan.lib.db');

function inner_call (context, extension)
    peername = channel.CHANNEL("peername"):get()
    name = channel.CALLERID("name"):get()
    num = channel.CALLERID("num"):get()
    all = channel.CALLERID("all"):get()
    app.noop("extension: "..extension)

    local vpbxId = dbHelper.getVpbxIdByPeername(peername);
    local target = dbHelper.findTargetByExtensionAndVpbxId(extension, vpbxId);
    
    if (target) then  
        app.dial(target["value"], 10);

        local dialstatus = channel["DIALSTATUS"]:get();

        app.noop("dialstatus: "..dialstatus);

    else 
        app.hangup(34);
    end;
    app.hangup();
end;

function hangupHandler (context, extension)
    app.noop('hangup handle');
    app.noop(context);
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