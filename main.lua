local config = require('dialplan.config');
local dbHelper = require('dialplan.lib.db');

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

    local date = os.date();
    local peername = channel.CHANNEL("peername"):get();
    app.noop('peername: '..peername);

    local record = dbHelper.checkRecord(peername);

    if (record == 'yes') then
        local fname = string.format("%s-%s%s%s", v1, date.day, date.month, date.year)
        WAV = "/tmp/wav/"
        MP3 = string.format("/records/%s/%s/%s/", date.year, date.month, date.day)
        local monopt = string.format("/bin/nice -n 19 /usr/bin/lame -b 16 --silent %s%s.wav %s%s.mp3 && rm -f %s%s.wav",WAV,fname,MP3,fname,WAV,fname)
        app.mixmonitor(string.format("%s%s.wav,b,%s",WAV,fname,monopt))

        channel["CDR(recordingfile)"]:set(fname..".mp3")
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