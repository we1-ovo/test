-- 简化版代码检查工具
-- 专注于API调用验证和资源引用检查

-- 动态路径检测模块
local PathDetector = {}

-- 获取当前工作目录
function PathDetector:getCurrentDir()
    local pwd = os.getenv("PWD") or io.popen("pwd"):read("*line")
    return pwd or "."
end

-- 查找GenRPG目录的位置
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
    
    -- 默认返回GenRPG（向后兼容）
    return "GenRPG"
end

-- 检查目录是否存在
function PathDetector:dirExists(path)
    local attr = io.popen("test -d '" .. path .. "' && echo 'exists'")
    if attr then
        local result = attr:read("*line")
        attr:close()
        return result == "exists"
    end
    return false
end

-- 获取相对于项目根目录的路径
function PathDetector:getRelativePath(absolutePath)
    if not absolutePath then
        return ""
    end
    
    -- 移除@前缀
    if string.sub(absolutePath, 1, 1) == "@" then
        absolutePath = string.sub(absolutePath, 2)
    end
    
    local currentDir = self:getCurrentDir()
    if not currentDir then
        return absolutePath
    end
    
    -- 如果路径已经是相对路径，直接返回
    if not absolutePath:match("^/") then
        return absolutePath
    end
    
    -- 尝试将绝对路径转换为相对于当前工作目录的路径
    local pattern = currentDir:gsub("([%.%-%+%*%?%[%]%^%$%(%)%%])", "%%%1") .. "/"
    local relativePath = absolutePath:gsub("^" .. pattern, "")
    
    -- 如果没有匹配到，尝试其他方式
    if relativePath == absolutePath then
        -- 查找GenRPG目录在路径中的位置
        local genrpgStart = absolutePath:find("/GenRPG/")
        if genrpgStart then
            -- 查找GenRPG之前的最后一个目录分隔符
            local beforeGenrpg = absolutePath:sub(1, genrpgStart - 1)
            local lastSlash = beforeGenrpg:match(".*/()")
            if lastSlash then
                return absolutePath:sub(lastSlash)
            else
                return absolutePath:sub(genrpgStart + 1)  -- 移除开头的/
            end
        end
        
        -- 尝试移除常见的路径前缀
        relativePath = absolutePath:gsub("^.*/lua_check/", "lua_check/")
        if relativePath ~= absolutePath then
            return relativePath
        end
        
        -- 尝试获取文件名部分作为最后的fallback
        local fileName = absolutePath:match("([^/]+)$")
        if fileName then
            return fileName
        end
    end
    
    return relativePath
end

-- 全局实例
local pathDetector = PathDetector

-- 加载API模拟系统
require("lua_check.level")
require("lua_check.ai")  
require("lua_check.skill")
require("lua_check.item")

-- 加载资源验证器
local ResourceValidator = require("lua_check.resource_validator")

-- 加载验证模块
local ValidationModule = require("lua_check.validation")

-- 加载函数调用检查器
local FunctionCallChecker = require("lua_check.function_call_checker")

-- 加载综合检查器
local ComprehensiveChecker = require("lua_check.comprehensive_checker")

-- 全局错误收集器 - 用于收集所有错误而不停止执行
local GlobalErrorCollector = {
    errors = {},
    fileErrors = {},  -- 按文件分组的错误
    maxErrorsPerFile = 50,  -- 每个文件最大错误数
    totalMaxErrors = 1000   -- 总错误数限制
}

function GlobalErrorCollector:addError(source, category, message, filepath, line)
    -- 检查是否超出总错误限制
    if #self.errors >= self.totalMaxErrors then
        return false
    end
    
    -- 检查是否超出单文件错误限制
    if filepath then
        if not self.fileErrors[filepath] then
            self.fileErrors[filepath] = {}
        end
        if #self.fileErrors[filepath] >= self.maxErrorsPerFile then
            return false
        end
        table.insert(self.fileErrors[filepath], {
            source = source,
            category = category,
            message = message,
            line = line,
            timestamp = os.date("%Y-%m-%d %H:%M:%S")
        })
    end
    
    -- 使用与其他ErrorCollector兼容的格式
    table.insert(self.errors, {
        api = source or "GLOBAL",
        type = category or "UNKNOWN_ERROR", 
        details = message or "Unknown error",
        filepath = filepath,
        line = line,
        timestamp = os.date("%Y-%m-%d %H:%M:%S")
    })
    return true
end

function GlobalErrorCollector:getErrorCount()
    return #self.errors
end

function GlobalErrorCollector:getErrors()
    return self.errors
end

function GlobalErrorCollector:clear()
    self.errors = {}
    self.fileErrors = {}
end

function GlobalErrorCollector:printSummary()
    if #self.errors == 0 then
        print("✅ 所有检查完成，未发现错误")
        return
    end
    
    print(string.format("📊 错误汇总：共发现 %d 个错误", #self.errors))
    
    -- 按源头分组
    local errorsBySource = {}
    for _, error in ipairs(self.errors) do
        local source = error.api or "UNKNOWN"
        if not errorsBySource[source] then
            errorsBySource[source] = {}
        end
        table.insert(errorsBySource[source], error)
    end
    
    -- for source, errors in pairs(errorsBySource) do
    --     print(string.format("\n🔍 %s: %d 个错误", source, #errors))
    --     for i, error in ipairs(errors) do
    --         if i <= 10 then  -- 只显示前10个错误
    --             local location = error.filepath and string.format(" [%s:%s]", error.filepath, error.line or "?") or ""
    --             print(string.format("  %d. %s%s", i, error.details, location))
    --         elseif i == 11 then
    --             print(string.format("  ... 还有 %d 个错误", #errors - 5))
    --             break
    --         end
    --     end
    -- end
    
    -- 按文件分组
    -- if next(self.fileErrors) then
    --     print("\n📂 按文件分组的错误:")
    --     for filepath, errors in pairs(self.fileErrors) do
    --         if #errors > 0 then
    --             print(string.format("  %s: %d 个错误", filepath, #errors))
    --         end
    --     end
    -- end
end

-- 获取错误收集器 - 动态检测存在的ErrorCollector
local function getErrorCollectors()
    local collectors = {}
    
    -- 动态检测所有ErrorCollector全局变量
    for globalName, globalValue in pairs(_G) do
        if type(globalValue) == "table" and globalName:match("_ErrorCollector$") then
            -- 确保collector有必要的方法
            if globalValue.getErrors and type(globalValue.getErrors) == "function" then
                local systemName = globalName:lower():gsub("_errorcollector", "")
                collectors[systemName] = globalValue
            end
        end
    end
    
    -- 总是包含ValidationModule的ErrorCollector
    if ValidationModule and ValidationModule.ErrorCollector then
        collectors.validation = ValidationModule.ErrorCollector
    end
    
    -- 总是包含全局错误收集器
    collectors.global = GlobalErrorCollector
    
    -- 如果没有找到任何collectors，创建默认的
    if next(collectors) == nil then
        collectors.default = {
            errors = {}, 
            getErrors = function(self) return self.errors end,
            clearErrors = function(self) self.errors = {} end
        }
    end
    
    return collectors
end

-- 安全错误函数 - 记录错误但不停止执行
local function safeError(message, source, filepath, line)
    source = source or "UNKNOWN"
    GlobalErrorCollector:addError(source, "EXECUTION_ERROR", message, filepath, line)
    print(string.format("❌ [%s] %s", source, message))
    return false  -- 返回false表示出错，但不停止执行
end

-- 打印分隔线（只在单文件检查时使用）
local function printSeparator(text)
    print("\n" .. string.rep("=", 60))
    print("  " .. text)
    print(string.rep("=", 60))
end

-- 全局路径显示深度配置
local PATH_DISPLAY_DEPTH = 0

-- 设置路径显示深度
local function setPathDisplayDepth(depth)
    PATH_DISPLAY_DEPTH = depth or 0
end

-- 根据深度调整文件路径显示
local function adjustPathDisplay(filepath)
    if PATH_DISPLAY_DEPTH <= 0 then
        return filepath
    end
    
    -- 获取当前工作目录的绝对路径
    local pwd = os.getenv("PWD") or io.popen("pwd"):read("*line")
    if not pwd then
        return filepath
    end
    
    -- 分割路径为组件
    local pathComponents = {}
    for component in pwd:gmatch("[^/]+") do
        table.insert(pathComponents, component)
    end
    
    -- 计算需要显示的父目录数量
    local parentDirs = {}
    local startIndex = math.max(1, #pathComponents - PATH_DISPLAY_DEPTH + 1)
    
    for i = startIndex, #pathComponents do
        table.insert(parentDirs, pathComponents[i])
    end
    
    -- 构建最终路径
    if #parentDirs > 0 then
        return table.concat(parentDirs, "/") .. "/" .. filepath
    else
        return filepath
    end
end

-- 循环检测器
local LoopDetector = {}

-- 默认配置
local DEFAULT_CONFIG = {
    maxTotalCalls = 1000,           -- 最大总调用次数
    maxSingleFunctionCalls = 200,   -- 单个函数最大调用次数
    defaultTimeout = 10,            -- 默认超时时间（秒）
    warningThreshold = 50,          -- 警告阈值
    maxSequenceLength = 20,         -- 最大序列长度
    errorThreshold = 20,            -- 错误数量激增阈值
    patternRepeatThreshold = 10     -- 重复模式检测阈值
}

-- 当前配置（可动态修改）
local CURRENT_CONFIG = {}
for k, v in pairs(DEFAULT_CONFIG) do
    CURRENT_CONFIG[k] = v
end

-- 配置管理函数
local function updateConfig(newConfig)
    for k, v in pairs(newConfig) do
        if DEFAULT_CONFIG[k] ~= nil then
            CURRENT_CONFIG[k] = v
        end
    end
end

-- 获取当前配置
local function getConfig()
    return CURRENT_CONFIG
end

-- 重置为默认配置
local function resetConfig()
    for k, v in pairs(DEFAULT_CONFIG) do
        CURRENT_CONFIG[k] = v
    end
end

-- 创建循环检测器实例
function LoopDetector:new(config)
    config = config or {}
    local obj = {
        startTime = 0,
        functionCalls = {},  -- 记录各个函数的调用次数
        totalCalls = 0,      -- 总调用次数
        maxTotalCalls = config.maxTotalCalls or CURRENT_CONFIG.maxTotalCalls,
        maxSingleFunctionCalls = config.maxSingleFunctionCalls or CURRENT_CONFIG.maxSingleFunctionCalls,
        timeout = config.defaultTimeout or CURRENT_CONFIG.defaultTimeout,
        warningThreshold = config.warningThreshold or CURRENT_CONFIG.warningThreshold,
        errorCountBefore = 0,
        callSequence = {},  -- 记录调用序列，用于检测重复模式
        maxSequenceLength = config.maxSequenceLength or CURRENT_CONFIG.maxSequenceLength,
        errorThreshold = config.errorThreshold or CURRENT_CONFIG.errorThreshold,
        patternRepeatThreshold = config.patternRepeatThreshold or CURRENT_CONFIG.patternRepeatThreshold
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

-- 开始检测
function LoopDetector:start(timeout)
    self.startTime = os.clock()
    self.functionCalls = {}
    self.totalCalls = 0
    self.callSequence = {}
    self.timeout = timeout or 10
    self.errorCountBefore = self:getCurrentErrorCount()
end

-- 获取当前错误数量
function LoopDetector:getCurrentErrorCount()
    local collectors = getErrorCollectors()
    local totalErrors = 0
    for _, collector in pairs(collectors) do
        if collector.getErrors then
            totalErrors = totalErrors + #collector:getErrors()
        end
    end
    return totalErrors
end

-- 检测重复调用模式
function LoopDetector:detectPattern()
    local sequenceLen = #self.callSequence
    if sequenceLen < 6 then return false end -- 至少需要6个调用才能检测模式
    
    -- 检查是否有重复的调用模式
    for patternLen = 2, math.min(sequenceLen // 2, 10) do
        local pattern = {}
        for i = 1, patternLen do
            pattern[i] = self.callSequence[sequenceLen - patternLen + i]
        end
        
        -- 检查这个模式是否在前面重复出现
        local matchCount = 0
        for start = sequenceLen - patternLen * 2, 1, -patternLen do
            if start < 1 then break end
            
            local match = true
            for i = 1, patternLen do
                if self.callSequence[start + i - 1] ~= pattern[i] then
                    match = false
                    break
                end
            end
            
            if match then
                matchCount = matchCount + 1
                if matchCount >= self.patternRepeatThreshold then  -- 使用配置的重复阈值
                    return true, table.concat(pattern, "->"), matchCount + 1
                end
            end
        end
    end
    
    return false
end

-- 获取用户代码的调用位置
function LoopDetector:getUserCodeLocation()
    local level = 1
    while true do
        local info = debug.getinfo(level, "Sl")
        if not info then break end
        
        -- 跳过检测器本身的代码
        if info.source and not string.match(info.source, "lua_check/main%.lua") then
            local source = pathDetector:getRelativePath(info.source)
            return adjustPathDisplay(source), info.currentline
        end
        level = level + 1
    end
    return "unknown", 0
end

-- 检查是否需要告警
function LoopDetector:checkAndAlert(operation, functionName)
    local currentTime = os.clock()
    local elapsedTime = currentTime - self.startTime
    
    -- 获取用户代码位置
    local userFile, userLine = self:getUserCodeLocation()
    local locationInfo = string.format("%s:%d", userFile, userLine)
    
    -- 检查超时
    if elapsedTime > self.timeout then
        local alertMsg = string.format("⚠️  循环检测告警：%s 在 %s 执行超时(%.1f秒)，可能存在无限循环", operation, locationInfo, elapsedTime)
        error(alertMsg)
    end
    
    -- 检查总调用次数
    if self.totalCalls > self.maxTotalCalls then
        local alertMsg = string.format("⚠️  循环检测告警：%s 在 %s 总调用次数过多(%d次)，可能存在无限循环", operation, locationInfo, self.totalCalls)
        error(alertMsg)
    end
    
    -- 检查单个函数调用次数
    local funcCallCount = self.functionCalls[functionName] or 0
    if funcCallCount > self.maxSingleFunctionCalls then
        local alertMsg = string.format("⚠️  循环检测告警：%s 在 %s 函数%s调用过多(%d次)，可能存在无限循环", operation, locationInfo, functionName, funcCallCount)
        error(alertMsg)
    end
    
    -- 检查重复调用模式
    local hasPattern, pattern, repeatCount = self:detectPattern()
    if hasPattern then
        local alertMsg = string.format("⚠️  循环检测告警：%s 在 %s 检测到重复调用模式 [%s] 重复%d次，可能存在无限循环", operation, locationInfo, pattern, repeatCount)
        error(alertMsg)
    end
    
    -- 检查错误数量激增
    local currentErrorCount = self:getCurrentErrorCount()
    if currentErrorCount - self.errorCountBefore > self.errorThreshold then
        local alertMsg = string.format("⚠️  循环检测告警：%s 在 %s 产生大量错误(%d个)，可能存在无限循环", operation, locationInfo, currentErrorCount - self.errorCountBefore)
        error(alertMsg)
    end
    
    -- 达到警告阈值时发出警告
    -- if self.totalCalls == self.warningThreshold * 10 then
    --     print(string.format("⚠️  循环检测警告：%s 在 %s 总调用次数已达到%d次，请检查是否存在过度循环", operation, locationInfo, self.warningThreshold * 10))
    -- end
    
    -- if funcCallCount == self.warningThreshold then
    --     print(string.format("⚠️  循环检测警告：%s 在 %s 函数%s调用已达到%d次，请检查是否存在过度循环", operation, locationInfo, functionName, self.warningThreshold))
    -- end
end

-- 记录函数调用
function LoopDetector:recordFunctionCall(operation, functionName)
    -- 更新调用统计
    self.totalCalls = self.totalCalls + 1
    self.functionCalls[functionName] = (self.functionCalls[functionName] or 0) + 1
    
    -- 记录调用序列
    table.insert(self.callSequence, functionName)
    if #self.callSequence > self.maxSequenceLength then
        table.remove(self.callSequence, 1)  -- 移除最老的记录
    end
    
    -- 检查是否需要告警
    self:checkAndAlert(operation, functionName)
end

-- 运行综合检查器
local function runComprehensiveCheck(baseDir, enableStaticCheck)
    local checker = ComprehensiveChecker:new()
    
    -- print("🔍 启动综合检查器...")
    local success, errors = checker:checkAllLevelFiles(baseDir, enableStaticCheck)
    
    if #errors > 0 then
        -- 将综合检查器的错误添加到ValidationModule的错误收集器中
        for _, error in ipairs(errors) do
            local errorDetails = string.format("文件:%s 第%d行 - 函数:%s", 
                error.file, error.startLine, error.function_name)
            
            for _, errorMsg in ipairs(error.errors or {}) do
                ValidationModule.ErrorCollector:recordError(
                    error.function_name or "COMPREHENSIVE_CHECK",
                    "COMPREHENSIVE_ERROR",
                    errorDetails .. " - " .. errorMsg
                )
            end
        end
    else
        -- print("✅ 综合检查器未发现问题")
    end
    
    return success, errors
end

-- 错误合并器 - 合并静态检查和动态检查结果
local ErrorMerger = {}

-- 创建错误合并器实例
function ErrorMerger:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

-- 从动态检查错误中提取标识信息
function ErrorMerger:extractDynamicErrorInfo(dynamicError)
    local details = dynamicError.details or ""
    local api = dynamicError.api or ""
    
    -- 从details中提取文件路径和行号
    local filePath, lineNumber = details:match("([^:]+%.lua):(%d+):")
    
    if not filePath or not lineNumber then
        return nil  -- 无法提取有效信息
    end
    
    -- 标准化文件路径
    filePath = filePath:gsub("^%./", "")  -- 移除开头的 ./
    
    return {
        file = filePath,
        line = tonumber(lineNumber),
        functionName = api,
        errorType = dynamicError.type
    }
end

-- 检查两个错误是否指向同一个函数调用
function ErrorMerger:isSameFunction(staticError, dynamicInfo)
    if not staticError or not dynamicInfo then
        return false
    end
    
    -- 标准化文件路径进行比较
    local staticFile = staticError.file:gsub("^%./", "")
    local dynamicFile = dynamicInfo.file:gsub("^%./", "")
    
    -- 检查文件路径是否匹配（支持相对路径匹配）
    local fileMatches = false
    if staticFile == dynamicFile then
        fileMatches = true
    else
        -- 尝试匹配文件名部分
        local staticFileName = staticFile:match("([^/]+)$")
        local dynamicFileName = dynamicFile:match("([^/]+)$")
        if staticFileName == dynamicFileName then
            fileMatches = true
        end
    end
    
    if not fileMatches then
        return false
    end
    
    -- 检查行号是否匹配（动态检查的行号应该在静态检查的行号范围内）
    local lineMatches = false
    if staticError.startLine and staticError.endLine then
        lineMatches = (dynamicInfo.line >= staticError.startLine and dynamicInfo.line <= staticError.endLine)
    elseif staticError.startLine then
        lineMatches = (dynamicInfo.line == staticError.startLine)
    end
    
    if not lineMatches then
        return false
    end
    
    -- 检查函数名是否匹配
    local functionMatches = false
    if staticError.function_name and dynamicInfo.functionName then
        functionMatches = (staticError.function_name == dynamicInfo.functionName)
    end
    
    return functionMatches
end

-- 检查静态错误是否是参数相关的错误（包括参数个数和参数类型）
function ErrorMerger:isParameterError(staticError)
    if not staticError.errors then
        return false
    end
    
    for _, errorMsg in ipairs(staticError.errors) do
        if type(errorMsg) == "string" then
            -- 参数个数错误
            if errorMsg:match("参数个数不匹配") then
                return true
            end
            -- 参数类型错误
            if errorMsg:match("参数类型") or errorMsg:match("类型不匹配") or errorMsg:match("必须是.*类型") then
                return true
            end
            -- 参数验证错误
            if errorMsg:match("参数.*验证失败") or errorMsg:match("参数.*无效") then
                return true
            end
        end
    end
    
    return false
end

-- 合并静态检查和动态检查的错误
function ErrorMerger:mergeErrors(staticErrors, dynamicErrors)
    local mergedErrors = {}
    local ignoredStaticErrors = {}
    
    -- 首先提取动态检查错误的信息
    local dynamicErrorInfos = {}
    for _, dynamicError in ipairs(dynamicErrors) do
        local info = self:extractDynamicErrorInfo(dynamicError)
        if info then
            table.insert(dynamicErrorInfos, {info = info, error = dynamicError})
        end
    end
    
    -- 处理静态检查错误
    for _, staticError in ipairs(staticErrors) do
        local shouldIgnore = false
        
        -- 对参数相关错误（参数个数和参数类型）进行合并处理
        if self:isParameterError(staticError) then
            -- 检查是否有对应的动态检查结果
            for _, dynamicInfo in ipairs(dynamicErrorInfos) do
                if self:isSameFunction(staticError, dynamicInfo.info) then
                    -- 找到对应的动态检查结果，忽略静态检查错误
                    shouldIgnore = true
                    table.insert(ignoredStaticErrors, {
                        static = staticError,
                        dynamic = dynamicInfo.error,
                        reason = "动态检查通过，忽略静态检查的参数错误"
                    })
                    break
                end
            end
        end
        
        -- 如果不需要忽略，添加到合并结果中
        if not shouldIgnore then
            table.insert(mergedErrors, staticError)
        end
    end
    
    -- 打印合并信息（仅在有忽略的错误时）
    if #ignoredStaticErrors > 0 then
        print(string.format("🔄 错误合并器：忽略了 %d 个静态检查错误（动态检查通过）", #ignoredStaticErrors))
        for _, ignored in ipairs(ignoredStaticErrors) do
            print(string.format("   - %s:%d %s 函数参数检查被忽略", 
                ignored.static.file, 
                ignored.static.startLine, 
                ignored.static.function_name))
        end
    end
    
    return mergedErrors, ignoredStaticErrors
end

-- 运行所有检查器
local function runAllCheckers(filepath, baseDir)
    local allErrors = {}
    
    -- 1. 运行函数调用检查器
    local functionChecker = FunctionCallChecker:new()
    if functionChecker and functionChecker.checkFile then
        -- 确保文件路径正确，避免双重.lua后缀
        local actualFilePath = filepath
        if not actualFilePath:match("%.lua$") then
            actualFilePath = actualFilePath .. ".lua"
        end
        
        local funcCallSuccess, success, errors = pcall(function()
            return functionChecker:checkFile(actualFilePath)
        end)
        
        if funcCallSuccess then
            -- success 是 checkFile 的第一个返回值, errors 是第二个返回值
            if not success and errors and type(errors) == "table" then
                for _, error in ipairs(errors) do
                    if error and type(error) == "table" then
                        -- 添加到总错误列表
                        table.insert(allErrors, error)
                    end
                end
            end
        end
    end
    
    -- 2. 注意：综合检查器已被移除，以避免重复检查
    -- 综合检查器现在只在main函数的--comprehensive选项中独立运行
    
    -- 3. 运行资源验证检查
    local validator = ResourceValidator:getInstance()
    if not validator.cache.loaded then
        validator:loadResourcesSilent()
    end
    
    return #allErrors == 0, allErrors
end

-- 增强的错误解析器 - 从错误堆栈中提取详细信息
local function parseErrorDetails(error_msg, filepath)
    local error_details = {
        line = nil,
        func_name = nil,
        error_type = nil,
        description = nil,
        raw_error = error_msg
    }
    
    -- 尝试从pcall的错误信息中提取行号
    local function extractLineFromPcallError(err_msg)
        -- 首先检查是否是检查器内部错误
        if err_msg:match("lua_check/main%.lua:%d+:") then
            -- 这是检查器内部错误，不应该提取行号作为用户代码错误
            return nil
        end
        
        -- 模式1: [string "filename"]:line: error
        local line_num = err_msg:match('%[string "[^"]*"%]:(%d+):')
        if line_num then
            return tonumber(line_num)
        end
        
        -- 模式2: filename.lua:line: error
        local escaped_filepath = filepath:gsub("([%.%-%+%*%?%[%]%^%$%(%)%%])", "%%%1")
        line_num = err_msg:match(escaped_filepath .. "%.lua:(%d+):")
        if line_num then
            return tonumber(line_num)
        end
        
        -- 模式3: 通用的 .lua:number: 模式（但排除lua_check目录）
        for file_path, line_str in err_msg:gmatch("([^%s]+%.lua):(%d+):") do
            if not file_path:match("lua_check/") then
                return tonumber(line_str)
            end
        end
        
        -- 模式4: 从stacktrace中提取第一个用户代码行号
        if err_msg:match("stack traceback:") then
            for line in err_msg:gmatch("[^\r\n]+") do
                if line:match("%.lua:%d+:") and not line:match("lua_check/") then
                    local file_part, line_num_str = line:match("([^%s]+%.lua):(%d+)")
                    if line_num_str then
                        return tonumber(line_num_str)
                    end
                end
            end
        end
        
        return nil
    end
    
    -- 首先检查是否是循环检测告警
    if error_msg:match("循环检测告警") then
        error_details.error_type = "loop_detection"
        -- 提取循环检测告警的详细信息
        local alertDetails = error_msg:match("循环检测告警：(.+)")
        if alertDetails then
            error_details.description = alertDetails
        else
            error_details.description = error_msg
        end
        
        -- 从告警信息中提取文件和行号
        local fileName, lineNum = error_msg:match("在 ([^:]+):(%d+)")
        if fileName and lineNum then
            error_details.line = tonumber(lineNum)
        end
        
        return error_details
    end
    
    -- 首先检查是否是Item检查器的特定错误
    if error_msg:match("Item文件") or error_msg:match("FILE_NOT_FOUND") or error_msg:match("FILE_LOAD_ERROR") then
        error_details.error_type = "item_checker_error"
        
        -- 提取Item检查器的错误信息
        local itemErrorMsg = error_msg:match("Item文件[^:]*: (.+)") or 
                            error_msg:match("FILE_LOAD_ERROR[^:]*: (.+)") or 
                            error_msg:match("FILE_NOT_FOUND[^:]*: (.+)") or 
                            error_msg
        
        error_details.description = itemErrorMsg
        return error_details
    end
    
    -- 检查是否是检查器内部错误 - 改进识别逻辑
    if error_msg:match("lua_check/main%.lua:%d+:") then
        -- 检查是否包含用户代码的堆栈信息
        local hasUserCode = false
        local userCodeError = nil
        
                    -- 查找堆栈中的用户代码错误
            for line in error_msg:gmatch("[^\r\n]+") do
                -- 动态查找GenRPG目录下的文件错误信息
                local genRPGDir = pathDetector:findGenRPGDir()
                local genrpgPattern = genRPGDir:gsub("([%.%-%+%*%?%[%]%^%$%(%)%%])", "%%%1") .. "/[^%s]+%.lua:%d+:.*"
                local genrpgMatch = line:match("(" .. genrpgPattern .. ")")
                if genrpgMatch then
                    hasUserCode = true
                    userCodeError = genrpgMatch
                    break
                end
            
            -- 跳过检查器相关的行，查找其他lua文件
            if not line:match("lua_check/") and line:match("%.lua:%d+:") then
                hasUserCode = true
                userCodeError = line
                break
            end
            
            -- 也检查没有文件路径但有错误描述的行
            if not line:match("lua_check/") and not line:match("stack traceback") and 
               (line:match("attempt to") or line:match("syntax error") or line:match("unexpected")) then
                userCodeError = line
                hasUserCode = true
                break
            end
        end
        
        -- 如果找到用户代码错误，使用该错误而不是标记为内部错误
        if hasUserCode and userCodeError then
            -- 从用户代码错误中提取信息
            local userLine = userCodeError:match(":(%d+):")
            if userLine then
                error_details.line = tonumber(userLine)
            end
            
            -- 提取错误描述 - 改进对复杂错误信息的处理
            local description = userCodeError
            
            -- 如果有冒号后的描述，提取它
            local colonDesc = userCodeError:match(":%d+:%s*(.+)")
            if colonDesc then
                description = colonDesc
            end
            
            -- 从堆栈信息中提取第一行的错误描述
            local firstLineError = error_msg:match("([^\r\n]*attempt to[^\r\n]*)")
            if firstLineError then
                description = firstLineError
            end
            
            error_details.description = description:gsub("^%s+", ""):gsub("%s+$", "")
            
            -- 重新分析错误类型
            if description:match("attempt to call a nil value") then
                error_details.error_type = "call_nil_value"
                local global_name = description:match("global '([^']+)'")
                if global_name then
                    error_details.func_name = global_name
                end
            elseif description:match("attempt to index a nil value") then
                error_details.error_type = "index_nil_value"
            elseif description:match("syntax error") then
                error_details.error_type = "syntax_error"
            else
                error_details.error_type = "runtime_error"
            end
        else
            -- 只有在真的没有用户代码错误时才标记为内部错误
            error_details.error_type = "checker_internal_error"
            error_details.description = "检查器内部错误，可能是用户代码中存在未处理的特殊情况"
            error_details.line = nil
        end
        
        return error_details
    end
    
    -- 分析错误类型
    if error_msg:match("attempt to call a nil value") then
        error_details.error_type = "call_nil_value"
        local global_name = error_msg:match("global '([^']+)'")
        if global_name then
            error_details.func_name = global_name
            error_details.description = string.format("attempt to call a nil value (global '%s')", global_name)
        else
            error_details.description = "attempt to call a nil value"
        end
    elseif error_msg:match("attempt to index a nil value") then
        error_details.error_type = "index_nil_value"
        error_details.description = "attempt to index a nil value"
    elseif error_msg:match("syntax error") then
        error_details.error_type = "syntax_error"
        error_details.description = error_msg:match("syntax error[^%c]*") or "syntax error"
    else
        error_details.error_type = "unknown"
        error_details.description = error_msg
    end
    
    -- 提取行号
    error_details.line = extractLineFromPcallError(error_msg)
    
    return error_details
end

-- 检查单个文件
local function checkFile(filepath, showResourceStats, suppressResourceLoadInfo)
    -- 清空之前的错误
    local collectors = getErrorCollectors()
    for _, collector in pairs(collectors) do
        if collector.clearErrors then
            collector:clearErrors()
        end
    end
    
    -- 清空ValidationModule的错误
    ValidationModule.ErrorCollector:clearErrors()
    
    -- 清空全局错误收集器的当前文件错误（但保留总汇总）
    -- 注意：这里不能完全清空，因为我们需要保留错误汇总，但需要避免错误传播到下一个文件
    -- 暂时不清空，而是在错误收集时进行正确的文件归属
    
    -- 加载资源
    local validator = ResourceValidator:getInstance()
    if not validator.cache.loaded then
        if showResourceStats ~= false and not suppressResourceLoadInfo then
            validator:loadResources()
        else
            validator:loadResourcesSilent()
        end
    end
    
    -- 根据文件路径判断文件类型和所需函数
    local function getFileRequirements(path)
        if string.match(path, "/Skill/") then
            return "skill" -- 需要 init() 和 cb()
        elseif string.match(path, "/NPC/") or string.match(path, "/Level/") then
            return "npc_or_level" -- 需要 cb()
        elseif string.match(path, "/Prof/") or string.match(path, "/Locator/") or string.match(path, "/Item/") then
            return "no_function" -- 不需要特定函数
        else
            return "unknown" -- 未知类型，默认需要cb()
        end
    end
    
    -- 获取基础目录用于综合检查
    local baseDir = filepath:gsub("/[^/]+$", ""):gsub("/[^/]+$", ""):gsub("/[^/]+$", "")
    
    -- 安全执行函数，带有增强的超时和循环检测保护
    local function safeExecuteFunction(func, funcName, timeout)
        timeout = timeout or CURRENT_CONFIG.defaultTimeout -- 使用默认超时时间
        
        -- 创建循环检测器
        local detector = LoopDetector:new()
        detector:start(timeout)
        
        -- 动态检测可能导致无限循环的API函数
        local function detectOriginalFunctions()
            local functions = {}
            
            -- 动态检测所有API函数
            for globalName, globalValue in pairs(_G) do
                if type(globalValue) == "function" then
                    -- 检查是否是API函数（以特定前缀开头）
                    if globalName:match("^LEVEL_") or 
                       globalName:match("^NPC_") or 
                       globalName:match("^Skill_") or
                       globalName:match("^AI_") then
                        functions[globalName] = globalValue
                    end
                end
            end
            
            return functions
        end
        
        local originalFunctions = detectOriginalFunctions()
        
        -- 重写API函数来检测循环
        local function wrapApiFunction(originalFunc, apiName)
            if originalFunc and type(originalFunc) == "function" then
                return function(...)
                    detector:recordFunctionCall(funcName, apiName)
                    return originalFunc(...)
                end
            else
                return originalFunc
            end
        end
        
        -- 包装所有检测到的API函数
        local wrappedFunctions = {}
        for globalName, originalFunc in pairs(originalFunctions) do
            if originalFunc and type(originalFunc) == "function" then
                -- 提取API名称，移除前缀
                local apiName = globalName:gsub("^(LEVEL_|AI_|Skill_|NPC_)", "")
                local wrappedFunc = wrapApiFunction(originalFunc, apiName)
                wrappedFunctions[globalName] = wrappedFunc
                _G[globalName] = wrappedFunc
            end
        end
        
        -- 在执行函数前启用验证模式，允许参数错误时继续执行
        ValidationModule.setValidationMode(true)
        
        -- 执行函数
        local success, result = pcall(func)
        
        -- 执行完成后关闭验证模式
        ValidationModule.setValidationMode(false)
        
        -- 恢复原始函数
        for globalName, originalFunc in pairs(originalFunctions) do
            if originalFunc and type(originalFunc) == "function" then
                _G[globalName] = originalFunc
            end
        end
        
        if not success then
            -- 确保result是字符串类型
            local result_str = result
            if type(result) ~= "string" then
                result_str = tostring(result or "Unknown error")
            end
            
            -- 检查是否是循环检测告警
            if string.match(result_str, "循环检测告警") then
                -- 清理循环检测告警信息，移除检查器路径
                local cleanedAlert = result_str:gsub("lua_check/main%.lua:%d+:%s*", "")
                print(string.format("🔄 %s", cleanedAlert))
                
                -- 循环检测是严重错误，必须立即停止当前文件处理
                -- 但记录到全局错误收集器，不影响其他文件
                GlobalErrorCollector:addError("LOOP_DETECTION", "INFINITE_LOOP", cleanedAlert, filepath, nil)
                error("LOOP_DETECTION_STOP: " .. cleanedAlert)
            end
            
            -- 对于其他错误，保持完整的堆栈信息以便错误解析器分析
            safeError(result_str, "EXECUTION_ERROR", nil, nil)
        end
        
        return success, result
    end
    
    -- 尝试加载并执行文件
    local success, result = pcall(function()
        -- 如果文件路径已经有.lua后缀，就不要再添加
        local actualFilePath = filepath
        if not filepath:match("%.lua$") then
            actualFilePath = filepath .. ".lua"
        end
        local module = dofile(actualFilePath)
        local fileType = getFileRequirements(filepath)
        
        if module == nil then
            safeError("文件加载失败：模块返回nil", "FILE_LOAD", filepath, nil)
        elseif type(module) ~= "table" then
            safeError("文件格式不正确：模块必须返回一个table", "FILE_LOAD", filepath, nil)
        end
        
        -- 根据文件类型验证所需函数
        if fileType == "skill" then
            -- Skill文件需要init()和cb()函数
            if module.init == nil then
                safeError("Skill文件缺少init()函数：模块必须包含init()函数", "FILE_LOAD", filepath, nil)
            elseif type(module.init) ~= "function" then
                safeError("Skill文件init()格式不正确：init必须是一个函数", "FILE_LOAD", filepath, nil)
            elseif module.cb == nil then
                safeError("Skill文件缺少cb()函数：模块必须包含cb()函数", "FILE_LOAD", filepath, nil)
            elseif type(module.cb) ~= "function" then
                safeError("Skill文件cb()格式不正确：cb必须是一个函数", "FILE_LOAD", filepath, nil)
            end
            
            -- 安全执行init()函数
            safeExecuteFunction(module.init, "init", 3)
            
            -- 安全执行cb()函数，对于技能文件给更长的超时时间
            safeExecuteFunction(module.cb, "cb", CURRENT_CONFIG.defaultTimeout * 2)
            
        elseif fileType == "npc_or_level" then
            -- NPC和Level文件需要cb()函数
            if module.cb == nil then
                safeError("文件缺少cb()函数：模块必须包含cb()函数", "FILE_LOAD", filepath, nil)
            elseif type(module.cb) ~= "function" then
                safeError("cb()格式不正确：cb必须是一个函数", "FILE_LOAD", filepath, nil)
            end
            
            -- 安全执行cb()函数 - 使用xpcall获取详细错误堆栈
            local function executeWithTraceback()
                return module.cb()
            end
            
            local tempSuccess, tempResult = xpcall(executeWithTraceback, debug.traceback)
            if not tempSuccess then
                -- 直接抛出完整的错误信息，包含堆栈
                safeError(tempResult, "EXECUTION_ERROR", filepath, nil)
            end
            
        elseif fileType == "no_function" then
            -- Prof和Locator文件不需要特定函数，只要能加载即可
            -- 不需要执行任何函数
            
            -- 对于Prof文件，执行NPC配置校验
            if string.match(filepath, "/Prof/") and module then
                -- 使用ValidationModule中的validateNpcProfConfig函数
                local validateSuccess = ValidationModule.validateNpcProfConfig(module, "NPC_PROF_CHECK", filepath)
                if not validateSuccess then
                    -- 错误已由validateNpcProfConfig记录到ErrorCollector中
                end
            end
            
            -- 对于Item文件，执行Item专用检查
            if string.match(filepath, "/Item/") and module then
                local ItemChecker = require("lua_check.item_checker")
                local itemChecker = ItemChecker:new()
                
                -- 构建完整的文件路径
                local fullItemPath = filepath
                if not fullItemPath:match("%.lua$") then
                    fullItemPath = fullItemPath .. ".lua"
                end
                
                local itemSuccess = itemChecker:checkItemFile(fullItemPath)
                if not itemSuccess then
                    -- 直接获取ItemChecker的错误并添加到当前文件的错误列表中
                    local itemErrors = itemChecker:getErrors()
                    for _, itemError in ipairs(itemErrors) do
                        -- 将错误添加到GlobalErrorCollector中，确保能被后续逻辑收集
                        if GlobalErrorCollector then
                            GlobalErrorCollector:addError("ITEM_CHECKER", itemError.type, itemError.message, fullItemPath, itemError.line)
                        end
                        
                        -- 同时将错误添加到ValidationModule的ErrorCollector中，确保能在当前文件检查中立即显示
                        ValidationModule.ErrorCollector:recordError(
                            "ITEM_CHECKER",
                            itemError.type,
                            string.format("Item检查失败: %s", itemError.message)
                        )
                    end
                end
            end
            
        else
            -- 未知类型，默认检查cb()函数
            if module.cb == nil then
                safeError("文件缺少cb()函数：模块必须包含cb()函数", "FILE_LOAD", filepath, nil)
            elseif type(module.cb) ~= "function" then
                safeError("cb()格式不正确：cb必须是一个函数", "FILE_LOAD", filepath, nil)
            end
            
            -- 安全执行cb()函数
            safeExecuteFunction(module.cb, "cb", CURRENT_CONFIG.defaultTimeout)
        end
        
        return module
    end)
    
    -- 先运行静态检查器（函数调用检查器），再执行文件
    local checkerSuccess, checkResult = pcall(function()
        local success, errors = runAllCheckers(filepath, baseDir)
        return {success = success, errors = errors}
    end)
    
    -- 如果检查器本身出错，记录但不影响主流程
    if not checkerSuccess then
        safeError(tostring(checkResult), "CHECKER_ERROR", nil, nil)
    end
    
    -- 收集静态检查和动态检查错误，并使用错误合并器处理
    local staticErrors = {}    -- 静态检查错误（来自runAllCheckers的返回值）
    local dynamicErrors = {}   -- 动态检查错误（来自ValidationModule）
    local globalErrors = {}    -- 全局错误
    
    -- 标准化文件路径用于匹配
    local normalizedFilepath = filepath
    if not normalizedFilepath:match("%.lua$") then
        normalizedFilepath = normalizedFilepath .. ".lua"
    end
    
    -- 1. 获取静态检查错误（从runAllCheckers的返回值）
    if checkerSuccess and checkResult then
        local checkSuccess = checkResult.success
        local checkErrors = checkResult.errors
        
        if not checkSuccess and checkErrors and type(checkErrors) == "table" then
            for _, error in ipairs(checkErrors) do
                if error and type(error) == "table" then
                    table.insert(staticErrors, error)
                end
            end
        end
    end
    
    -- 2. 收集动态检查错误（ValidationModule的错误，但排除静态检查已记录的错误）
    if ValidationModule and ValidationModule.ErrorCollector and ValidationModule.ErrorCollector.getErrors then
        local validationErrors = ValidationModule.ErrorCollector:getErrors()
        -- 确保validationErrors不为nil且是一个表
        if validationErrors and type(validationErrors) == "table" then
            for _, error in ipairs(validationErrors) do
                -- 确保error不为nil且是一个表
                if error and type(error) == "table" then
                    -- 只收集非FUNCTION_CALL_ERROR类型的错误，因为这些已经在静态检查中处理
                    if error.type ~= "FUNCTION_CALL_ERROR" then
                        table.insert(dynamicErrors, error)
                    end
                end
            end
        end
    end
    
    -- 3. 从全局错误收集器中收集与当前文件相关的错误
    if GlobalErrorCollector and GlobalErrorCollector.getErrors then
        local globalErrorList = GlobalErrorCollector:getErrors()
        if globalErrorList and type(globalErrorList) == "table" then
            for _, error in ipairs(globalErrorList) do
                if error and type(error) == "table" then
                    -- 检查错误是否与当前文件相关
                    local errorFilepath = error.filepath
                    local isCurrentFileError = false
                    
                    if errorFilepath then
                        -- 标准化错误文件路径
                        local normalizedErrorPath = errorFilepath
                        if not normalizedErrorPath:match("%.lua$") then
                            normalizedErrorPath = normalizedErrorPath .. ".lua"
                        end
                        
                        -- 检查是否匹配当前文件
                        if normalizedErrorPath == normalizedFilepath or 
                           normalizedErrorPath:match(filepath:gsub("([%.%-%+%*%?%[%]%^%$%(%)%%])", "%%%1")) then
                            isCurrentFileError = true
                        end
                    else
                        -- 如果错误没有指定文件路径，检查错误详情中是否包含当前文件路径
                        local details = error.details or ""
                        if details:match(filepath:gsub("([%.%-%+%*%?%[%]%^%$%(%)%%])", "%%%1")) then
                            isCurrentFileError = true
                        end
                    end
                    
                    -- 只收集与当前文件相关的错误
                    if isCurrentFileError then
                        table.insert(globalErrors, error)
                    end
                end
            end
        end
    end
    
    -- 4. 使用错误合并器处理静态检查和动态检查错误
    local errorMerger = ErrorMerger:new()
    local mergedStaticErrors, ignoredErrors = errorMerger:mergeErrors(staticErrors, dynamicErrors)
    
    -- 5. 合并所有错误并进行去重
    local allErrors = {}
    local errorSet = {}  -- 用于去重的集合
    local totalOriginalErrors = 0
    local duplicateCount = 0
    
    -- 添加合并后的静态检查错误
    for _, error in ipairs(mergedStaticErrors) do
        totalOriginalErrors = totalOriginalErrors + 1
        
        -- 将静态错误转换为动态错误格式以便统一处理
        local errorDetails = ""
        if error.errors and #error.errors > 0 then
            errorDetails = table.concat(error.errors, "; ")
        end
        local formattedError = string.format("%s:%d: %s [函数: %s]",
            error.file or filepath,
            error.startLine or 0,
            errorDetails,
            error.function_name or "unknown"
        )
        
        local dynamicError = {
            api = error.function_name or "STATIC_CHECK",
            type = "STATIC_CHECK_ERROR",
            details = formattedError,
            system = "static"
        }
        
        local coreError = errorDetails
        local errorKey = string.format("%s:%s:%s", 
            dynamicError.api or "UNKNOWN", 
            dynamicError.type or "UNKNOWN_ERROR", 
            coreError)
        
        if not errorSet[errorKey] then
            errorSet[errorKey] = true
            table.insert(allErrors, dynamicError)
        else
            duplicateCount = duplicateCount + 1
        end
    end
    
    -- 添加动态检查错误
    for _, error in ipairs(dynamicErrors) do
        totalOriginalErrors = totalOriginalErrors + 1
        
        local details = error.details or ""
        local coreError = details:gsub("^[^:]*:%d*:%s*", ""):gsub("^[^:]*:%s*", "")
        local errorKey = string.format("%s:%s:%s", 
            error.api or "UNKNOWN", 
            error.type or "UNKNOWN_ERROR", 
            coreError)
        
        if not errorSet[errorKey] then
            errorSet[errorKey] = true
            error.system = "dynamic"
            table.insert(allErrors, error)
        else
            duplicateCount = duplicateCount + 1
        end
    end
    
    -- 添加全局错误
    for _, error in ipairs(globalErrors) do
        totalOriginalErrors = totalOriginalErrors + 1
        
        local details = error.details or ""
        local coreError = details:gsub("^[^:]*:%d*:%s*", ""):gsub("^[^:]*:%s*", "")
        local errorKey = string.format("%s:%s:%s", 
            error.api or "UNKNOWN", 
            error.type or "UNKNOWN_ERROR", 
            coreError)
        
        if not errorSet[errorKey] then
            errorSet[errorKey] = true
            error.system = "global"
            table.insert(allErrors, error)
        else
            duplicateCount = duplicateCount + 1
        end
    end
    
    -- 显示结果
    if success then
        -- 通过时不显示任何提示
    else
        -- 构建更清晰的错误信息格式
        local error_msg = tostring(result)
        
        -- 清理错误信息，使用增强的错误解析器
        local function cleanErrorMessage(error_msg)
            -- 使用新的错误解析器提取详细信息
            local error_details = parseErrorDetails(error_msg, filepath)
            
            -- 构建清晰的错误消息
            local parts = {}
            
            -- 行号信息将在后面与文件路径组合，这里不添加
            
            -- 添加错误描述
            if error_details.description then
                table.insert(parts, error_details.description)
            end
            
            -- 添加函数名信息（如果有且不同于全局函数名）
            if error_details.func_name and not error_details.description:match(error_details.func_name) then
                table.insert(parts, string.format("(function: %s)", error_details.func_name))
            end
            
            -- 如果解析器没有提取到有用信息，回退到原来的逻辑
            if #parts == 0 then
                local cleaned = error_msg:gsub("lua_check/main%.lua:%d+:%s*", "")
                local detail = cleaned:match("attempt to ([^%(]+%([^%)]*%)[^%)]*)")
                if detail then
                    return "attempt to " .. detail
                end
                return cleaned
            end
            
            return table.concat(parts, ": ")
        end
        
        -- 改进错误信息格式，使其更清晰
        local function formatFileError(filepath, error_msg)
            -- 首先清理错误信息
            local cleaned_msg = cleanErrorMessage(error_msg)
            
            -- 构建文件路径，避免双重.lua后缀
            local file_path = filepath
            if not file_path:match("%.lua$") then
                file_path = file_path .. ".lua"
            end
            
            -- 进一步清理冗余信息，移除lua_check相关路径和重复的文件路径
            cleaned_msg = cleaned_msg:gsub("lua_check/main%.lua:%d+:%s*", "")
            cleaned_msg = cleaned_msg:gsub(filepath:gsub("([%.%-%+%*%?%[%]%^%$%(%)%%])", "%%%1") .. "%.lua:%d+:%s*", "")
            local genRPGDir = pathDetector:findGenRPGDir()
            local genrpgPattern = genRPGDir:gsub("([%.%-%+%*%?%[%]%^%$%(%)%%])", "%%%1") .. "/[^%s]*%.lua:%d+:%s*"
            cleaned_msg = cleaned_msg:gsub(genrpgPattern, "")
            
            -- 如果清理后的消息已经包含行号信息（以line开头），直接使用
            if cleaned_msg:match("^line %d+:") then
                return string.format("%s: %s", adjustPathDisplay(file_path), cleaned_msg)
            end
            
            -- 如果错误信息已经包含了完整的文件路径和行号，直接使用
            if cleaned_msg:match("%.lua:%d+:") then
                return cleaned_msg
            end
            
            -- 检查原始错误消息是否已经包含了正确的文件路径和行号
            local genRPGDir = pathDetector:findGenRPGDir()
            local genrpgPattern = genRPGDir:gsub("([%.%-%+%*%?%[%]%^%$%(%)%%])", "%%%1") .. "/[^%s]*%.lua:%d+:"
            if error_msg:match(genrpgPattern) then
                -- 提取嵌套的错误信息，格式可能是: lua_check/xxx.lua:123: GenRPG/xxx.lua:456: 错误信息
                local nestedError = error_msg:match(genRPGDir:gsub("([%.%-%+%*%?%[%]%^%$%(%)%%])", "%%%1") .. "/[^%s]*%.lua:%d+:[^\r\n]*")
                if nestedError then
                    return nestedError  -- 提取GenRPG部分的错误，保留行号
                end
                
                -- 如果没有嵌套，提取第一行错误信息
                local firstLine = error_msg:match("([^\r\n]*)")
                if firstLine and firstLine:match(genrpgPattern) then
                    return firstLine  -- 只返回第一行，保留行号但去掉stack traceback
                end
            end
            
            -- 检查是否是API调用错误，提取更多详细信息
            if cleaned_msg:match("attempt to call a nil value") then
                local func_name = cleaned_msg:match("global '([^']+)'")
                if func_name then
                    return string.format("%s: attempt to call a nil value (global '%s')", adjustPathDisplay(file_path), func_name)
                end
                return string.format("%s: %s", adjustPathDisplay(file_path), cleaned_msg)
            end
            
            -- 检查是否是 attempt to index a nil value 错误
            if cleaned_msg:match("attempt to index a nil value") then
                return string.format("%s: %s", adjustPathDisplay(file_path), cleaned_msg)
            end
            
            -- 对于其他错误，使用标准格式
            return string.format("%s: %s", adjustPathDisplay(file_path), cleaned_msg)
        end
        
        local formatted_error = formatFileError(filepath, error_msg)
        
        local fileError = {
            api = "FILE_LOAD",
            type = "SYNTAX_ERROR",
            details = formatted_error,
            system = "loader"
        }
        
        -- 调试代码已移除
        
        table.insert(allErrors, fileError)
    end
    
    -- 显示结果 - 改进显示格式
    if #allErrors > 0 then
        -- 获取错误统计
        local stats = ValidationModule.ErrorCollector:getErrorStats()
        
        -- 显示详细错误信息
        -- 确保文件路径正确显示，避免双重.lua后缀
        local displayPath = filepath
        if not displayPath:match("%.lua$") then
            displayPath = displayPath .. ".lua"
        end
        
        -- 计算最终去重后的错误数量
        local finalErrorSet = {}
        local finalErrorCount = 0
        for _, error in ipairs(allErrors) do
            local errorText = error.details or string.format("[%s] %s", error.api or "UNKNOWN", error.type or "UNKNOWN_ERROR")
            if not finalErrorSet[errorText] then
                finalErrorSet[errorText] = true
                finalErrorCount = finalErrorCount + 1
            end
        end
        
        print(string.format("❌ 检查文件: ./%s 失败 (%d个错误)", adjustPathDisplay(displayPath), finalErrorCount))
        
        -- 最终去重：移除完全相同的错误信息
        local finalErrors = {}
        local finalErrorSet = {}
        local finalDuplicateCount = 0
        
        for _, error in ipairs(allErrors) do
            local errorText = error.details or string.format("[%s] %s", error.api or "UNKNOWN", error.type or "UNKNOWN_ERROR")
            
            if not finalErrorSet[errorText] then
                finalErrorSet[errorText] = true
                table.insert(finalErrors, error)
            else
                finalDuplicateCount = finalDuplicateCount + 1
            end
        end
        
        -- 合并显示去重统计信息
        local totalFiltered = duplicateCount + finalDuplicateCount
        if totalFiltered > 0 then
            local filterDetails = {}
            if duplicateCount > 0 then
                table.insert(filterDetails, string.format("%d个重复错误", duplicateCount))
            end
            if finalDuplicateCount > 0 then
                table.insert(filterDetails, string.format("%d个完全相同错误", finalDuplicateCount))
            end
            print(string.format("   🔄 已过滤 %d 个错误 (%s)", totalFiltered, table.concat(filterDetails, ", ")))
        end
        
        -- 显示每个错误的详细信息
        for i, error in ipairs(finalErrors) do
            if error.details then
                print(string.format("   %d. %s", i, error.details))
            else
                print(string.format("   %d. [%s] %s", i, error.api or "UNKNOWN", error.type or "UNKNOWN_ERROR"))
            end
        end
        
        -- 显示循环检测统计
        if stats.maxReached then
            print(string.format("⚠️  注意：已达到最大错误数量限制(%d)，可能还有更多错误未显示", stats.max))
        end
        
    else
        -- print(string.format("✅ 检查文件: ./%s 通过", displayPath))
    end
    
    -- 显示资源统计（仅在单文件检查时显示）
    if showResourceStats ~= false and not suppressResourceLoadInfo then
        local stats = validator:getResourceStats()
        print(string.format("\n📊 资源统计:"))
        print(string.format("  • NPC模板: %d个", stats.npcCount))
        print(string.format("  • 技能模板: %d个", stats.skillCount))
        print(string.format("  • 定位器: %d个", stats.locatorCount))
        print(string.format("  • 物品模板: %d个", stats.itemCount))
    end
    
    return #allErrors == 0, allErrors
end

-- 批量检查目录
local function checkDirectory(directory, fileType, enableStaticCheckParam)
    enableStaticCheckParam = enableStaticCheckParam or false
    
    -- 在批量检查开始时静默加载一次资源
    local validator = ResourceValidator:getInstance()
    validator:reset() -- 确保每次批量检查都重新加载
    validator:loadResourcesSilent()
    
    -- 清空ValidationModule的错误
    ValidationModule.ErrorCollector:clearErrors()
    
    -- 显示动态检测的API统计信息
    local function showApiDetectionStats()
        local errorCollectors = getErrorCollectors()
        
        -- 动态生成API统计结构
        local apiStats = {
            errorCollectors = 0,
            categories = {}
        }
        
        -- 统计ErrorCollector
        for name, collector in pairs(errorCollectors) do
            apiStats.errorCollectors = apiStats.errorCollectors + 1
        end
        
        -- 动态统计API函数
        for globalName, globalValue in pairs(_G) do
            if type(globalValue) == "function" then
                local category = nil
                if globalName:match("^LEVEL_") then
                    category = "Level API"
                elseif globalName:match("^Skill_") then
                    category = "Skill API"
                elseif globalName:match("^NPC_") or globalName:match("^AI_") then
                    category = "NPC/AI API"
                elseif globalName:match("^[A-Z]+_") then
                    category = "其他 API"
                end
                
                if category then
                    apiStats.categories[category] = (apiStats.categories[category] or 0) + 1
                end
            end
        end
        
        print(string.format("🔧 动态检测统计:"))
        print(string.format("  • 错误收集器: %d个", apiStats.errorCollectors))
        
        -- 显示各个类别的统计
        for category, count in pairs(apiStats.categories) do
            print(string.format("  • %s: %d个", category, count))
        end
    end
    
    showApiDetectionStats()
    
    local files = {}
    local totalErrors = 0
    local successCount = 0
    
    -- 动态扫描目录中的所有lua文件
    local function scanDirectory(dir)
        local result = {}
        -- 标准化目录路径，移除末尾斜杠
        local normalizedDir = dir:gsub("/$", "")
        local handle = io.popen("find " .. normalizedDir .. " -name '*.lua' -type f 2>/dev/null")
        if handle then
            for line in handle:lines() do
                -- 移除.lua扩展名和目录前缀
                local relativePath = line:gsub("^" .. normalizedDir:gsub("([%^%$%(%)%.%[%]%*%+%-%?])", "%%%1") .. "/", "")
                local fileWithoutExt = relativePath:gsub("%.lua$", "")
                table.insert(result, fileWithoutExt)
            end
            handle:close()
        end
        return result
    end
    
    files = scanDirectory(directory)
    
    if #files == 0 then
        print("⚠️  在目录 " .. directory .. " 中未找到任何lua文件")
        return false
    end
    
    print("🔍 检查所有" .. directory .. "目录下的lua文件 ")
    print("📁 找到 " .. #files .. " 个文件需要检查")
    
    -- 如果是Level目录，先运行综合检查器
    if directory:match("Level") then
        local genRPGDir = pathDetector:findGenRPGDir()
        runComprehensiveCheck(genRPGDir, enableStaticCheckParam)
    end
    
    for _, file in ipairs(files) do
        -- 修复路径拼接，确保没有双斜杠
        local filepath = directory:gsub("/$", "") .. "/" .. file
        
        local success, errors = checkFile(filepath, false, true)  -- 批量检查时不显示资源统计和加载信息
        if success then
            successCount = successCount + 1
        else
            totalErrors = totalErrors + 1
        end
    end
    
    -- 在最后显示资源统计和检查结果
    local stats = validator:getResourceStats()
    local errorStats = ValidationModule.ErrorCollector:getErrorStats()
    
    print(string.format("\n📊 资源统计:"))
    print(string.format("  • NPC模板: %d个", stats.npcCount))
    print(string.format("  • 技能模板: %d个", stats.skillCount))
    print(string.format("  • 定位器: %d个", stats.locatorCount))
    print(string.format("  • 物品模板: %d个", stats.itemCount))
    
    print(string.format("\n📈 检查结果:"))
    print(string.format("  • 检查完成: %d/%d 文件通过", successCount, #files))
    print(string.format("  • 错误统计: %d/%d 错误", errorStats.current, errorStats.max))
    
    if errorStats.maxReached then
        print(string.format("  ⚠️  注意：已达到最大错误数量限制，可能还有更多错误未显示"))
    end
    
    if totalErrors > 0 then
        print(string.format("  ❌ 失败文件: %d个", totalErrors))
    end
    
    return totalErrors == 0
end

-- 主函数
local function main()
    local args = arg
    
    if #args == 0 then
        print("用法:")
        print("  lua lua_check/main.lua <文件路径>")
        print("  lua lua_check/main.lua --batch <目录路径>")
        print("  lua lua_check/main.lua --batch <目录路径> --max-errors <数量>")
        print("  lua lua_check/main.lua --comprehensive <目录路径>")
        print("  lua lua_check/main.lua --show-api-detection")
        print("\n选项:")
        print("  --max-errors <数量>    设置最大错误数量限制 (默认: 100)")
        print("  --comprehensive        运行综合检查器") 
        print("  --enable-static-check  启用静态检查 (默认关闭)")
        print("  --show-api-detection   显示动态检测到的API函数详细信息")
        print("  --verbose              显示详细的动态检测信息")
        print("  --config <配置>        设置循环检测配置 (格式: key=value,key=value)")
        print("  --depth <层级>         设置错误路径显示深度 (默认: 0)")
        print("\n配置选项:")
        print("  maxTotalCalls=<数量>    最大总调用次数 (默认: 1000)")
        print("  maxSingleFunctionCalls=<数量> 单个函数最大调用次数 (默认: 200)")
        print("  defaultTimeout=<秒数>   默认超时时间 (默认: 10)")
        print("  errorThreshold=<数量>   错误数量激增阈值 (默认: 20)")
        print("  patternRepeatThreshold=<数量> 重复模式检测阈值 (默认: 10)")
        print("\n示例:")
        print("  lua lua_check/main.lua GenRPG/Level/stage1/process")
        print("  lua lua_check/main.lua --batch GenRPG/Level/")
        print("  lua lua_check/main.lua --batch GenRPG/Level/ --max-errors 50")
        print("  lua lua_check/main.lua --comprehensive GenRPG/")
        print("  lua lua_check/main.lua --comprehensive GenRPG/ --enable-static-check")
        print("  lua lua_check/main.lua --show-api-detection")
        print("  lua lua_check/main.lua GenRPG/Level/stage1/process --config maxTotalCalls=500,defaultTimeout=5")
        print("\n注意: GenRPG目录路径会自动检测，支持在不同项目目录下使用")
        return
    end
    
    -- 解析命令行参数
    local function parseArgs(args)
        local result = {
            filepath = nil,
            directory = nil,
            isBatch = false,
            isComprehensive = false,
            enableStaticCheck = false,
            showApiDetection = false,
            verbose = false,
            maxErrors = 100,  -- 默认值
            config = nil,
            depth = 2  -- 默认路径显示深度
        }
        
        local i = 1
        while i <= #args do
            local arg = args[i]
            
            if arg == "--batch" then
                result.isBatch = true
                i = i + 1
                if i <= #args then
                    result.directory = args[i]
                end
            elseif arg == "--comprehensive" then
                result.isComprehensive = true
                i = i + 1
                if i <= #args then
                    result.directory = args[i]
                end
            elseif arg == "--show-api-detection" then
                result.showApiDetection = true
            elseif arg == "--enable-static-check" then
                result.enableStaticCheck = true
            elseif arg == "--verbose" then
                result.verbose = true
            elseif arg == "--max-errors" then
                i = i + 1
                if i <= #args then
                    local maxErrors = tonumber(args[i])
                    if maxErrors and maxErrors > 0 then
                        result.maxErrors = maxErrors
                    else
                        print("❌ 错误：--max-errors 参数必须是正整数")
                        return nil
                    end
                end
            elseif arg == "--config" then
                i = i + 1
                if i <= #args then
                    result.config = args[i]
                end
            elseif arg == "--depth" then
                i = i + 1
                if i <= #args then
                    local depth = tonumber(args[i])
                    if depth and depth >= 0 then
                        result.depth = depth
                    else
                        print("❌ 错误：--depth 参数必须是非负整数")
                        return nil
                    end
                end
            elseif not result.filepath and not result.isBatch and not result.isComprehensive and not result.showApiDetection then
                result.filepath = arg
            end
            
            i = i + 1
        end
        
        return result
    end
    
    local config = parseArgs(args)
    if not config then
        return
    end
    
    -- 解析和应用配置
    if config.config then
        local newConfig = {}
        for pair in config.config:gmatch("[^,]+") do
            local key, value = pair:match("([^=]+)=(.+)")
            if key and value then
                local numValue = tonumber(value)
                if numValue then
                    newConfig[key] = numValue
                else
                    print(string.format("⚠️  警告：配置值 '%s' 不是有效数字，已忽略", value))
                end
            else
                print(string.format("⚠️  警告：配置格式错误 '%s'，应为 key=value 格式", pair))
            end
        end
        
        if next(newConfig) then
            updateConfig(newConfig)
            print("🔧 已应用自定义配置:")
            for k, v in pairs(newConfig) do
                print(string.format("  • %s = %s", k, v))
            end
        end
    end
    
    -- 设置最大错误数量限制
    if config.maxErrors ~= 100 then
        ValidationModule.ErrorCollector:setMaxErrors(config.maxErrors)
    end
    
    -- 设置路径显示深度
    setPathDisplayDepth(config.depth)
    
    -- 显示API检测详细信息的函数
    local function showDetailedApiDetection()
        print("🔧 动态API检测详细信息")
        print(string.rep("=", 60))
        
        -- 显示ErrorCollector信息
        local errorCollectors = getErrorCollectors()
        print("\n📋 错误收集器:")
        for name, collector in pairs(errorCollectors) do
            print(string.format("  • %s: %s", name, type(collector)))
        end
        
        -- 动态生成API分类
        local apiCategories = {}
        
        for globalName, globalValue in pairs(_G) do
            if type(globalValue) == "function" then
                local category = nil
                if globalName:match("^LEVEL_") then
                    category = "LEVEL"
                elseif globalName:match("^Skill_") then
                    category = "Skill"
                elseif globalName:match("^NPC_") then
                    category = "NPC"
                elseif globalName:match("^AI_") then
                    category = "AI"
                elseif globalName:match("^[A-Z]+_") then
                    category = "Other"
                end
                
                if category then
                    if not apiCategories[category] then
                        apiCategories[category] = {}
                    end
                    table.insert(apiCategories[category], globalName)
                end
            end
        end
        
        for category, functions in pairs(apiCategories) do
            if #functions > 0 then
                table.sort(functions)
                print(string.format("\n🔹 %s API (%d个):", category, #functions))
                for i, funcName in ipairs(functions) do
                    if config.verbose or i <= 10 then
                        print(string.format("  %d. %s", i, funcName))
                    elseif i == 11 then
                        print(string.format("  ... 还有 %d 个函数 (使用 --verbose 查看全部)", #functions - 10))
                        break
                    end
                end
            end
        end
        
        print("\n📊 统计汇总:")
        local totalApiFunctions = 0
        for _, functions in pairs(apiCategories) do
            totalApiFunctions = totalApiFunctions + #functions
        end
        print(string.format("  • 总计API函数: %d个", totalApiFunctions))
        print(string.format("  • 错误收集器: %d个", #errorCollectors))
    end
    
    if config.showApiDetection then
        -- 显示API检测信息
        showDetailedApiDetection()
        
    elseif config.isComprehensive then
        if not config.directory then
            print("❌ 综合检查需要指定目录路径")
            return
        end
        
        -- 运行综合检查器
        local checker = ComprehensiveChecker:new()
        local success, errors = checker:checkAllLevelFiles(config.directory, config.enableStaticCheck)
        
        if success then
            print("✅ 综合检查完成，未发现问题")
        else
            print(string.format("❌ 综合检查完成，发现 %d 个问题", #errors))
        end
        
        -- 生成报告
        local report = checker:generateReport()
        print("\n" .. report)
        
        -- 保存报告
        local reportFilename = string.format("comprehensive_check_report_%s.txt", os.date("%Y%m%d_%H%M%S"))
        checker:saveReport(reportFilename)
        
    elseif config.isBatch then
        if not config.directory then
            print("❌ 批量检查需要指定目录路径")
            return
        end
        
        checkDirectory(config.directory, "all", config.enableStaticCheck)
    elseif config.filepath then
        checkFile(config.filepath, true, false)  -- 单文件检查时显示资源统计
    else
        print("❌ 错误：必须指定文件路径或使用 --batch, --comprehensive, --show-api-detection 选项之一")
    end
    
    -- 在程序结束时显示全局错误汇总
    GlobalErrorCollector:printSummary()
end

-- 执行主函数
main()

