
function inner(dbHelper)

    function inner_call (target)        
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

    function call_device (context, extension) 
        local device = dbHelper.findDeviceByExtension(extension);
        inner_call(device);
    end;

    function call_mobile (context, extension) 
        local mobile = dbHelper.findMobileByExtension(extension);
        inner_call(mobile);
    end;

    return {
        ["call_device"] = call_device;
        ["call_mobile"] = call_mobile;
    }
end;

return inner;