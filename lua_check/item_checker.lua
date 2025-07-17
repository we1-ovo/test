-- Item文件检查器 - 专门验证Item文件的数据结构和执行回调函数
local ItemChecker = {}

-- 加载依赖
local ValidationModule = require("lua_check.validation")
local ResourceValidator = require("lua_check.resource_validator")

-- 路径检测器（从main.lua复制的逻辑）
local PathDetector = {}

function PathDetector:getCurrentDir()
    local pwd = os.getenv("PWD") or io.popen("pwd"):read("*line")
    return pwd or "."
end

function PathDetector:dirExists(path)
    local attr = io.popen("test -d '" .. path .. "' && echo 'exists'")
    if attr then
        local result = attr:read("*line")
        attr:close()
        return result == "exists"
    end
    return false
end

function PathDetector:fileExists(path)
    local file = io.open(path, "r")
    if file then
        file:close()
        return true
    end
    return false
end

function PathDetector:findGenRPGDir()
    -- 首先检查当前目录下是否有GenRPG
    if self:dirExists("GenRPG") then
        return "GenRPG"
    end
    
    -- 检查上级目录
    if self:dirExists("../GenRPG") then
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
    
    -- 尝试更广泛的搜索
    local handle2 = io.popen("find .. -maxdepth 2 -type d -name 'GenRPG' 2>/dev/null | head -1")
    if handle2 then
        local result = handle2:read("*line")
        handle2:close()
        if result and result ~= "" then
            return result
        end
    end
    
    -- 默认返回GenRPG（向后兼容）
    return "GenRPG"
end

-- 解析文件路径，确保能正确找到文件
function PathDetector:resolveItemFilePath(filepath)
    -- 如果文件已经存在，直接返回
    if self:fileExists(filepath) then
        return filepath, nil
    end
    
    -- 尝试不同的路径解析策略
    local attempts = {}
    
    -- 策略1：直接使用原路径
    table.insert(attempts, {path = filepath, desc = "原始路径"})
    
    -- 策略2：如果路径包含GenRPG/Item/，尝试重建路径
    if filepath:match("GenRPG/Item/") then
        local itemFileName = filepath:match("GenRPG/Item/(.+)")
        if itemFileName then
            local genrpgDir = self:findGenRPGDir()
            local newPath = genrpgDir .. "/Item/" .. itemFileName
            table.insert(attempts, {path = newPath, desc = "重建GenRPG路径"})
        end
    end
    
    -- 策略3：尝试从当前目录查找
    local fileName = filepath:match("([^/]+)$")
    if fileName then
        local genrpgDir = self:findGenRPGDir()
        local directPath = genrpgDir .. "/Item/" .. fileName
        table.insert(attempts, {path = directPath, desc = "直接文件名匹配"})
    end
    
    -- 策略4：尝试添加.lua扩展名
    if not filepath:match("%.lua$") then
        table.insert(attempts, {path = filepath .. ".lua", desc = "添加.lua扩展名"})
    end
    
    -- 尝试每个路径
    for _, attempt in ipairs(attempts) do
        if self:fileExists(attempt.path) then
            return attempt.path, nil
        end
    end
    
    -- 所有尝试都失败了，返回详细的错误信息
    local errorMsg = string.format("无法找到Item文件: %s\n尝试的路径:", filepath)
    for i, attempt in ipairs(attempts) do
        errorMsg = errorMsg .. string.format("\n  %d. %s: %s", i, attempt.desc, attempt.path)
    end
    errorMsg = errorMsg .. string.format("\n当前工作目录: %s", self:getCurrentDir())
    errorMsg = errorMsg .. string.format("\n找到的GenRPG目录: %s", self:findGenRPGDir())
    
    return nil, errorMsg
end

-- 创建检查器实例
function ItemChecker:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    
    o.errors = {}
    o.validator = ResourceValidator:getInstance()
    o.pathDetector = PathDetector
    
    return o
end

-- 记录错误
function ItemChecker:recordError(errorType, message, filepath, line)
    table.insert(self.errors, {
        type = errorType,
        message = message,
        filepath = filepath,
        line = line,
        timestamp = os.date("%Y-%m-%d %H:%M:%S")
    })
    
    -- 同时记录到全局错误收集器
    if _G.GlobalErrorCollector then
        _G.GlobalErrorCollector:addError("ITEM_CHECKER", errorType, message, filepath, line)
    end
end

-- 验证Item数据结构
function ItemChecker:validateItemStructure(itemData, filepath)
    if not itemData or type(itemData) ~= "table" then
        self:recordError("ITEM_STRUCTURE_ERROR", "Item文件必须返回一个table", filepath, 1)
        return false
    end
    
    local errors = {}
    
    -- 验证必需字段
    if not itemData.id or type(itemData.id) ~= "string" or itemData.id == "" then
        table.insert(errors, "id字段必须为非空字符串")
    end
    
    if not itemData.desc or type(itemData.desc) ~= "string" or itemData.desc == "" then
        table.insert(errors, "desc字段必须为非空字符串")
    end
    
    -- 验证可选字段的类型
    local optionalFields = {
        prefab = "string",
        avatar = "string",
        cooldown = "number",
        deleteAfterUse = "boolean",
        stackable = "boolean",
        autoUse = "boolean",
        showInUI = "boolean"
    }
    
    for fieldName, expectedType in pairs(optionalFields) do
        if itemData[fieldName] ~= nil and type(itemData[fieldName]) ~= expectedType then
            table.insert(errors, string.format("%s字段必须为%s类型", fieldName, expectedType))
        end
    end
    
    -- 验证数值范围
    if itemData.cooldown and type(itemData.cooldown) == "number" and itemData.cooldown < 0 then
        table.insert(errors, "cooldown必须大于等于0")
    end
    
    -- 验证回调函数
    local callbacks = {"onGet", "onLost", "onUse"}
    for _, callbackName in ipairs(callbacks) do
        if itemData[callbackName] ~= nil then
            if type(itemData[callbackName]) ~= "function" then
                table.insert(errors, string.format("%s必须为函数类型", callbackName))
            else
                -- 检查回调函数参数个数（应该为0）
                local success, paramCount = pcall(function()
                    local info = debug.getinfo(itemData[callbackName])
                    return info.nparams or 0
                end)
                if success and paramCount > 0 then
                    table.insert(errors, string.format("%s回调函数不应该有参数", callbackName))
                end
            end
        end
    end
    
    -- 记录所有错误
    for _, error in ipairs(errors) do
        self:recordError("ITEM_STRUCTURE_ERROR", error, filepath, 1)
    end
    
    return #errors == 0
end

-- 安全执行回调函数
function ItemChecker:safeExecuteCallback(callback, callbackName, itemData, filepath)
    if not callback or type(callback) ~= "function" then
        return true  -- 回调函数为空是合法的
    end
    
    -- 创建一个安全的执行环境
    local success, result = pcall(function()
        -- Item API函数已经在main.lua中加载到全局环境中
        return callback()
    end)
    
    if not success then
        -- 提供更详细的错误信息
        local errorMsg = string.format("%s回调函数执行失败: %s", callbackName, tostring(result))
        
        -- 尝试解析特定的错误类型
        local resultStr = tostring(result)
        if resultStr:match("attempt to call.*nil") then
            errorMsg = errorMsg .. "\n可能原因：回调函数中调用了未定义的API函数"
        elseif resultStr:match("attempt to index.*nil") then
            errorMsg = errorMsg .. "\n可能原因：回调函数中访问了未定义的变量或字段"
        end
        
        self:recordError("CALLBACK_EXECUTION_ERROR", errorMsg, filepath, nil)
        return false
    end
    return true
end

-- 检查单个Item文件
function ItemChecker:checkItemFile(filepath)
    -- 使用改进的路径解析
    local actualFilePath, pathError = self.pathDetector:resolveItemFilePath(filepath)
    
    if not actualFilePath then
        self:recordError("FILE_NOT_FOUND", pathError, filepath, 1)
        return false
    end
    
    -- 尝试加载文件
    local success, itemData = pcall(function()
        return dofile(actualFilePath)
    end)
    
    if not success then
        -- 改进错误信息，提供更多上下文
        local errorMsg = tostring(itemData)
        
        -- 检查是否是文件不存在的错误
        if errorMsg:match("No such file or directory") or errorMsg:match("cannot open") then
            self:recordError("FILE_NOT_FOUND", 
                string.format("无法打开Item文件: %s (解析后路径: %s)", errorMsg, actualFilePath), 
                filepath, 1)
        elseif errorMsg:match("syntax error") then
            self:recordError("FILE_SYNTAX_ERROR", 
                string.format("Item文件语法错误: %s", errorMsg), 
                filepath, 1)
        else
            self:recordError("FILE_LOAD_ERROR", 
                string.format("Item文件加载失败: %s (文件: %s)", errorMsg, actualFilePath), 
                filepath, 1)
        end
        return false
    end
    
    -- 验证数据结构
    if not self:validateItemStructure(itemData, filepath) then
        return false  -- 结构验证失败，不继续执行回调
    end
    
    local allCallbacksSuccess = true
    
    -- 测试执行回调函数
    local callbacks = {
        {name = "onGet", func = itemData.onGet, desc = "获得时"},
        {name = "onLost", func = itemData.onLost, desc = "丢失时"},
        {name = "onUse", func = itemData.onUse, desc = "使用时"}
    }
    
    for _, callback in ipairs(callbacks) do
        if callback.func then
            local callbackSuccess = self:safeExecuteCallback(callback.func, callback.name, itemData, filepath)
            if not callbackSuccess then
                allCallbacksSuccess = false
            end
        end
    end
    
    return allCallbacksSuccess
end

-- 批量检查Item目录
function ItemChecker:checkItemDirectory(itemDir)
    if not itemDir then
        itemDir = self.pathDetector:findGenRPGDir() .. "/Item/"
    end
    
    -- 检查目录是否存在
    if not self.pathDetector:dirExists(itemDir) then
        print("ℹ️  Item目录不存在，跳过Item文件检查: " .. itemDir)
        return true  -- 不存在是合法的
    end
    
    -- 获取所有.lua文件
    local cmd = string.format('find "%s" -name "*.lua" -type f 2>/dev/null', itemDir)
    local fileHandle = io.popen(cmd)
    if not fileHandle then
        self:recordError("DIRECTORY_SCAN_ERROR", "无法扫描Item目录: " .. itemDir, nil, nil)
        return false
    end
    
    local itemFiles = {}
    for line in fileHandle:lines() do
        table.insert(itemFiles, line)
    end
    fileHandle:close()
    
    if #itemFiles == 0 then
        print("ℹ️  Item目录为空")
        return true
    end
    
    print(string.format("🔍 找到 %d 个Item文件", #itemFiles))
    
    local successCount = 0
    local errorCount = 0
    
    for _, filePath in ipairs(itemFiles) do
        local fileName = filePath:match("([^/]+)%.lua$")
        -- print(string.format("\n📄 检查Item文件: %s", fileName))
        
        local success = self:checkItemFile(filePath)
        if success then
            successCount = successCount + 1
        else
            errorCount = errorCount + 1
            print("   ❌ 检查失败")
        end
    end
    
    print(string.format("\n📊 Item文件检查结果: %d成功, %d失败", successCount, errorCount))
    
    return errorCount == 0
end

-- 获取错误列表
function ItemChecker:getErrors()
    return self.errors
end

-- 清空错误列表
function ItemChecker:clearErrors()
    self.errors = {}
end

-- 格式化错误报告
function ItemChecker:formatErrorReport()
    if #self.errors == 0 then
        return "✅ Item检查未发现错误"
    end
    
    local report = {}
    table.insert(report, string.format("❌ Item检查发现 %d 个错误:", #self.errors))
    
    for i, error in ipairs(self.errors) do
        local location = error.filepath and string.format(" [%s:%s]", error.filepath, error.line or "?") or ""
        table.insert(report, string.format("  %d. [%s] %s%s", i, error.type, error.message, location))
    end
    
    return table.concat(report, "\n")
end

return ItemChecker 