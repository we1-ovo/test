-- 统一验证模块 - 合并所有API系统的参数验证和资源检查
-- 提供给Level、AI、Skill系统使用

-- 加载资源验证器
local ResourceValidator = require("lua_check.resource_validator")
local validator = ResourceValidator:getInstance()

-- 注意：参数个数验证现在由function_call_checker在静态分析阶段完成

-- 智能错误处理函数 - 记录错误但不停止执行
local function smartError(message)
    -- 获取非lua_check目录的调用堆栈信息
    local traceback = debug.traceback()
    local businessFileLine = nil
    
    -- 调试代码已移除
    
    for line in traceback:gmatch("[^\r\n]+") do
        if line:match("%.lua:%d+:") and not line:match("lua_check/") then
            -- 提取文件路径和行号，修正格式以匹配函数调用检查器
            local path_match, line_match = line:match("([^%s]+%.lua):(%d+)")
            if path_match then
                -- 移除可能的双重.lua后缀
                path_match = path_match:gsub("%.lua%.lua$", ".lua")
                -- 移除@前缀（如果存在）
                if path_match:sub(1, 1) == "@" then
                    path_match = path_match:sub(2)
                end
                businessFileLine = path_match .. ":" .. line_match
                break
            end
        end
    end
    
    -- 构造错误信息
    local fullMessage = businessFileLine and (businessFileLine .. ": " .. message) or message
    
    -- 记录到全局错误收集器（如果存在）
    if _G.GlobalErrorCollector then
        local filepath, line = businessFileLine and businessFileLine:match("([^:]+):(%d+)") or nil, nil
        _G.GlobalErrorCollector:addError("VALIDATION", "SMART_ERROR", message, filepath, line)
    end
    
    -- 记录到ErrorCollector（在文件后面定义，先不直接引用）
    -- ErrorCollector将在后面被定义并处理这些错误
    
    -- 打印错误信息但不停止执行
    -- print(string.format("❌ [VALIDATION] %s", fullMessage))
    
    -- 返回false表示有错误，但不停止执行
    return false
end

-- 验证配置表
local ValidationConfig = {
    -- 枚举类型参数配置
    enums = {
        emotionid = {
            validValues = {"happy", "sad", "angry", "fearful", "disgust", "surprised", "neutral"},
            functionWhitelist = {},  -- 跳过检查的函数名列表
            description = "情绪ID"
        },
        damagetype = {
            validValues = {"damage_physical", "damage_magic"},
            functionWhitelist = {},
            description = "伤害类型"
        },
        targettype = {
            validValues = {"enemy", "friend", "all", "self"},
            functionWhitelist = {},
            description = "目标类型"
        },
        regiontype = {
            validValues = {0, 1, 2},  -- 0=trigger, 1=damage, 2=heal
            functionWhitelist = {},
            description = "区域类型"
        },
        propname = {
            validValues = {"hpMax", "hpGen", "mpMax", "mpGen", "speed", "strength", "defense", "agility"},
            functionWhitelist = {},
            description = "物品属性名称"
        }
    },
    
    -- 数值范围配置 - 统一使用字符串格式
    -- 格式说明: "[min,max]" 闭区间, "(min,max)" 开区间, "[min,max)" 或 "(min,max]" 半开区间
    -- 无限大用空值表示: "[0,)" 表示 >= 0, "(0,)" 表示 > 0
    ranges = {
        speed = {
            range = "[0,720.0]",  -- 速度范围
            functionWhitelist = {},
            description = "速度"
        },
        angle = {
            range = "[-360,360]",    -- 角度范围 (0, 360]
            functionWhitelist = {},
            description = "角度"
        },
        radius = {
            range = "[0,)",       -- 半径必须 > 0
            functionWhitelist = {},
            description = "半径"
        },
        distance = {
            range = "[0,)",       -- 距离必须 > 0
            functionWhitelist = {},
            description = "距离"
        },
        range = {
            range = "[0,)",       -- 范围必须 > 0
            functionWhitelist = {},
            description = "范围"
        },
        -- damage = {
        --     range = "[0,)",       -- 伤害必须 > 0
        --     functionWhitelist = {},
        --     description = "伤害"
        -- },
        heal = {
            range = "[0,)",       -- 治疗必须 > 0
            functionWhitelist = {},
            description = "治疗"
        },
        duration = {
            range = "[0,)",       -- 持续时间必须 > 0
            functionWhitelist = {},
            description = "持续时间"
        },
        count = {
            range = "[0,)",       -- 数量必须 >= 0
            functionWhitelist = {},
            description = "数量"
        },
        amount = {
            range = "[0,)",       -- 数量必须 >= 0
            functionWhitelist = {},
            description = "数量"
        },
        value = {
            range = "[0,)",       -- 值必须 >= 0
            functionWhitelist = {"Item_AddProp"},  -- Item_AddProp允许负值（用于减少属性）
            description = "值"
        }
    },
    
    -- 非配置表检查的特殊值允许配置
    -- 注意：这不是完全跳过检查，而是允许特殊值（如空字符串、空table等）
    -- 基础类型检查（string vs number等）始终执行
    nonConfigChecks = {
        -- 控制使用白名单还是黑名单：'whitelist' 或 'blacklist'
        listType = "whitelist",  -- 默认使用白名单
        
        -- 各种检查类型的函数名单
        uuid = {
            functionList = {"NPC_", "LEVEL_ShowMsgBubble"},  -- 函数名列表
            description = "UUID验证"
        },
        npcTID = {
            functionList = {"LEVEL_ShowDialog"},
            description = "NPC模板ID验证"
        },
        skillTID = {
            functionList = {},
            description = "技能模板ID验证"
        },
        locatorID = {
            functionList = {},
            description = "定位器ID验证"
        },
        itemTID = {
            functionList = {"LEVEL_Award"},
            description = "物品模板ID验证"
        },
        position = {
            functionList = {},
            description = "位置验证"
        },
        direction = {
            functionList = {},
            description = "方向验证"
        },
        npcUUIDs = {
            functionList = {},
            description = "NPC UUID数组验证"
        },
    }
}

-- 配置表管理函数
local ConfigManager = {
    config = ValidationConfig
}

-- 获取调用函数名称
function ConfigManager:getCallerFunctionName()
    -- 优先从validateParam的调用者（apiName参数）获取函数名
    -- 这是最可靠的方法，因为validateParam直接被API函数调用
    local level = 1
    while level <= 15 do
        local info = debug.getinfo(level, "nSl")
        if not info then
            break
        end

        local source = info.source or ""
        -- 移除@前缀
        if source:sub(1, 1) == "@" then
            source = source:sub(2)
        end
        
        -- 如果是lua_check目录下的文件，检查函数名
        if source:match("lua_check/") then
            local funcName = info.name
            if funcName and (funcName:match("^LEVEL_") or funcName:match("^NPC_") or funcName:match("^Skill_") or funcName:match("^Item_")) then
                return funcName
            end
        end
        
        level = level + 1
    end
    
    -- 从traceback中解析API函数名
    local traceback = debug.traceback()
    for line in traceback:gmatch("[^\r\n]+") do
        -- 查找API函数名的多种模式
        local patterns = {
            "in function '(LEVEL_[^']+)'",
            "in function '(NPC_[^']+)'", 
            "in function '(Skill_[^']+)'",
            "in function '(Item_[^']+)'",
            "in function (LEVEL_[^%s%(]+)",
            "in function (NPC_[^%s%(]+)",
            "in function (Skill_[^%s%(]+)",
            "in function (Item_[^%s%(]+)",
            "([%w_]*LEVEL_[%w_]+)",
            "([%w_]*NPC_[%w_]+)", 
            "([%w_]*Skill_[%w_]+)",
            "([%w_]*Item_[%w_]+)"
        }
        
        for _, pattern in ipairs(patterns) do
            local func_match = line:match(pattern)
            if func_match then
                -- 清理函数名，去掉可能的前缀
                local cleanName = func_match:gsub("^.*%.", "")
                if cleanName:match("^LEVEL_") or cleanName:match("^NPC_") or cleanName:match("^Skill_") or cleanName:match("^Item_") then
                    return cleanName
                end
            end
        end
    end
    
    -- 如果还是找不到，返回通用的函数标识
    return "unknown"
end

-- 检查是否在白名单中
function ConfigManager:isInWhitelist(whitelist, functionName)
    if not functionName then
        return false
    end
    
    for _, whitelistFunc in ipairs(whitelist) do
        if functionName == whitelistFunc then
            return true
        end
    end
    return false
end

-- 添加枚举值
function ConfigManager:addEnumValue(enumKey, value)
    local enumConfig = self.config.enums[enumKey]
    if not enumConfig then
        print(string.format("❌ 枚举类型 '%s' 不存在", enumKey))
        return false
    end
    
    for _, existingValue in ipairs(enumConfig.validValues) do
        if existingValue == value then
            print(string.format("⚠️  值 '%s' 已存在于枚举 '%s' 中", tostring(value), enumKey))
            return false
        end
    end
    
    table.insert(enumConfig.validValues, value)
    print(string.format("✅ 成功添加值 '%s' 到枚举 '%s'", tostring(value), enumKey))
    return true
end

-- 添加函数到白名单
function ConfigManager:addToWhitelist(configType, configKey, functionName)
    local targetConfig = nil
    
    if configType == "enum" then
        targetConfig = self.config.enums[configKey]
    elseif configType == "range" then
        targetConfig = self.config.ranges[configKey]
    end
    
    if not targetConfig then
        print(string.format("❌ 配置项 '%s:%s' 不存在", configType, configKey or ""))
        return false
    end
    
    -- 检查是否已存在
    for _, existingFunc in ipairs(targetConfig.functionWhitelist) do
        if existingFunc == functionName then
            print(string.format("⚠️  函数 '%s' 已在白名单中", functionName))
            return false
        end
    end
    
    table.insert(targetConfig.functionWhitelist, functionName)
    print(string.format("✅ 成功添加函数 '%s' 到白名单 '%s:%s'", functionName, configType, configKey or ""))
    return true
end

-- 更新数值范围
function ConfigManager:updateRange(rangeKey, rangeStr)
    local rangeConfig = self.config.ranges[rangeKey]
    if not rangeConfig then
        print(string.format("❌ 范围配置 '%s' 不存在", rangeKey))
        return false
    end
    
    rangeConfig.range = rangeStr
    print(string.format("✅ 成功更新范围配置 '%s' 为 '%s'", rangeKey, rangeStr))
    return true
end

-- 设置非配置表检查的名单类型
function ConfigManager:setNonConfigCheckListType(listType)
    if listType ~= "whitelist" and listType ~= "blacklist" then
        print("❌ 错误：名单类型必须是 'whitelist' 或 'blacklist'")
        return false
    end
    
    self.config.nonConfigChecks.listType = listType
    print(string.format("✅ 成功设置非配置表检查名单类型为: %s", listType))
    return true
end

-- 获取当前非配置表检查的名单类型
function ConfigManager:getNonConfigCheckListType()
    return self.config.nonConfigChecks.listType
end

-- 添加函数到非配置表检查名单
function ConfigManager:addToNonConfigCheckList(checkType, functionName)
    local checkConfig = self.config.nonConfigChecks[checkType]
    if not checkConfig then
        print(string.format("❌ 非配置表检查类型 '%s' 不存在", checkType))
        return false
    end
    
    -- 检查是否已存在
    for _, existingFunc in ipairs(checkConfig.functionList) do
        if existingFunc == functionName then
            print(string.format("⚠️  函数 '%s' 已在 '%s' 名单中", functionName, checkType))
            return false
        end
    end
    
    table.insert(checkConfig.functionList, functionName)
    print(string.format("✅ 成功添加函数 '%s' 到非配置表检查名单 '%s'", functionName, checkType))
    return true
end

-- 从非配置表检查名单中移除函数
function ConfigManager:removeFromNonConfigCheckList(checkType, functionName)
    local checkConfig = self.config.nonConfigChecks[checkType]
    if not checkConfig then
        print(string.format("❌ 非配置表检查类型 '%s' 不存在", checkType))
        return false
    end
    
    for i, existingFunc in ipairs(checkConfig.functionList) do
        if existingFunc == functionName then
            table.remove(checkConfig.functionList, i)
            print(string.format("✅ 成功从非配置表检查名单 '%s' 中移除函数 '%s'", checkType, functionName))
            return true
        end
    end
    
    print(string.format("⚠️  函数 '%s' 不在 '%s' 名单中", functionName, checkType))
    return false
end

-- 检查函数是否应该允许特殊值（而不是完全跳过检查）
function ConfigManager:shouldAllowSpecialValues(checkType, functionName)
    if not functionName then
        return false
    end
    
    local checkConfig = self.config.nonConfigChecks[checkType]
    if not checkConfig then
        return false
    end
    
    local isInList = false
    for _, listFunc in ipairs(checkConfig.functionList) do
        if functionName:match(listFunc) then
            isInList = true
            break
        end
    end
    
    local listType = self.config.nonConfigChecks.listType
    
    if listType == "whitelist" then
        -- 白名单模式：在名单中则允许特殊值
        return isInList
    elseif listType == "blacklist" then
        -- 黑名单模式：不在名单中则允许特殊值
        return not isInList
    end
    
    return false
end

-- 兼容性：保留旧函数名但标记为废弃
function ConfigManager:shouldSkipNonConfigCheck(checkType, functionName)
    -- 为了兼容性暂时保留，但实际上调用新的函数
    return self:shouldAllowSpecialValues(checkType, functionName)
end

-- 获取非配置表检查的配置信息
function ConfigManager:getNonConfigCheckInfo(checkType)
    local checkConfig = self.config.nonConfigChecks[checkType]
    if not checkConfig then
        return nil
    end
    
    return {
        description = checkConfig.description,
        functionList = checkConfig.functionList,
        listType = self.config.nonConfigChecks.listType
    }
end

-- 打印非配置表检查配置概览
function ConfigManager:printNonConfigCheckOverview()
    local listType = self.config.nonConfigChecks.listType
    print(string.format("📋 非配置表检查配置概览 (当前模式: %s)", listType))
    print("=" .. string.rep("=", 50))
    
    for checkType, checkConfig in pairs(self.config.nonConfigChecks) do
        if checkType ~= "listType" then
            print(string.format("🔍 %s (%s):", checkConfig.description, checkType))
            if #checkConfig.functionList > 0 then
                for i, funcName in ipairs(checkConfig.functionList) do
                    print(string.format("  %d. %s", i, funcName))
                end
            else
                print("  (空)")
            end
            print()
        end
    end
end

-- 创建验证模块
local ValidationModule = {}

-- 错误收集器
local ErrorCollector = {}
ErrorCollector.errors = {}
ErrorCollector.errorSet = {}  -- 用于去重的集合
ErrorCollector.maxErrors = 100  -- 默认最大错误数量限制为100
ErrorCollector.maxErrorsReached = false  -- 标记是否已达到最大错误数量

-- 设置最大错误数量限制
function ErrorCollector:setMaxErrors(maxErrors)
    if type(maxErrors) == "number" and maxErrors > 0 then
        self.maxErrors = maxErrors
        print(string.format("📋 设置最大错误数量限制为: %d", maxErrors))
    else
        print("❌ 错误：最大错误数量限制必须是正数")
    end
end

-- 格式化错误信息，使其更清晰
local function formatErrorMessage(apiName, errorType, details)
    -- 首先清理details中的lua_check路径信息
    local cleaned_details = details:gsub("lua_check/main%.lua:%d+:%s*", "")
    
    -- 如果错误信息中包含文件路径和行号，直接使用
    if cleaned_details:match("%.lua:%d+:") then
        return cleaned_details
    end
    
    -- 直接使用传入的 apiName 作为函数名
    local function_info = apiName
    
    -- 获取调用堆栈信息以提取文件路径和行号
    local traceback = debug.traceback()
    local file_info = ""
    local line_number = ""
    
    -- 从堆栈中提取文件信息 - 跳过所有lua_check目录下的文件
    for line in traceback:gmatch("[^\r\n]+") do
        if line:match("%.lua:%d+:") and not line:match("lua_check/") then
            -- 提取文件路径和行号
            local path_match, line_match = line:match("([^%s]+%.lua):(%d+)")
            if path_match then
                file_info = path_match
                line_number = line_match
                break
            end
        end
    end
    
    -- 构建清晰的错误信息
    local formatted_message = cleaned_details
    if file_info and file_info ~= "" then
        if function_info and function_info ~= "" and function_info ~= "unknown" then
            formatted_message = string.format("%s:%s: %s [函数: %s]", file_info, line_number, cleaned_details, function_info)
        else
            formatted_message = string.format("%s:%s: %s", file_info, line_number, cleaned_details)
        end
    end
    
    return formatted_message
end

-- 记录错误
function ErrorCollector:recordError(apiName, errorType, details)
    -- 首先格式化错误信息
    local formatted_details = formatErrorMessage(apiName, errorType, details)
    
    -- 获取调用位置信息用于创建唯一的错误标识符
    local traceback = debug.traceback()
    local file_info = ""
    local line_number = ""
    
    -- 从堆栈中提取文件信息 - 跳过所有lua_check目录下的文件
    for line in traceback:gmatch("[^\r\n]+") do
        if line:match("%.lua:%d+:") and not line:match("lua_check/") then
            -- 提取文件路径和行号
            local path_match, line_match = line:match("([^%s]+%.lua):(%d+)")
            if path_match then
                file_info = path_match
                line_number = line_match
                break
            end
        end
    end
    
    -- 创建基于格式化后内容的唯一错误标识符（用于去重）
    -- 使用格式化后的错误信息确保去重的准确性
    local stableErrorKey = string.format("%s:%s:%s", 
        apiName or "UNKNOWN", 
        errorType or "UNKNOWN", 
        formatted_details or "")
    
    -- 如果已经记录过这个错误，直接返回
    if self.errorSet[stableErrorKey] then
        return
    end
    
    -- 检查是否超过最大错误数量限制
    if #self.errors >= self.maxErrors then
        if not self.maxErrorsReached then
            self.maxErrorsReached = true
            local maxErrorMsg = string.format("⚠️  已达到最大错误数量限制(%d)，停止记录更多错误", self.maxErrors)
            table.insert(self.errors, {
                api = "SYSTEM",
                type = "MAX_ERRORS_REACHED",
                details = maxErrorMsg,
                timestamp = os.time()
            })
            print(maxErrorMsg)
        end
        return
    end
    
    -- 标记已记录
    self.errorSet[stableErrorKey] = true
    
    table.insert(self.errors, {
        api = apiName,
        type = errorType,
        details = formatted_details,
        timestamp = os.time()
    })
    
end

-- 获取错误列表
function ErrorCollector:getErrors()
    return self.errors
end

-- 清空错误列表
function ErrorCollector:clearErrors()
    self.errors = {}
    self.errorSet = {}
    self.maxErrorsReached = false
end

-- 获取当前错误统计
function ErrorCollector:getErrorStats()
    return {
        current = #self.errors,
        max = self.maxErrors,
        maxReached = self.maxErrorsReached
    }
end

-- 范围解析器
local RangeParser = {}

-- 解析范围字符串
function RangeParser:parseRange(rangeStr)
    if not rangeStr or type(rangeStr) ~= "string" then
        return nil, "无效的范围字符串"
    end
    
    -- 匹配范围格式: [min,max], (min,max), [min,max), (min,max]
    -- 支持空值表示无限: [0,), (0,), [,100], (,100)
    local leftBracket, minStr, maxStr, rightBracket = rangeStr:match("^([%[%(])([^,]*),([^%]%)]*)([%]%)])$")
    
    if not leftBracket then
        return nil, "范围格式错误，应为: [min,max], (min,max), [min,max), (min,max), [min,), (min,) 等"
    end
    
    -- 解析最小值
    local minValue = nil
    local minInclusive = (leftBracket == "[")
    if minStr ~= "" then
        minValue = tonumber(minStr)
        if not minValue then
            return nil, "最小值必须是数字: " .. minStr
        end
    end
    
    -- 解析最大值
    local maxValue = nil
    local maxInclusive = (rightBracket == "]")
    if maxStr ~= "" then
        maxValue = tonumber(maxStr)
        if not maxValue then
            return nil, "最大值必须是数字: " .. maxStr
        end
    end
    
    -- 验证范围逻辑
    if minValue and maxValue and minValue > maxValue then
        return nil, "最小值不能大于最大值"
    end
    
    return {
        min = minValue,
        max = maxValue,
        minInclusive = minInclusive,
        maxInclusive = maxInclusive
    }, nil
end

-- 检查值是否在范围内
function RangeParser:isInRange(value, rangeConfig)
    if type(value) ~= "number" then
        return false, "值必须是数字"
    end
    
    local range, err = self:parseRange(rangeConfig.range)
    if not range then
        return false, err
    end
    
    -- 检查最小值
    if range.min then
        if range.minInclusive then
            if value < range.min then
                return false, string.format("值 %s 小于最小值 %s", tostring(value), tostring(range.min))
            end
        else
            if value <= range.min then
                return false, string.format("值 %s 不大于最小值 %s", tostring(value), tostring(range.min))
            end
        end
    end
    
    -- 检查最大值
    if range.max then
        if range.maxInclusive then
            if value > range.max then
                return false, string.format("值 %s 大于最大值 %s", tostring(value), tostring(range.max))
            end
        else
            if value >= range.max then
                return false, string.format("值 %s 不小于最大值 %s", tostring(value), tostring(range.max))
            end
        end
    end
    
    return true, nil
end

-- 格式化范围描述
function RangeParser:formatRange(rangeStr)
    local range, err = self:parseRange(rangeStr)
    if not range then
        return rangeStr
    end
    
    local leftSymbol = range.minInclusive and "[" or "("
    local rightSymbol = range.maxInclusive and "]" or ")"
    local minStr = range.min and tostring(range.min) or ""
    local maxStr = range.max and tostring(range.max) or ""
    
    return string.format("%s%s,%s%s", leftSymbol, minStr, maxStr, rightSymbol)
end

-- 任务配置专门验证函数
local function validateTaskConfig(taskConfig, apiName)
    if type(taskConfig) ~= "table" then
        ErrorCollector:recordError(apiName, "PARAM_TYPE_ERROR", "taskConfig必须是table类型")
        return false
    end
    
    local errors = {}
    
    -- 1. 验证id字段
    if not taskConfig.id then
        table.insert(errors, "taskConfig.id字段是必需的")
    elseif type(taskConfig.id) ~= "string" then
        table.insert(errors, "taskConfig.id必须是string类型")
    elseif taskConfig.id == "" then
        table.insert(errors, "taskConfig.id不能为空字符串")
    end
    
    -- 2. 验证desc字段
    if not taskConfig.desc then
        table.insert(errors, "taskConfig.desc字段是必需的")
    elseif type(taskConfig.desc) ~= "string" then
        table.insert(errors, "taskConfig.desc必须是string类型")
    elseif taskConfig.desc == "" then
        table.insert(errors, "taskConfig.desc不能为空字符串")
    end
    
    -- 3. 验证stageId字段
    if not taskConfig.stageId then
        table.insert(errors, "taskConfig.stageId字段是必需的")
    elseif type(taskConfig.stageId) ~= "number" then
        table.insert(errors, "taskConfig.stageId必须是number类型")
    elseif taskConfig.stageId <= 0 then
        table.insert(errors, "taskConfig.stageId必须大于0")
    end
    
    -- 4. 验证NpcUUID字段（可选）
    if taskConfig.NpcUUID ~= nil then
        if type(taskConfig.NpcUUID) ~= "string" then
            table.insert(errors, "taskConfig.NpcUUID必须是string类型")
        elseif taskConfig.NpcUUID ~= "" then
            -- 获取调用函数名称
            local callerFunctionName = ConfigManager:getCallerFunctionName()
            -- 非空字符串需要进行UUID验证（白名单只影响空字符串）
            local valid, err = validator:validateUUID(taskConfig.NpcUUID)
            if not valid then
                table.insert(errors, "taskConfig.NpcUUID无效: " .. err)
            end
        end
    end
    
    -- 5. 验证type字段
    local validTaskTypes = {"TaskType.KillMonster", "TaskType.None", "TaskType.MoveTo"}
    if not taskConfig.type then
        taskConfig.type = "TaskType.None"  -- 默认值
    elseif type(taskConfig.type) ~= "string" then
        table.insert(errors, "taskConfig.type必须是string类型")
    else
        local validType = false
        for _, validTaskType in ipairs(validTaskTypes) do
            if taskConfig.type == validTaskType then
                validType = true
                break
            end
        end
        if not validType then
            table.insert(errors, "taskConfig.type无效，必须是以下之一: " .. table.concat(validTaskTypes, ", "))
        end
    end
    
    -- 6. 验证param字段（根据type不同而不同）
    if not taskConfig.param then
        if taskConfig.type == "TaskType.None" then
            taskConfig.param = {}
        else
            table.insert(errors, "taskConfig.type为非TaskType.None时taskConfig.param字段是必需的")
        end
    elseif type(taskConfig.param) ~= "table" then
        table.insert(errors, "taskConfig.param必须是table类型")
    elseif taskConfig.type then
        if taskConfig.type == "TaskType.None" then
            -- TaskType.None: param应该是空table
            if next(taskConfig.param) ~= nil then
                table.insert(errors, "TaskType.None的param应该是空table")
            end
        elseif taskConfig.type == "TaskType.KillMonster" then
            -- TaskType.KillMonster: param = {NpcTID(string), count(int)}
            if #taskConfig.param ~= 2 then
                table.insert(errors, "TaskType.KillMonster的param应该包含2个元素: [NpcTID, count]")
            else
                if type(taskConfig.param[1]) ~= "string" then
                    table.insert(errors, "TaskType.KillMonster的param[1](NpcTID)必须是string类型")
                elseif taskConfig.param[1] == "" then
                    table.insert(errors, "TaskType.KillMonster的param[1](NpcTID)不能为空")
                else
                    -- 验证NpcTID（非空字符串需要验证）
                    local callerFunctionName = ConfigManager:getCallerFunctionName()
                    local valid, err = validator:validateNpcTID(taskConfig.param[1])
                    if not valid then
                        table.insert(errors, "TaskType.KillMonster的param[1](NpcTID)无效: " .. err)
                    end
                end
                
                if type(taskConfig.param[2]) ~= "number" then
                    table.insert(errors, "TaskType.KillMonster的param[2](count)必须是number类型")
                elseif taskConfig.param[2] <= 0 then
                    table.insert(errors, "TaskType.KillMonster的param[2](count)必须大于0")
                end
            end
        elseif taskConfig.type == "TaskType.MoveTo" then
            -- TaskType.MoveTo: param = {type(int), target(string)}
            if #taskConfig.param ~= 2 then
                table.insert(errors, "TaskType.MoveTo的param应该包含2个元素: [type, target]")
            else
                if type(taskConfig.param[1]) ~= "number" then
                    table.insert(errors, "TaskType.MoveTo的param[1](type)必须是number类型")
                elseif taskConfig.param[1] ~= 1 and taskConfig.param[1] ~= 2 then
                    table.insert(errors, "TaskType.MoveTo的param[1](type)必须是1(NPC)或2(坐标)")
                end
                
                if type(taskConfig.param[2]) ~= "string" then
                    table.insert(errors, "TaskType.MoveTo的param[2](target)必须是string类型")
                elseif taskConfig.param[2] == "" then
                    table.insert(errors, "TaskType.MoveTo的param[2](target)不能为空")
                else
                    -- 根据type验证target（非空字符串需要验证）
                    local callerFunctionName = ConfigManager:getCallerFunctionName()
                    if taskConfig.param[1] == 1 then
                        -- NPC类型，验证NpcUUID
                        local valid, err = validator:validateUUID(taskConfig.param[2])
                        if not valid then
                            table.insert(errors, "TaskType.MoveTo的param[2](NpcUUID)无效: " .. err)
                        end
                    elseif taskConfig.param[1] == 2 then
                        -- 坐标类型，验证LocatorID
                        local valid, err = validator:validateLocatorID(taskConfig.param[2])
                        if not valid then
                            table.insert(errors, "TaskType.MoveTo的param[2](LocatorID)无效: " .. err)
                        end
                    end
                end
            end
        end
    end
    
    -- 7. 验证reward字段（可选）
    if taskConfig.reward ~= nil then
        if type(taskConfig.reward) ~= "table" then
            table.insert(errors, "taskConfig.reward必须是table类型")
        elseif #taskConfig.reward ~= 2 then
            table.insert(errors, "taskConfig.reward应该包含2个元素: [ItemTID, count]")
        else
            if type(taskConfig.reward[1]) ~= "string" then
                table.insert(errors, "taskConfig.reward[1](ItemTID)必须是string类型")
            elseif taskConfig.reward[1] == "" then
                table.insert(errors, "taskConfig.reward[1](ItemTID)不能为空")
            else
                -- 验证ItemTID（非空字符串需要验证）
                local callerFunctionName = ConfigManager:getCallerFunctionName()
                local valid, err = validator:validateItemTID(taskConfig.reward[1])
                if not valid then
                    table.insert(errors, "taskConfig.reward[1](ItemTID)无效: " .. err)
                end
            end
            
            if type(taskConfig.reward[2]) ~= "number" then
                table.insert(errors, "taskConfig.reward[2](count)必须是number类型")
            elseif taskConfig.reward[2] <= 0 then
                table.insert(errors, "taskConfig.reward[2](count)必须大于0")
            end
        end
    end
    
    -- 8. 验证chatSpeed字段（可选）
    if taskConfig.chatSpeed ~= nil then
        if type(taskConfig.chatSpeed) ~= "number" then
            table.insert(errors, "taskConfig.chatSpeed必须是number类型")
        elseif taskConfig.chatSpeed < 0.02 or taskConfig.chatSpeed > 1.0 then
            table.insert(errors, "taskConfig.chatSpeed必须在[0.02, 1.0]范围内")
        end
    end
    
    -- 9. 验证autoChat字段（可选）
    if taskConfig.autoChat ~= nil and type(taskConfig.autoChat) ~= "boolean" then
        table.insert(errors, "taskConfig.autoChat必须是boolean类型")
    end
    
    -- 10. 验证preTask字段（可选）
    if taskConfig.preTask ~= nil then
        if type(taskConfig.preTask) ~= "table" then
            table.insert(errors, "taskConfig.preTask必须是table类型")
        else
            for i, preTaskId in ipairs(taskConfig.preTask) do
                if type(preTaskId) ~= "string" then
                    table.insert(errors, string.format("taskConfig.preTask[%d]必须是string类型", i))
                elseif preTaskId == "" then
                    table.insert(errors, string.format("taskConfig.preTask[%d]不能为空字符串", i))
                end
            end
        end
    end
    
    -- 11. 验证对话字段的辅助函数
    local function validateChatArray(chatArray, fieldName)
        if type(chatArray) ~= "table" then
            table.insert(errors, string.format("taskConfig.%s必须是table类型", fieldName))
            return
        end
        
        for i, chatItem in ipairs(chatArray) do
            if type(chatItem) ~= "table" then
                table.insert(errors, string.format("taskConfig.%s[%d]必须是table类型", fieldName, i))
            elseif #chatItem < 3 or #chatItem > 4 then
                table.insert(errors, string.format("taskConfig.%s[%d]应该包含3或4个元素: [speaker, content, emotion, speed?]", fieldName, i))
            else
                -- 验证说话人TID
                if type(chatItem[1]) ~= "string" then
                    table.insert(errors, string.format("taskConfig.%s[%d][1](speaker)必须是string类型", fieldName, i))
                elseif chatItem[1] ~= "" and chatItem[1] ~= "Player" and chatItem[1] ~= "player"  then
                    -- 验证NpcTID（除了Player，非空字符串需要验证）
                    local callerFunctionName = ConfigManager:getCallerFunctionName()
                    local valid, err = validator:validateNpcTID(chatItem[1])
                    if not valid then
                        table.insert(errors, string.format("taskConfig.%s[%d][1](speaker NpcTID)无效: %s", fieldName, i, err))
                    end
                end
                
                -- 验证说话内容
                if type(chatItem[2]) ~= "string" then
                    table.insert(errors, string.format("taskConfig.%s[%d][2](content)必须是string类型", fieldName, i))
                elseif chatItem[2] == "" then
                    table.insert(errors, string.format("taskConfig.%s[%d][2](content)不能为空", fieldName, i))
                end
                
                -- 验证情绪ID
                if type(chatItem[3]) ~= "string" then
                    table.insert(errors, string.format("taskConfig.%s[%d][3](emotion)必须是string类型", fieldName, i))
                else
                    local callerFunctionName = ConfigManager:getCallerFunctionName()
                    if not ConfigManager:isInWhitelist(ValidationConfig.enums.emotionid.functionWhitelist, callerFunctionName) then
                        local validEmotion = false
                        for _, validEmotionId in ipairs(ValidationConfig.enums.emotionid.validValues) do
                            if chatItem[3] == validEmotionId then
                                validEmotion = true
                                break
                            end
                        end
                        if not validEmotion then
                            table.insert(errors, string.format("taskConfig.%s[%d][3](emotion)无效，必须是以下之一: %s", 
                                fieldName, i, table.concat(ValidationConfig.enums.emotionid.validValues, ", ")))
                        end
                    end
                end
                
                -- 验证说话速度（可选）
                if #chatItem == 4 then
                    if type(chatItem[4]) ~= "number" then
                        table.insert(errors, string.format("taskConfig.%s[%d][4](speed)必须是number类型", fieldName, i))
                    elseif chatItem[4] < 0.5 or chatItem[4] > 2.0 then
                        table.insert(errors, string.format("taskConfig.%s[%d][4](speed)必须在[0.5, 2.0]范围内", fieldName, i))
                    end
                end
            end
        end
    end
    
    -- 验证各对话字段（均为可选）
    if taskConfig.preChat ~= nil then
        validateChatArray(taskConfig.preChat, "preChat")
    end
    
    if taskConfig.notFinishChat ~= nil then
        validateChatArray(taskConfig.notFinishChat, "notFinishChat")
    end
    
    if taskConfig.finishChat ~= nil then
        validateChatArray(taskConfig.finishChat, "finishChat")
    end
    
    -- 记录所有错误
    for _, error in ipairs(errors) do
        ErrorCollector:recordError(apiName, "TASK_CONFIG_ERROR", error)
    end
    
    return #errors == 0
end

-- NPC Prof配置专门验证函数
local function validateNpcProfConfig(npcConfig, apiName, filePath)
    -- player.lua例外 - 检查文件名或id字段
    if (filePath and filePath:match("player%.lua$")) or 
       (npcConfig and npcConfig.id == "player") then
        return true
    end
    local ok = true
    
    -- 获取文件路径用于错误报告
    local displayFilePath = filePath
    if displayFilePath and not displayFilePath:match("%.lua$") then
        displayFilePath = displayFilePath .. ".lua"
    end
    
    local function err(etype, msg)
        -- 构造包含文件路径的错误信息
        local errorMsg = msg
        if displayFilePath then
            -- 为配置错误添加通用行号1，这样IDE可以跳转到文件开头
            errorMsg = string.format("%s:1: %s", displayFilePath, msg)
        end
        ErrorCollector:recordError(apiName or "NPC_PROF", etype, errorMsg)
        ok = false
    end
    -- id
    if type(npcConfig.id) ~= "string" or npcConfig.id == "" then
        err("ID_ERROR", "id字段必须为非空字符串")
    end
    -- type
    local validTypes = {boss=true, junior=true, senior=true}
    if type(npcConfig.type) ~= "string" or not validTypes[npcConfig.type] then
        err("TYPE_ERROR", "type字段必须为boss、junior、senior之一")
    end
    -- prefab
    if type(npcConfig.prefab) ~= "string" then
        err("PREFAB_ERROR", "prefab字段必须为字符串")
    end
    -- avatar
    if type(npcConfig.avatar) ~= "string" then
        err("AVATAR_ERROR", "avatar字段必须为字符串")
    end
    -- prop
    if type(npcConfig.prop) ~= "table" then
        err("PROP_ERROR", "prop字段必须为table")
    else
        local prop = npcConfig.prop
        local propFields = {
            hpMax = "number", hpGen = "number", mpMax = "number", mpGen = "number",
            speed = "number", strength = "number", defense = "number", agility = "number"
        }
        for k, t in pairs(propFields) do
            if type(prop[k]) ~= t then
                err("PROP_FIELD_ERROR", string.format("prop.%s字段必须为%s", k, t))
            end
        end
        -- exp字段可选，不校验
    end
    -- faction
    local validFactions = {
        faction_player=true, faction_neutral_npc=true, faction_npc=true, faction_friend_npc=true
    }
    if type(npcConfig.faction) ~= "string" or not validFactions[npcConfig.faction] then
        err("FACTION_ERROR", "faction字段必须为faction_player、faction_neutral_npc、faction_npc、faction_friend_npc之一")
    end
    -- aiRoot
    if type(npcConfig.aiRoot) ~= "string" then
        err("AIROOT_ERROR", "aiRoot字段必须为字符串")
    end
    -- hatredRange
    if npcConfig.hatredRange ~= nil then
        if type(npcConfig.hatredRange) ~= "number" then
            err("HATREDRANGE_ERROR", "hatredRange字段必须为数字")
        end
        -- 允许为0
    end
    -- canCastSkill
    if type(npcConfig.canCastSkill) ~= "boolean" then
        err("CANCASTSKILL_ERROR", "canCastSkill字段必须为布尔值")
    end
    -- drops
    if npcConfig.drops ~= nil then
        if type(npcConfig.drops) ~= "table" then
            err("DROPS_ERROR", "drops字段必须为table数组")
        elseif #npcConfig.drops > 0 then
            for i, drop in ipairs(npcConfig.drops) do
                if type(drop) ~= "table" then
                    err("DROPS_ITEM_ERROR", string.format("drops[%d]必须为table", i))
                else
                    if type(drop.itemTID) ~= "string" then
                        err("DROPS_ITEMTID_ERROR", string.format("drops[%d].itemTID必须为字符串", i))
                    else
                        -- 校验物品是否存在
                        local isValid, errorMsg = validator:validateItemTID(drop.itemTID)
                        if not isValid then
                            err("DROPS_ITEMTID_REFERENCE_ERROR", string.format("drops[%d]: %s", i, errorMsg))
                        end
                    end
                    if type(drop.probability) ~= "number" or drop.probability < 0 or drop.probability > 100 then
                        err("DROPS_PROBABILITY_ERROR", string.format("drops[%d].probability必须为0-100的数字", i))
                    end
                    if type(drop.itemCount) ~= "number" or drop.itemCount < 1 then
                        err("DROPS_ITEMCOUNT_ERROR", string.format("drops[%d].itemCount必须为大于等于1的数字", i))
                    end
                end
            end
        end
    end
    -- canBeAttack
    if type(npcConfig.canBeAttack) ~= "boolean" then
        err("CANBEATTACK_ERROR", "canBeAttack字段必须为布尔值")
    end
    return ok
end

-- 全局检测模式标志
local isInValidationMode = false

-- 设置验证模式
local function setValidationMode(mode)
    isInValidationMode = mode
end

-- 加载函数签名提取器用于运行时参数个数验证
local FunctionSignatureExtractor = require("lua_check.function_signature_extractor")
local runtimeSignatureExtractor = FunctionSignatureExtractor:new()
runtimeSignatureExtractor:extractFromFiles()

-- 参数位置跟踪器
local ParameterTracker = {}
ParameterTracker.functionCalls = {}  -- 跟踪每个函数调用的参数位置

-- 重置参数跟踪器（用于新的函数调用）
function ParameterTracker:reset(apiName)
    self.functionCalls[apiName] = {
        parameterIndex = 0,
        parameters = {}
    }
end

-- 获取下一个参数位置
function ParameterTracker:getNextParameterIndex(apiName)
    if not self.functionCalls[apiName] then
        self:reset(apiName)
    end
    
    self.functionCalls[apiName].parameterIndex = self.functionCalls[apiName].parameterIndex + 1
    return self.functionCalls[apiName].parameterIndex
end

-- 记录参数信息
function ParameterTracker:recordParameter(apiName, paramIndex, paramName, value, expectedType)
    if not self.functionCalls[apiName] then
        self:reset(apiName)
    end
    
    self.functionCalls[apiName].parameters[paramIndex] = {
        name = paramName,
        value = value,
        expectedType = expectedType,
        actualType = type(value)
    }
end

-- 获取参数信息用于错误报告
function ParameterTracker:getParameterInfo(apiName, paramName)
    if not self.functionCalls[apiName] then
        return nil
    end
    
    for index, paramInfo in pairs(self.functionCalls[apiName].parameters) do
        if paramInfo.name == paramName then
            return index, paramInfo
        end
    end
    
    return nil, nil
end

-- 创建详细的错误消息
local function createDetailedErrorMessage(apiName, paramName, value, expectedType, errorType, originalError)
    local paramIndex, paramInfo = ParameterTracker:getParameterInfo(apiName, paramName)
    
    local baseMessage = ""
    
    -- 构建参数位置信息
    if paramIndex then
        baseMessage = string.format("第%d个参数 %s", paramIndex, paramName)
    else
        baseMessage = string.format("参数 %s", paramName)
    end
    
    -- 根据错误类型构建详细信息
    if errorType == "PARAM_TYPE_ERROR" then
        baseMessage = string.format("%s 类型错误: 期望 %s, 实际 %s", 
            baseMessage, expectedType, type(value))
        
        -- 添加值信息（安全处理）
        local valueStr = tostring(value)
        if type(value) == "string" and #valueStr > 50 then
            valueStr = string.sub(valueStr, 1, 47) .. "..."
        end
        baseMessage = baseMessage .. string.format(" (实际值: %s)", valueStr)
        
    elseif errorType == "RESOURCE_NOT_FOUND" then
        local valueStr = tostring(value)
        if type(value) == "string" and #valueStr > 50 then
            valueStr = string.sub(valueStr, 1, 47) .. "..."
        end
        baseMessage = string.format("%s 无效: %s (实际值: \"%s\")", 
            baseMessage, originalError, valueStr)
            
    elseif errorType == "PARAM_VALUE_ERROR" then
        local valueStr = tostring(value)
        if type(value) == "string" and #valueStr > 50 then
            valueStr = string.sub(valueStr, 1, 47) .. "..."
        end
        baseMessage = string.format("%s 值错误: %s (实际值: %s)", 
            baseMessage, originalError, valueStr)
            
    elseif errorType == "INVALID_NPC_UUID" or errorType == "INVALID_POSITION" or errorType == "INVALID_DIRECTION" then
        local valueStr = tostring(value)
        if type(value) == "table" then
            valueStr = "table{...}"
        elseif type(value) == "string" and #valueStr > 50 then
            valueStr = string.sub(valueStr, 1, 47) .. "..."
        end
        baseMessage = string.format("%s 格式无效: %s (实际值: %s)", 
            baseMessage, originalError, valueStr)
    else
        -- 通用错误格式
        baseMessage = string.format("%s 错误: %s", baseMessage, originalError)
    end
    
    return baseMessage
end

-- 运行时参数个数验证函数（已禁用，使用静态函数调用检查器代替）
local function validateRuntimeParameterCount(apiName)
    -- 运行时参数个数检查已被禁用，因为：
    -- 1. 静态函数调用检查器已经提供了准确的参数个数验证
    -- 2. 运行时检查的调用栈分析方法容易出错
    -- 3. 避免重复的错误报告
    return true
end

-- 参数验证辅助函数 - 增强版，包含详细错误信息
local function validateParam(paramName, value, expectedType, apiName)
    -- 检查是否是函数调用结束标记：validateParam("", nil, "", apiName)
    if paramName == "" and value == nil and expectedType == "" and apiName then
        -- 这是函数调用结束的标记，执行运行时参数个数检查
        return validateRuntimeParameterCount(apiName)
    end
    
    -- 获取参数位置信息
    local paramIndex = ParameterTracker:getNextParameterIndex(apiName)
    ParameterTracker:recordParameter(apiName, paramIndex, paramName, value, expectedType)
    
    -- 注意：参数个数验证在静态分析阶段(function_call_checker)和运行时检查中都会进行
    
    -- 基础类型验证
    if type(value) ~= expectedType then
        local functionDisplay = apiName or "unknown"
        
        -- 创建详细的错误消息
        local detailedMessage = createDetailedErrorMessage(apiName, paramName, value, expectedType, "PARAM_TYPE_ERROR", "")
        
        ErrorCollector:recordError(apiName, "PARAM_TYPE_ERROR", detailedMessage)
        
        -- 在验证模式下，不抛出异常，继续执行
        if not isInValidationMode then
            -- 使用统一格式，与函数调用检查器保持一致
            smartError(string.format("%s [函数: %s]", detailedMessage, functionDisplay))
        end
        -- 在验证模式下，返回false表示验证失败，但不中止执行
        return false
    end
    
    -- 获取调用函数名称用于白名单/黑名单检查
    -- 优先使用传入的apiName，如果没有则从调用栈获取
    local callerFunctionName = apiName or ConfigManager:getCallerFunctionName()
    
    -- 根据参数名进行特定验证
    if expectedType == "string" then
        -- UUID相关验证
        if paramName:lower():match("uuid") or paramName:lower():match("npcuuid") then
            -- 检查是否为空字符串且允许特殊值
            if value == "" and ConfigManager:shouldAllowSpecialValues("uuid", callerFunctionName) then
                return true -- 白名单中的函数允许空字符串
            end
            
            local valid, err = validator:validateUUID(value)
            if not valid then
                local detailedMessage = createDetailedErrorMessage(apiName, paramName, value, expectedType, "INVALID_NPC_UUID", err)
                ErrorCollector:recordError(apiName, "INVALID_NPC_UUID", detailedMessage)
                return false
            end
        
        -- 资源ID相关验证
        elseif paramName:lower():match("npctid") then
            -- 检查是否为空字符串且允许特殊值
            if value == "" and ConfigManager:shouldAllowSpecialValues("npcTID", callerFunctionName) then
                return true -- 白名单中的函数允许空字符串（表示自身）
            end
            
            local valid, err = validator:validateNpcTID(value)
            if not valid then
                local detailedMessage = createDetailedErrorMessage(apiName, paramName, value, expectedType, "RESOURCE_NOT_FOUND", err)
                ErrorCollector:recordError(apiName, "RESOURCE_NOT_FOUND", detailedMessage)
                return false
            end
        
        elseif paramName:lower():match("skilltid") then
            -- 检查是否为空字符串且允许特殊值
            if value == "" and ConfigManager:shouldAllowSpecialValues("skillTID", callerFunctionName) then
                return true -- 白名单中的函数允许空字符串（表示自身）
            end
            
            local valid, err = validator:validateSkillTID(value)
            if not valid then
                local detailedMessage = createDetailedErrorMessage(apiName, paramName, value, expectedType, "RESOURCE_NOT_FOUND", err)
                ErrorCollector:recordError(apiName, "RESOURCE_NOT_FOUND", detailedMessage)
                return false
            end
        
        elseif paramName:lower():match("locatorid") then
            -- 检查是否为空字符串且允许特殊值
            if value == "" and ConfigManager:shouldAllowSpecialValues("locatorID", callerFunctionName) then
                return true -- 白名单中的函数允许空字符串（表示自身）
            end
            
            local valid, err = validator:validateLocatorID(value)
            if not valid then
                local detailedMessage = createDetailedErrorMessage(apiName, paramName, value, expectedType, "RESOURCE_NOT_FOUND", err)
                ErrorCollector:recordError(apiName, "RESOURCE_NOT_FOUND", detailedMessage)
                return false
            end
        
        elseif paramName:lower():match("itemtid") then
            -- 检查是否为空字符串且允许特殊值
            if value == "" and ConfigManager:shouldAllowSpecialValues("itemTID", callerFunctionName) then
                return true -- 白名单中的函数允许空字符串（表示自身）
            end
            
            local valid, err = validator:validateItemTID(value)
            if not valid then
                local detailedMessage = createDetailedErrorMessage(apiName, paramName, value, expectedType, "RESOURCE_NOT_FOUND", err)
                ErrorCollector:recordError(apiName, "RESOURCE_NOT_FOUND", detailedMessage)
                return false
            end
        
        -- 枚举类型验证（使用配置表）
        else
            -- 检查是否匹配枚举类型参数
            for enumKey, enumConfig in pairs(ValidationConfig.enums) do
                if paramName:lower():match(enumKey) then
                    -- 检查是否为空字符串且在白名单中
                    if value == "" and ConfigManager:isInWhitelist(enumConfig.functionWhitelist, callerFunctionName) then
                        return true -- 白名单中的函数允许空字符串
                    end
                    
                    -- 验证枚举值
                    local validValue = false
                    for _, validEnum in ipairs(enumConfig.validValues) do
                        if value == validEnum then
                            validValue = true
                            break
                        end
                    end
                    if not validValue then
                        local validValuesStr = table.concat(enumConfig.validValues, ", ")
                        local errorDetail = string.format("无效的%s，有效值: [%s]", enumConfig.description, validValuesStr)
                        local detailedMessage = createDetailedErrorMessage(apiName, paramName, value, expectedType, "PARAM_VALUE_ERROR", errorDetail)
                        ErrorCollector:recordError(apiName, "PARAM_VALUE_ERROR", detailedMessage)
                        return false
                    end
                    return true
                end
            end
        end
    
    elseif expectedType == "number" then
        -- 检查枚举类型（数值）
        for enumKey, enumConfig in pairs(ValidationConfig.enums) do
            if paramName:lower():match(enumKey) then
                -- 对于数值枚举，白名单暂时不允许特殊值，因为0可能是有效枚举值
                -- 如果需要允许特殊数值，可以在这里添加逻辑
                
                -- 验证枚举值
                local validValue = false
                for _, validEnum in ipairs(enumConfig.validValues) do
                    if value == validEnum then
                        validValue = true
                        break
                    end
                end
                if not validValue then
                    local validValuesStr = table.concat(enumConfig.validValues, ", ")
                    local errorDetail = string.format("无效的%s，有效值: [%s]", enumConfig.description, validValuesStr)
                    local detailedMessage = createDetailedErrorMessage(apiName, paramName, value, expectedType, "PARAM_VALUE_ERROR", errorDetail)
                    ErrorCollector:recordError(apiName, "PARAM_VALUE_ERROR", detailedMessage)
                    return false
                end
                return true
            end
        end
        
        -- 检查数值范围
        for rangeKey, rangeConfig in pairs(ValidationConfig.ranges) do
            if paramName:lower():match(rangeKey) then
                -- 检查是否在白名单中
                if ConfigManager:isInWhitelist(rangeConfig.functionWhitelist, callerFunctionName) then
                        return true -- 白名单中的函数允许特殊值
                end
                
                -- 使用新的范围解析器验证
                local inRange, err = RangeParser:isInRange(value, rangeConfig)
                if not inRange then
                    local errorDetail = string.format("%s超出范围%s: %s", 
                        rangeConfig.description, rangeConfig.range, err)
                    local detailedMessage = createDetailedErrorMessage(apiName, paramName, value, expectedType, "PARAM_VALUE_ERROR", errorDetail)
                    ErrorCollector:recordError(apiName, "PARAM_VALUE_ERROR", detailedMessage)
                    return false
                end
                return true
            end
        end
    
    elseif expectedType == "function" then
        -- 函数类型验证：主动执行函数以检查其内部的函数调用
        
        -- 获取函数信息
        local functionInfo = debug.getinfo(value, "u")
        local paramCount = functionInfo.nparams or 0
        
        -- 构造函数参数的默认值
        local function constructDefaultArg(index)
            -- 根据参数位置构造合理的默认值
            -- 这里可以根据具体的API模式来构造更智能的默认值
            if index == 1 then
                return "default_uuid_" .. index  -- 第一个参数通常是UUID
            elseif index == 2 then
                return 1  -- 第二个参数通常是数值
            elseif index == 3 then
                return true  -- 第三个参数通常是布尔值
            else
                return nil  -- 其他参数默认为nil
            end
        end
        
        -- 准备参数数组
        local args = {}
        for i = 1, paramCount do
            args[i] = constructDefaultArg(i)
        end
        
        -- 安全执行函数
        local success, result = pcall(function()
            if paramCount == 0 then
                return value()  -- 无参数函数
            else
                return value(table.unpack(args))  -- 有参数函数
            end
        end)
        
        if success then
            -- print(string.format("✅ 函数 %s 执行成功，已检查内部调用", paramName))
        else
            -- 记录函数执行错误，但不阻止验证过程
            print(string.format("⚠️  函数 %s 执行出错: %s", paramName, tostring(result)))
            local detailedMessage = createDetailedErrorMessage(apiName, paramName, value, expectedType, "FUNCTION_EXECUTION_ERROR", 
                string.format("函数执行失败: %s", tostring(result)))
            ErrorCollector:recordError(apiName, "FUNCTION_EXECUTION_ERROR", detailedMessage)
        end
        
        return true
    
    elseif expectedType == "table" then
        -- 位置验证
        if paramName:lower():match("pos") or paramName:lower():match("position") then
            -- 检查是否为空table且允许特殊值
            if next(value) == nil and ConfigManager:shouldAllowSpecialValues("position", callerFunctionName) then
                return true -- 白名单中的函数允许空table
            end
            
            local valid, err = validator:validatePosition(value)
            if not valid then
                local detailedMessage = createDetailedErrorMessage(apiName, paramName, value, expectedType, "INVALID_POSITION", err)
                ErrorCollector:recordError(apiName, "INVALID_POSITION", detailedMessage)
                return false
            end
        
        -- 方向验证
        elseif paramName:lower():match("dir") or paramName:lower():match("direction") then
            -- 检查是否为空table且允许特殊值
            if next(value) == nil and ConfigManager:shouldAllowSpecialValues("direction", callerFunctionName) then
                return true -- 白名单中的函数允许空table
            end
            
            local valid, err = validator:validateDirection(value)
            if not valid then
                local detailedMessage = createDetailedErrorMessage(apiName, paramName, value, expectedType, "INVALID_DIRECTION", err)
                ErrorCollector:recordError(apiName, "INVALID_DIRECTION", detailedMessage)
                return false
            end
        
        -- NPC UUID数组验证
        elseif paramName:lower():match("npcuuids") or paramName:lower():match("uuids") then
            -- 检查是否为空table且允许特殊值
            if (value == nil or #value == 0)and ConfigManager:shouldAllowSpecialValues("npcUUIDs", callerFunctionName) then
                return true -- 白名单中的函数允许空数组
            end
            
            for i, npcUUID in ipairs(value) do
                if type(npcUUID) ~= "string" then
                    local arrayParamName = string.format("%s[%d]", paramName, i)
                    local detailedMessage = createDetailedErrorMessage(apiName, arrayParamName, npcUUID, "string", "PARAM_TYPE_ERROR", "")
                    ErrorCollector:recordError(apiName, "PARAM_TYPE_ERROR", detailedMessage)
                else
                    -- 递归验证每个UUID
                    validateParam(string.format("%s[%d]", paramName, i), npcUUID, "string", apiName)
                end
            end
        
        -- 任务配置验证
        elseif paramName:lower():match("taskconfig") then
            -- 使用专门的任务配置验证函数
            return validateTaskConfig(value, apiName)
        end
    end
    
    return true
end

-- 导出验证模块的公共接口
ValidationModule.ErrorCollector = ErrorCollector
ValidationModule.validateParam = validateParam
ValidationModule.ConfigManager = ConfigManager
ValidationModule.ValidationConfig = ValidationConfig
ValidationModule.RangeParser = RangeParser
ValidationModule.setValidationMode = setValidationMode

-- 便捷方法导出 - 方便外部直接调用
ValidationModule.setNonConfigCheckListType = function(listType)
    return ConfigManager:setNonConfigCheckListType(listType)
end

ValidationModule.getNonConfigCheckListType = function()
    return ConfigManager:getNonConfigCheckListType()
end

ValidationModule.addToNonConfigCheckList = function(checkType, functionName)
    return ConfigManager:addToNonConfigCheckList(checkType, functionName)
end

ValidationModule.removeFromNonConfigCheckList = function(checkType, functionName)
    return ConfigManager:removeFromNonConfigCheckList(checkType, functionName)
end

-- 新的方法名称，更准确地表达功能
ValidationModule.shouldAllowSpecialValues = function(checkType, functionName)
    return ConfigManager:shouldAllowSpecialValues(checkType, functionName)
end

-- 兼容性：保留旧方法名但标记为废弃
ValidationModule.shouldSkipNonConfigCheck = function(checkType, functionName)
    return ConfigManager:shouldSkipNonConfigCheck(checkType, functionName)
end

ValidationModule.getNonConfigCheckInfo = function(checkType)
    return ConfigManager:getNonConfigCheckInfo(checkType)
end

ValidationModule.printNonConfigCheckOverview = function()
    return ConfigManager:printNonConfigCheckOverview()
end

-- 其他便捷方法
ValidationModule.addEnumValue = function(enumKey, value)
    return ConfigManager:addEnumValue(enumKey, value)
end

ValidationModule.addToWhitelist = function(configType, configKey, functionName)
    return ConfigManager:addToWhitelist(configType, configKey, functionName)
end

ValidationModule.updateRange = function(rangeKey, rangeStr)
    return ConfigManager:updateRange(rangeKey, rangeStr)
end

ValidationModule.setMaxErrors = function(maxErrors)
    return ErrorCollector:setMaxErrors(maxErrors)
end

ValidationModule.getErrors = function()
    return ErrorCollector:getErrors()
end

ValidationModule.clearErrors = function()
    return ErrorCollector:clearErrors()
end

ValidationModule.getErrorStats = function()
    return ErrorCollector:getErrorStats()
end

-- 导出模块
return {
    validateParam = validateParam,
    configManager = ConfigManager,
    smartError = smartError,
    ErrorCollector = ErrorCollector,
    setValidationMode = setValidationMode,
    validateNpcProfConfig = validateNpcProfConfig
} 