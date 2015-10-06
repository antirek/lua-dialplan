
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