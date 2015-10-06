
local mongo = require('mongo');
local inspect = require('inspect');

local db = mongo.Connection.New();
db:connect('localhost');

function getVpbxIdByPeername (peername)
    local q = db:query("test.peers", {peername = peername}):results();  
    local vpbxId = q{1}.vpbxId;
    
    app.noop("vpbxId: "..vpbxId);
    return vpbxId;
end;

function findTargetByExtensionAndVpbxId (extension, vpbxId)
    local q = db:query("test.extensions", {
        vpbxId = vpbxId, 
        extension = extension
    }):results();
    local target = q{1}.target;
    
    app.noop("target: "..inspect(target));
    return target;
end;

local d = {
    ["getVpbxIdByPeername"] = getVpbxIdByPeername;
    ["findTargetByExtensionAndVpbxId"] = findTargetByExtensionAndVpbxId; 
}

return d;