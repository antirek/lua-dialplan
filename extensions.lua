--[[
-- Sample using extensions.lua
-- copy extensions.lua in /etc/asterisk or create symlink
]]

local Dialplan = require('dialplan.main');
extensions = Dialplan.getExtensions();