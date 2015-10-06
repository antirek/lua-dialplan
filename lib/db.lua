
local config = require('dialplan.config');
local mongo = require('mongo');
local inspect = require('inspect');

local db = mongo.Connection.New();
db:connect(config.db.host);

function getVpbxIdByPeername (peername)
    local cursor = db:query("test.peers", {peername = peername});
    local item = cursor:next();
    local vpbxId;
    if (item) then
        vpbxId = item.vpbxId;
    end;
    
    app.noop("vpbxId: "..vpbxId);
    return vpbxId;
end;

function findTargetByExtensionAndVpbxId (extension, vpbxId)
    local cursor = db:query("test.extensions", {
        vpbxId = vpbxId, 
        extension = extension
    });
    local item = cursor:next();
    local target;
    
    if (item) then
        target = item.target;
        app.noop("target: "..inspect(target));
    end;
    return target;
end;

local d = {
    ["getVpbxIdByPeername"] = getVpbxIdByPeername;
    ["findTargetByExtensionAndVpbxId"] = findTargetByExtensionAndVpbxId; 
}

return d;