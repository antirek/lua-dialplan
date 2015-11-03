local mongo = require('mongo');
local inspect = require('inspect');

function db (config)
    
    local db = mongo.Connection.New();
    db:connect(config.db.host);
    
    function getIncomingExtensions ()
        local query = db:query("viola.incoming");
        local exts = {};
        
        for result in query:results() do
            exts[result.extension] = result;
        end;
        
        return exts;
    end;

    function findDeviceByExtension (extension)
        app.noop('extension for find'..extension);
        local cursor = db:query("viola.extensions", {
            extension = extension
        });
        local item = cursor:next();
        local device;

        if (item) then
            device = item.device;
            app.noop("device: "..inspect(device));
        end;
        return device;
    end;

    function findMobileByExtension (extension)
        app.noop('extension for find: '..extension);
        local cursor = db:query("viola.extensions", {
            extension = string.sub(extension, 2);
        });
        local item = cursor:next();
        local mobile;
        
        if (item) then
            mobile = item.mobile;
            app.noop("mobile: "..inspect(mobile));
        end;
        return mobile;
    end;

    function checkRecord (peername)
        local device = 'SIP/'..peername;
        app.noop(device)
        local cursor = db:query("viola.extensions", {
            device = device
        });
        local item = cursor:next();
        app.noop(item)
        local record;

        if (item) then
            record = item.record;
        end;

        app.noop("record: "..record);
        return record;
    end;

    function findIVRByExtension (extension)
        app.noop('extension for find in ivr: '..extension);
        local cursor = db:query("viola.ivr", {
            extension = extension
        });
        local item = cursor:next();
        local menu;
        
        if (item) then
            menu = item;
            app.noop("ivr menu: "..inspect(menu));
        end;
        return menu;
    end;

    function findTimeByExtension(extension)
        app.noop("time"..extension);
        local cursor = db:query("viola.times", {
            extension = extension
        });

        local item = cursor:next();
        local time;

        if (item) then
            time = item;
            app.noop("time: "..inspect(time));
        end;
        return time;
    end;

    function findQueueByExtension (extension)
        app.noop('extension for find in queue: '..extension);
        local cursor = db:query("viola.queue", {
            extension = extension
        });
        local item = cursor:next();
        local queue;
        
        if (item) then
            queue = item;
            app.noop("queue: "..inspect(queue));
        end;
        return queue;
    end;

    return {
        ["findDeviceByExtension"] = findDeviceByExtension; 
        ["findMobileByExtension"] = findMobileByExtension;
        ["checkRecord"] = checkRecord;
        ["findIVRByExtension"] = findIVRByExtension;
        ["findQueueByExtension"] = findQueueByExtension;
        ["getIncomingExtensions"] = getIncomingExtensions;
        ["findTimeByExtension"] = findTimeByExtension;
    };

end;

return db;