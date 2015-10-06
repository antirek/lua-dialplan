--[[
-- Sample using extensions.lua
-- copy extensions.lua in /etc/asterisk or create symlink
]]

local Dialplan = require('/home/sergey/Projects/lua-dialplan/main');
extensions = Dialplan.getExtensions();