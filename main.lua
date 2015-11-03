local config = require('dialplan.config');
local db = require('dialplan.lib.db');
local inspect = require('inspect');

local dbHelper = db(config);

local inner = require('dialplan.lib.inner')(dbHelper);
local ivr = require('dialplan.lib.ivr')(dbHelper);
local queue = require('dialplan.lib.queue')(dbHelper);
local time = require('dialplan.lib.time')(dbHelper);
local services = require('dialplan.lib.services')(dbHelper);


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
    app['return']();
end;

function incoming (c, e, rule)
    --app.goto('queues,1200,1');
    app.noop('incoming'..c..e..inspect(rule));
    if (rule.target) then 
        app['goto'](rule.target);
    else 
        app.hangup();
    end;
end;

function getIncomingExtensions ()
    local extensions = dbHelper.getIncomingExtensions();

    local q = {};
    for key, rule in pairs(extensions) do
        q[key] = function (context, extension)
            incoming(context, extension, rule);
        end;
    end;
    return q;
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

            ["time"] = {
                ["_XXXX"] = time.time;
            };

            ["services"] = {
                ["*10"] = services.sayunixtime;
            };

            ["queues"] = {
                ["_XXXX"] = queue.call_queue;
            };
            
            ["inner"] = {
                ["_XXX"] = inner.call_device;
                ["_*XXX"] = inner.call_mobile;
                ["_XXXX"] = inner.call_device;
                ["_*XXXX"] = inner.call_mobile;
                --["h"] = hangupHandler;
            };

            ["hangups"] = {
                ["s"] = hangupHandler;
            };

            ["outbound"] = {
                ["112"] = emergency;
                ["_8XXXXXXXXXX"] = outbound;
            };

            ["incoming"] = getIncomingExtensions();
        };
    end;

    getHints = function ()
        return {

        };
    end;
};

return Dialplan;