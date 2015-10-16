
local config = require('dialplan.config');
local mongo = require('mongo');
local inspect = require('inspect');

local db = mongo.Connection.New();
db:connect(config.db.host);

function findTargetByExtension (extension)
    app.noop('extension for find'..extension);
    local cursor = db:query("viola.extensions", {        
        name = extension
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
    ["findTargetByExtension"] = findTargetByExtension; 
}

return d;