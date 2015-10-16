
local config = require('dialplan.config');
local mongo = require('mongo');
local inspect = require('inspect');

local db = mongo.Connection.New();
db:connect(config.db.host);

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

local d = {
    ["findDeviceByExtension"] = findDeviceByExtension; 
    ["findMobileByExtension"] = findMobileByExtension;
    ["checkRecord"] = checkRecord;
};

return d;