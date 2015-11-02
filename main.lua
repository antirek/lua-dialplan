local config = require('dialplan.config');
local db = require('dialplan.lib.db');

local dbHelper = db(config);

local inner = require('dialplan.lib.inner')(dbHelper);
local ivr = require('dialplan.lib.ivr')(dbHelper);
local queue = require('dialplan.lib.queue')(dbHelper);

function info ()
    peername = channel.CHANNEL("peername"):get();
    name = channel.CALLERID("name"):get();
    num = channel.CALLERID("num"):get();
    all = channel.CALLERID("all"):get();
end;

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
                include = {"ivr", "inner", "outbound", "services"};
            };

            ["ivr"] = {
                ["_XXX"] = ivr.menu;
            };

            ["services"] = {
                ["*10"] = alarm;
            };

            ["queues"] = {
                ["_XXXX"] = queue.call_queue;
            };
            
            ["inner"] = {
                ["_XXX"] = inner.call_device;
                ["_*XXX"] = inner.call_mobile;
                ["_XXXX"] = inner.call_device;
                ["_*XXXX"] = inner.call_mobile;
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