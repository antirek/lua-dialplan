local config = require('dialplan.config');
local db = require('dialplan.lib.db');

local dbHelper = db(config);

function info ()
    peername = channel.CHANNEL("peername"):get();
    name = channel.CALLERID("name"):get();
    num = channel.CALLERID("num"):get();
    all = channel.CALLERID("all"):get();
end;

function inner_call (target)
    -- info();
    checkRecord();

    if (target) then  
        app.dial(target, 10);        
    else 
        app.hangup(34);
    end;
    app.hangup();
end;

function checkRecord ()
    local date = os.date("*t");
    local peername = channel.CHANNEL("peername"):get();
    app.noop('peername: '..peername);

    local recordCalled = dbHelper.checkRecord(peername);
    local unique = channel.UNIQUEID:get();

    if (recordCalled == 'yes') then
        local fname = string.format("%s-%s%s%s", unique, date.day, date.month, date.year);
        WAV = "/tmp/wav/";
        MP3 = string.format("/tmp/records/%s/%s/%s/", date.year, date.month, date.day);
        local options = string.format("/usr/bin/nice -n 19 /usr/bin/lame -b 16 --silent %s%s.wav %s%s.mp3 && rm -f %s%s.wav", WAV, fname, MP3, fname, WAV, fname);
        app.mixmonitor(string.format("%s%s.wav,b,%s", WAV, fname, options));

        channel["CDR(recordingfile)"]:set(fname..".mp3");
    end;
    return;
end;

function inner_call_device (context, extension) 
    local device = dbHelper.findDeviceByExtension(extension);
    inner_call(device);
end;

function inner_call_mobile (context, extension) 
    local mobile = dbHelper.findMobileByExtension(extension);
    inner_call(mobile);
end;

function hangupHandler (context, extension)
    app.noop('hangup handle');
    app.noop(context);
    local dialstatus = channel["DIALSTATUS"]:get();
    app.noop("dialstatus: "..dialstatus);
end;

function ivr (context, extension)
    local menu = dbHelper.findIVRByExtension(extension);
    app.answer();
    app.read('CHOICE', menu.filename);
    local choice = channel['CHOICE']:get();
    app.noop('choice: '..choice);
    if (choice) then
        local i = 1;
        while menu.choices[i] do
            --app.noop(menu.choices[i].key)
            if (menu.choices[i].key == choice) then 
                break
            end;
            i = i + 1
        end;
        local action = menu.choices[i].action;
        app.noop('action: '..action);
        app["goto"](action);
    end;
end;


function queues (context, extension)
    local queue = dbHelper.findQueueByExtension(extension);
    app.noop('queue:'..queue.name);
    app.queue(queue.name);
end;

local Dialplan = {
    getExtensions = function ()
        return {
            ["internal"] = {
                include = {"ivr", "inner", "outbound", "services"};
            };

            ["ivr"] = {
                ["_XXX"] = ivr;
            };

            ["services"] = {
                ["*10"] = alarm;
            };

            ["queues"] = {
                ["_XXXX"] = queues;
            };
            
            ["inner"] = {                
                ["_XXX"] = inner_call_device;
                ["_*XXX"] = inner_call_mobile;
                ["_XXXX"] = inner_call_device;
                ["_*XXXX"] = inner_call_mobile;
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