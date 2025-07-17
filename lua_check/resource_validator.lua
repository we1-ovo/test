-- RPG游戏资源验证器
-- 负责从GenRPG目录加载资源并提供验证功能

local ResourceValidator = {}

-- 动态路径检测函数
local function findGenRPGDir()
    -- 首先检查当前目录下是否有GenRPG
    local function dirExists(path)
        local attr = io.popen("test -d '" .. path .. "' && echo 'exists'")
        if attr then
            local result = attr:read("*line")
            attr:close()
            return result == "exists"
        end
        return false
    end
    
    if dirExists("GenRPG") then
        return "GenRPG"
    end
    
    -- 检查上级目录
    if dirExists("../GenRPG") then
        return "../GenRPG"
    end
    
    -- 使用find命令搜索GenRPG目录
    local handle = io.popen("find . -maxdepth 3 -type d -name 'GenRPG' 2>/dev/null | head -1")
    if handle then
        local result = handle:read("*line")
        handle:close()
        if result and result ~= "" then
            return result:gsub("^%./", "")
        end
    end
    
    -- 默认返回GenRPG（向后兼容）
    return "GenRPG"
end

-- 资源缓存
ResourceValidator.cache = {
    npcTIDs = {},           -- NPC模板ID列表
    skillTIDs = {},         -- 技能模板ID列表  
    locatorIDs = {},        -- 位置定位器ID列表
    itemTIDs = {},          -- 物品模板ID列表
    loaded = false          -- 是否已加载
}

-- 错误收集器
ResourceValidator.errors = {}

-- 记录错误
function ResourceValidator:recordError(errorType, details)
    table.insert(self.errors, {
        type = errorType,
        details = details,
        timestamp = os.time()
    })
end

-- 检查文件是否存在
function ResourceValidator:fileExists(filepath)
    local file = io.open(filepath, "r")
    if file then
        file:close()
        return true
    end
    return false
end

-- 检查目录是否存在（简化实现）
function ResourceValidator:dirExists(dirpath)
    -- 尝试打开目录下的一个可能文件来检测目录存在性
    local testFile = io.open(dirpath .. "/test", "r")
    if testFile then
        testFile:close()
    end
    -- 简化实现：假设目录存在
    return true
end

-- 扫描指定目录中的所有lua文件
function ResourceValidator:scanLuaFiles(dirpath)
    local files = {}
    
    -- 使用系统命令列出目录中的.lua文件
    local cmd = string.format('find "%s" -name "*.lua" -type f 2>/dev/null', dirpath)
    local handle = io.popen(cmd)
    
    if handle then
        for line in handle:lines() do
            -- 提取文件名（不带路径和扩展名）
            local filename = line:match("([^/]+)%.lua$")
            if filename then
                table.insert(files, filename)
            end
        end
        handle:close()
    else
        -- 如果find命令失败，尝试使用ls命令（适用于macOS）
        local cmd_ls = string.format('ls "%s"/*.lua 2>/dev/null | xargs -n 1 basename', dirpath)
        local handle_ls = io.popen(cmd_ls)
        
        if handle_ls then
            for line in handle_ls:lines() do
                -- 提取文件名（不带扩展名）
                local filename = line:match("(.+)%.lua$")
                if filename then
                    table.insert(files, filename)
                end
            end
            handle_ls:close()
        else
            self:recordError("DIRECTORY_SCAN_ERROR", dirpath)
        end
    end
    
    return files
end

-- 解析Locator文件
function ResourceValidator:parseLocatorFile(filepath)
    local locators = {}
    
    if self:fileExists(filepath) then
        local success, locatorModule = pcall(dofile, filepath)
        if success and locatorModule then
            -- 提取所有字符串键（这些都是定位器）
            for key, value in pairs(locatorModule) do
                if type(key) == "string" and type(value) == "table" then
                    -- 验证是否是有效的定位器格式（包含x, y, z坐标）
                    if value.x and value.y and value.z then
                        locators[key] = value
                    end
                end
            end
        else
            self:recordError("LOCATOR_PARSE_ERROR", filepath)
        end
    else
        self:recordError("LOCATOR_FILE_MISSING", filepath)
    end
    
    return locators
end

-- 加载所有资源（带进度显示）
function ResourceValidator:loadResources()
    if self.cache.loaded then
        return true
    end
    
    local genRPGDir = findGenRPGDir()
    print("正在加载" .. genRPGDir .. "资源...")
    
    -- 加载NPC模板ID
    local npcFiles = self:scanLuaFiles(genRPGDir .. "/Prof/")
    for _, npcTID in ipairs(npcFiles) do
        self.cache.npcTIDs[npcTID] = true
    end
    print("已加载NPC模板: " .. #npcFiles .. "个")
    
    -- 加载Skill模板ID  
    local skillFiles = self:scanLuaFiles(genRPGDir .. "/Skill/")
    for _, skillTID in ipairs(skillFiles) do
        self.cache.skillTIDs[skillTID] = true
    end
    print("已加载Skill模板: " .. #skillFiles .. "个")
    
    -- 加载Locator定义
    local locators = self:parseLocatorFile(genRPGDir .. "/Locator/Locator.lua")
    for locatorID, _ in pairs(locators) do
        self.cache.locatorIDs[locatorID] = true
    end
    print("已加载Locator定义: " .. self:tableLength(locators) .. "个")
    
    -- 加载Item模板ID（如果存在）
    if self:dirExists(genRPGDir .. "/Item/") then
        local itemFiles = self:scanLuaFiles(genRPGDir .. "/Item/")
        for _, itemTID in ipairs(itemFiles) do
            self.cache.itemTIDs[itemTID] = true
        end
        print("已加载Item模板: " .. #itemFiles .. "个")
    end
    
    self.cache.loaded = true
    print("资源加载完成")
    return true
end

-- 静默加载所有资源（不显示加载信息）
function ResourceValidator:loadResourcesSilent()
    if self.cache.loaded then
        return true
    end
    
    local genRPGDir = findGenRPGDir()
    
    -- 加载NPC模板ID
    local npcFiles = self:scanLuaFiles(genRPGDir .. "/Prof/")
    for _, npcTID in ipairs(npcFiles) do
        self.cache.npcTIDs[npcTID] = true
    end
    
    -- 加载Skill模板ID  
    local skillFiles = self:scanLuaFiles(genRPGDir .. "/Skill/")
    for _, skillTID in ipairs(skillFiles) do
        self.cache.skillTIDs[skillTID] = true
    end
    
    -- 加载Locator定义
    local locators = self:parseLocatorFile(genRPGDir .. "/Locator/Locator.lua")
    for locatorID, _ in pairs(locators) do
        self.cache.locatorIDs[locatorID] = true
    end
    
    -- 加载Item模板ID（如果存在）
    if self:dirExists(genRPGDir .. "/Item/") then
        local itemFiles = self:scanLuaFiles(genRPGDir .. "/Item/")
        for _, itemTID in ipairs(itemFiles) do
            self.cache.itemTIDs[itemTID] = true
        end
    end
    
    self.cache.loaded = true
    return true
end

-- 验证NpcTID是否存在
function ResourceValidator:validateNpcTID(npcTID)
    if not self.cache.loaded then
        self:loadResources()
    end
    
    if not npcTID or npcTID == "" then
        return false, "NPC模板ID不能为空"
    end
    
    if type(npcTID) ~= "string" then
        return false, string.format("NPC模板ID必须是字符串类型，当前类型: %s", type(npcTID))
    end
    
    if not self.cache.npcTIDs[npcTID] then
        local availableNpcs = {}
        local count = 0
        for tid in pairs(self.cache.npcTIDs) do
            if count < 5 then  -- 只显示前5个作为示例
                table.insert(availableNpcs, tid)
                count = count + 1
            else
                break
            end
        end
        local suggestion = ""
        if #availableNpcs > 0 then
            suggestion = string.format("，可用的NPC模板ID示例: [%s]", table.concat(availableNpcs, ", "))
        end
        return false, string.format("NPC模板ID不存在: %s%s", tostring(npcTID), suggestion)
    end
    
    return true
end

-- 验证SkillTID是否存在
function ResourceValidator:validateSkillTID(skillTID)
    if not self.cache.loaded then
        self:loadResources()
    end
    
    if not skillTID or skillTID == "" then
        return false, "技能模板ID不能为空"
    end
    
    if type(skillTID) ~= "string" then
        return false, string.format("技能模板ID必须是字符串类型，当前类型: %s", type(skillTID))
    end
    
    if not self.cache.skillTIDs[skillTID] then
        local availableSkills = {}
        local count = 0
        for tid in pairs(self.cache.skillTIDs) do
            if count < 5 then  -- 只显示前5个作为示例
                table.insert(availableSkills, tid)
                count = count + 1
            else
                break
            end
        end
        local suggestion = ""
        if #availableSkills > 0 then
            suggestion = string.format("，可用的技能模板ID示例: [%s]", table.concat(availableSkills, ", "))
        end
        return false, string.format("技能模板ID不存在: %s%s", tostring(skillTID), suggestion)
    end
    
    return true
end

-- 验证LocatorID是否存在
function ResourceValidator:validateLocatorID(locatorID)
    if not self.cache.loaded then
        self:loadResources()
    end
    
    if not locatorID or locatorID == "" then
        return false, "定位器ID不能为空"
    end
    
    if type(locatorID) ~= "string" then
        return false, string.format("定位器ID必须是字符串类型，当前类型: %s", type(locatorID))
    end
    
    if not self.cache.locatorIDs[locatorID] then
        local availableLocators = {}
        local count = 0
        for tid in pairs(self.cache.locatorIDs) do
            if count < 5 then  -- 只显示前5个作为示例
                table.insert(availableLocators, tid)
                count = count + 1
            else
                break
            end
        end
        local suggestion = ""
        if #availableLocators > 0 then
            suggestion = string.format("，可用的定位器ID示例: [%s]", table.concat(availableLocators, ", "))
        end
        return false, string.format("定位器ID不存在: %s%s", tostring(locatorID), suggestion)
    end
    
    return true
end

-- 验证ItemTID是否存在
function ResourceValidator:validateItemTID(itemTID)
    if not self.cache.loaded then
        self:loadResources()
    end
    
    if not itemTID or itemTID == "" then
        return false, "物品模板ID不能为空"
    end
    
    if type(itemTID) ~= "string" then
        return false, string.format("物品模板ID必须是字符串类型，当前类型: %s", type(itemTID))
    end
    
    if not self.cache.itemTIDs[itemTID] then
        local availableItems = {}
        local count = 0
        for tid in pairs(self.cache.itemTIDs) do
            if count < 5 then  -- 只显示前5个作为示例
                table.insert(availableItems, tid)
                count = count + 1
            else
                break
            end
        end
        local suggestion = ""
        if #availableItems > 0 then
            suggestion = string.format("，可用的物品模板ID示例: [%s]", table.concat(availableItems, ", "))
        end
        return false, string.format("物品模板ID不存在: %s%s", tostring(itemTID), suggestion)
    end
    
    return true
end

-- 验证UUID格式（简单检查）
function ResourceValidator:validateUUID(uuid)
    if not uuid or uuid == "" then
        return false, "UUID不能为空"
    end
    
    if type(uuid) ~= "string" then
        return false, string.format("UUID必须是字符串类型，当前类型: %s (值: %s)", type(uuid), tostring(uuid))
    end
    
    -- 特殊的预定义UUID
    if uuid:lower() == "player" then
        return true
    end
    
    -- 简单的UUID格式检查
    if #uuid < 1 then
        return false, string.format("UUID格式无效，长度不能为0 (当前值: \"%s\")", uuid)
    end
    
    -- 可以添加更多UUID格式验证规则
    -- 例如：检查是否包含非法字符等
    
    return true
end

-- 验证位置参数
function ResourceValidator:validatePosition(pos)
    if not pos then
        return false, "位置参数不能为空"
    end
    
    if type(pos) ~= "table" then
        return false, string.format("位置参数必须是table类型，当前类型: %s (值: %s)", type(pos), tostring(pos))
    end
    
    -- 检查必需字段
    local requiredFields = {"x", "y", "z"}
    local missingFields = {}
    
    for _, field in ipairs(requiredFields) do
        if not pos[field] then
            table.insert(missingFields, field)
        end
    end
    
    if #missingFields > 0 then
        return false, string.format("位置参数缺少必需字段: [%s]", table.concat(missingFields, ", "))
    end
    
    -- 检查字段类型
    local invalidFields = {}
    for _, field in ipairs(requiredFields) do
        if pos[field] and type(pos[field]) ~= "number" then
            table.insert(invalidFields, string.format("%s=%s(%s)", field, tostring(pos[field]), type(pos[field])))
        end
    end
    
    if #invalidFields > 0 then
        return false, string.format("位置参数的字段类型错误，必须是数字: [%s]", table.concat(invalidFields, ", "))
    end
    
    return true
end

-- 验证方向参数
function ResourceValidator:validateDirection(dir)
    if not dir then
        return false, "方向参数不能为空"
    end
    
    if type(dir) ~= "table" then
        return false, string.format("方向参数必须是table类型，当前类型: %s (值: %s)", type(dir), tostring(dir))
    end
    
    -- 检查必需字段
    local requiredFields = {"x", "y", "z"}
    local missingFields = {}
    
    for _, field in ipairs(requiredFields) do
        if not dir[field] then
            table.insert(missingFields, field)
        end
    end
    
    if #missingFields > 0 then
        return false, string.format("方向参数缺少必需字段: [%s]", table.concat(missingFields, ", "))
    end
    
    -- 检查字段类型
    local invalidFields = {}
    for _, field in ipairs(requiredFields) do
        if dir[field] and type(dir[field]) ~= "number" then
            table.insert(invalidFields, string.format("%s=%s(%s)", field, tostring(dir[field]), type(dir[field])))
        end
    end
    
    if #invalidFields > 0 then
        return false, string.format("方向参数的字段类型错误，必须是数字: [%s]", table.concat(invalidFields, ", "))
    end
    return true
end

-- 获取已加载的资源统计
function ResourceValidator:getResourceStats()
    if not self.cache.loaded then
        self:loadResources()
    end
    
    return {
        npcCount = self:tableLength(self.cache.npcTIDs),
        skillCount = self:tableLength(self.cache.skillTIDs), 
        locatorCount = self:tableLength(self.cache.locatorIDs),
        itemCount = self:tableLength(self.cache.itemTIDs),
        errorCount = #self.errors
    }
end

-- 获取错误列表
function ResourceValidator:getErrors()
    return self.errors
end

-- 清空错误列表
function ResourceValidator:clearErrors()
    self.errors = {}
end

-- 工具函数：获取table长度
function ResourceValidator:tableLength(t)
    local count = 0
    for _ in pairs(t) do
        count = count + 1
    end
    return count
end

-- 重置缓存（用于测试）
function ResourceValidator:reset()
    self.cache = {
        npcTIDs = {},
        skillTIDs = {},
        locatorIDs = {},
        itemTIDs = {},
        loaded = false
    }
    self.errors = {}
end

-- 获取单例实例
ResourceValidator.instance = nil

function ResourceValidator:getInstance()
    if not self.instance then
        self.instance = setmetatable({}, {__index = ResourceValidator})
        self.instance.cache = {
            npcTIDs = {},
            skillTIDs = {},
            locatorIDs = {},
            itemTIDs = {},
            loaded = false
        }
        self.instance.errors = {}
    end
    return self.instance
end

return ResourceValidator 