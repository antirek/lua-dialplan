package = "dialplan"
version = "0.0.1"
source = {
  url = "https://github.com/antirek/lua-dialplan",
  tag = "v0.0.1"
}
description = {
  summary = "Asterisk Dialplan App",
  detailed = [[
     
  ]],
  homepage = "https://github.com/antirek/lua-dialplan",
  license = "MIT"
}
dependencies = {
  "lua ~> 5.2"
}
build = {
  type = "builtin",
  modules = {
    dialplan = "main.lua"
  }
}