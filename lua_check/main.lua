

-- 读取传入参数的文件位置
local file_path = arg[1]

-- 加载ai level skill 模块
require("lua_check/ai")
require("lua_check/level")
require("lua_check/skill")

-- 读取文件

local t = require(file_path)
t.cb()

