-- 函数调用检查器 - 主动检查 Lua 文件中的函数调用及其参数
local FunctionCallChecker = {}

-- 加载验证模块
local ValidationModule = require("lua_check.validation")

-- 加载函数签名提取器
local FunctionSignatureExtractor = require("lua_check.function_signature_extractor")

-- 创建检查器实例
function FunctionCallChecker:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    
    -- 初始化签名提取器
    o.signatureExtractor = FunctionSignatureExtractor:new()
    o.signatureExtractor:extractFromFiles()
    
    -- 只保留需要特殊验证的函数（复杂参数验证）
    o.functionRules = {
        ["LEVEL_AddTask"] = {
            paramIndex = 1,  -- taskConfig 参数在第1个位置
            validator = "validateTaskConfig",
            description = "关卡任务配置"
        }
    }
    
    -- 目录-API映射
    o.directoryApiMap = {
        ["GenRPG/Item/"] = {"Item_"},
        ["GenRPG/Level/"] = {"LEVEL_"},
        ["GenRPG/Skill/"] = {"Skill_"},
        ["GenRPG/NPC/"] = {"NPC_"},
        ["GenRPG/Prof/"] = {"NPC_"}
    }
    
    return o
end

-- 解析 Lua 文件中的函数调用（增强版，支持多行）
function FunctionCallChecker:parseFile(filePath)
    local file = io.open(filePath, "r")
    if not file then
        return false, "无法打开文件: " .. filePath
    end
    
    local content = file:read("*all")
    file:close()
    
    local results = {}
    
    -- 使用更强大的多行解析
    local functionCalls = self:extractMultiLineFunctionCalls(content)
    for _, call in ipairs(functionCalls) do
        table.insert(results, call)
    end
    
    return true, results
end

-- 检查函数调用是否被注释掉了
function FunctionCallChecker:isFunctionCallCommented(line, matchStart)
    -- 检查函数调用之前是否有注释符号 --
    local beforeMatch = string.sub(line, 1, matchStart - 1)
    
    -- 查找注释符号的位置
    local commentPos = string.find(beforeMatch, "%-%-")
    
    -- 如果找到了注释符号，说明函数调用在注释中
    if commentPos then
        return true
    end
    
    return false
end

-- 提取多行函数调用
function FunctionCallChecker:extractMultiLineFunctionCalls(content)
    local calls = {}
    
    -- 按行分割内容，同时保留行号信息
    local lines = {}
    
    -- 使用更准确的行分割方法
    local lineNumber = 0
    for line in (content .. "\n"):gmatch("([^\r\n]*)\r?\n") do
        lineNumber = lineNumber + 1
        table.insert(lines, {text = line, number = lineNumber})
    end
    
    -- 获取所有API函数名
    local allApiFunctions = self.signatureExtractor:getAllAPIFunctions()
    
    -- 检查所有API函数调用
    for _, funcName in ipairs(allApiFunctions) do
        local pattern = funcName .. "%s*%("
        
        for i, lineInfo in ipairs(lines) do
            local line = lineInfo.text
            local startPos = 1
            
            while true do
                local matchStart, matchEnd = string.find(line, pattern, startPos)
                if not matchStart then
                    break
                end
                
                -- 检查函数调用是否被注释掉了
                if not self:isFunctionCallCommented(line, matchStart) then
                    -- 尝试提取完整的多行函数调用
                    local callInfo = self:extractMultiLineCall(lines, i, matchStart, funcName)
                    if callInfo then
                        table.insert(calls, callInfo)
                    end
                end
                
                startPos = matchEnd + 1
            end
        end
    end
    
    return calls
end

-- 提取多行函数调用（包括参数）
function FunctionCallChecker:extractMultiLineCall(lines, startLineIndex, startPos, funcName)
    local startLine = lines[startLineIndex]
    
    -- 找到函数名后的括号
    local openParen = string.find(startLine.text, "%(", startPos)
    if not openParen then
        return nil
    end
    
    -- 收集完整的函数调用内容
    local callContent = string.sub(startLine.text, startPos)
    local parenCount = 0
    local braceCount = 0
    local inString = false
    local stringChar = nil
    local callComplete = false
    local endLineIndex = startLineIndex
    
    -- 分析第一行
    for i = openParen, #startLine.text do
        local char = string.sub(startLine.text, i, i)
        
        if not inString then
            if char == '"' or char == "'" then
                inString = true
                stringChar = char
            elseif char == '(' then
                parenCount = parenCount + 1
            elseif char == ')' then
                parenCount = parenCount - 1
                if parenCount == 0 then
                    callComplete = true
                    break
                end
            elseif char == '{' then
                braceCount = braceCount + 1
            elseif char == '}' then
                braceCount = braceCount - 1
            end
        else
            if char == stringChar then
                inString = false
                stringChar = nil
            end
        end
    end
    
    -- 如果函数调用跨越多行，继续收集
    if not callComplete and startLineIndex < #lines then
        for lineIndex = startLineIndex + 1, #lines do
            local currentLine = lines[lineIndex]
            callContent = callContent .. "\n" .. currentLine.text
            endLineIndex = lineIndex
            
            for i = 1, #currentLine.text do
                local char = string.sub(currentLine.text, i, i)
                
                if not inString then
                    if char == '"' or char == "'" then
                        inString = true
                        stringChar = char
                    elseif char == '(' then
                        parenCount = parenCount + 1
                    elseif char == ')' then
                        parenCount = parenCount - 1
                        if parenCount == 0 then
                            callComplete = true
                            -- 截取到结束括号为止
                            callContent = callContent:sub(1, -(#currentLine.text - i + 1)) .. string.sub(currentLine.text, 1, i)
                            break
                        end
                    elseif char == '{' then
                        braceCount = braceCount + 1
                    elseif char == '}' then
                        braceCount = braceCount - 1
                    end
                else
                    if char == stringChar then
                        inString = false
                        stringChar = nil
                    end
                end
            end
            
            if callComplete then
                break
            end
        end
    end
    
    if not callComplete then
        return nil  -- 无法找到完整的函数调用
    end
    
    -- 提取参数部分 - 修复：正确找到匹配的括号对
    local openIndex = string.find(callContent, "%(")
    if not openIndex then
        return nil
    end
    
    -- 从开始括号位置向后找到匹配的结束括号
    local parenCount = 0
    local closeIndex = nil
    local inString = false
    local stringChar = nil
    
    for i = openIndex, #callContent do
        local char = string.sub(callContent, i, i)
        
        if not inString then
            if char == '"' or char == "'" then
                inString = true
                stringChar = char
            elseif char == '(' then
                parenCount = parenCount + 1
            elseif char == ')' then
                parenCount = parenCount - 1
                if parenCount == 0 then
                    closeIndex = i
                    break
                end
            end
        else
            if char == stringChar and (i == 1 or string.sub(callContent, i-1, i-1) ~= '\\') then
                inString = false
                stringChar = nil
            end
        end
    end
    
    if not closeIndex then
        return nil
    end
    
    local paramStr = string.sub(callContent, openIndex + 1, closeIndex - 1)
    
    return {
        functionName = funcName,
        startLine = startLine.number,
        endLine = endLineIndex,
        paramString = paramStr,
        fullCall = callContent,
        rule = self.functionRules[funcName]  -- 可能为nil，表示使用通用检查
    }
end

-- 增强的 taskConfig 解析器
function FunctionCallChecker:parseTaskConfig(paramStr)
    -- 去掉首尾空白
    paramStr = paramStr:gsub("^%s*", ""):gsub("%s*$", "")
    
    -- 检查是否以 { 开头
    if not paramStr:match("^%s*{") then
        return nil
    end
    
    local taskConfig = {}
    
    -- 提取字段值的增强函数
    local function extractValue(content, key)
        -- 匹配字符串值
        local strPattern = key .. "%s*=%s*[\"']([^\"']*)[\"']"
        local strMatch = content:match(strPattern)
        if strMatch then
            return strMatch
        end
        
        -- 匹配数值
        local numPattern = key .. "%s*=%s*([%d%.%-]+)"
        local numMatch = content:match(numPattern)
        if numMatch then
            return tonumber(numMatch)
        end
        
        -- 匹配布尔值
        local boolPattern = key .. "%s*=%s*(true|false)"
        local boolMatch = content:match(boolPattern)
        if boolMatch then
            return boolMatch == "true"
        end
        
        -- 匹配枚举值（不带引号）
        local enumPattern = key .. "%s*=%s*([%w%.]+)"
        local enumMatch = content:match(enumPattern)
        if enumMatch and not tonumber(enumMatch) then
            return enumMatch
        end
        
        return nil
    end
    
    -- 提取param字段（数组格式）
    local function extractParam(content)
        -- 匹配 param = { ... } 格式
        local paramPattern = "param%s*=%s*{%s*[\"']([^\"']*)[\"']%s*,%s*([%d%.%-]+)%s*}"
        local npcTID, count = content:match(paramPattern)
        if npcTID and count then
            return {npcTID, tonumber(count)}
        end
        return nil
    end
    
    -- 检查字段是否被注释掉
    local function isFieldCommented(content, key)
        -- 查找字段定义行
        local lines = {}
        for line in content:gmatch("[^\r\n]+") do
            table.insert(lines, line)
        end
        
        for _, line in ipairs(lines) do
            -- 匹配被注释的字段
            local commentedPattern = "^%s*%-%-%s*" .. key .. "%s*="
            if line:match(commentedPattern) then
                return true
            end
        end
        
        return false
    end
    
    -- 提取各个字段
    taskConfig.id = extractValue(paramStr, "id")
    taskConfig.desc = extractValue(paramStr, "desc")
    taskConfig.stageId = extractValue(paramStr, "stageId")
    taskConfig.type = extractValue(paramStr, "type")
    taskConfig.param = extractParam(paramStr)
    
    -- 检查被注释掉的字段
    taskConfig._commentedFields = {}
    if isFieldCommented(paramStr, "desc") then
        table.insert(taskConfig._commentedFields, "desc")
    end
    if isFieldCommented(paramStr, "id") then
        table.insert(taskConfig._commentedFields, "id")
    end
    if isFieldCommented(paramStr, "stageId") then
        table.insert(taskConfig._commentedFields, "stageId")
    end
    if isFieldCommented(paramStr, "type") then
        table.insert(taskConfig._commentedFields, "type")
    end
    
    return taskConfig
end

-- 增强的 taskConfig 验证器
function FunctionCallChecker:validateTaskConfig(paramStr, callInfo)
    -- 尝试解析 taskConfig 参数
    local taskConfig = self:parseTaskConfig(paramStr)
    if not taskConfig then
        local displayParam = (#paramStr > 100) and (string.sub(paramStr, 1, 97) .. "...") or paramStr
        return false, {"taskConfig参数解析失败，请检查语法格式 (当前参数: " .. displayParam .. ")"}
    end
    
    local errors = {}
    
    -- 1. 验证必需字段
    if not taskConfig.id then
        table.insert(errors, "taskConfig.id字段是必需的 (类型: string, 描述: 任务唯一标识符)")
    elseif type(taskConfig.id) ~= "string" then
        table.insert(errors, string.format("taskConfig.id必须是string类型 (当前: %s, 值: %s)", 
            type(taskConfig.id), tostring(taskConfig.id)))
    elseif taskConfig.id == "" then
        table.insert(errors, "taskConfig.id不能为空字符串")
    end
    
    if not taskConfig.desc then
        if taskConfig._commentedFields then
            for _, field in ipairs(taskConfig._commentedFields) do
                if field == "desc" then
                    table.insert(errors, "taskConfig.desc字段被注释掉了，但这是必需字段 (类型: string, 描述: 任务描述)")
                    break
                end
            end
        end
        if not string.find(table.concat(errors, ""), "被注释掉") then
            table.insert(errors, "taskConfig.desc字段是必需的 (类型: string, 描述: 任务描述)")
        end
    elseif type(taskConfig.desc) ~= "string" then
        table.insert(errors, string.format("taskConfig.desc必须是string类型 (当前: %s, 值: %s)", 
            type(taskConfig.desc), tostring(taskConfig.desc)))
    elseif taskConfig.desc == "" then
        table.insert(errors, "taskConfig.desc不能为空字符串")
    end
    
    if not taskConfig.stageId then
        table.insert(errors, "taskConfig.stageId字段是必需的 (类型: number, 描述: 关卡ID)")
    elseif type(taskConfig.stageId) ~= "number" then
        table.insert(errors, string.format("taskConfig.stageId必须是number类型 (当前: %s, 值: %s)", 
            type(taskConfig.stageId), tostring(taskConfig.stageId)))
    elseif taskConfig.stageId <= 0 then
        table.insert(errors, string.format("taskConfig.stageId必须大于0 (当前值: %s)", tostring(taskConfig.stageId)))
    end
    
    -- 2. 验证其他字段
    if taskConfig.type then
        local validTypes = {"TaskType.KillMonster", "TaskType.None", "TaskType.MoveTo"}
        local validType = false
        for _, vt in ipairs(validTypes) do
            if taskConfig.type == vt then
                validType = true
                break
            end
        end
        if not validType then
            table.insert(errors, "taskConfig.type无效，必须是以下之一: " .. table.concat(validTypes, ", "))
        end
        
        -- 3. 根据任务类型验证param字段
        if taskConfig.param and taskConfig.type == "TaskType.KillMonster" then
            if type(taskConfig.param) == "table" and #taskConfig.param >= 1 then
                local npcTID = taskConfig.param[1]
                if type(npcTID) == "string" and npcTID ~= "" then
                    -- 验证NpcTID是否存在
                    local ResourceValidator = require("lua_check.resource_validator")
                    local validator = ResourceValidator:getInstance()
                    local valid, err = validator:validateNpcTID(npcTID)
                    if not valid then
                        table.insert(errors, "TaskType.KillMonster的param[1](NpcTID)无效: " .. err)
                    end
                end
            end
        end
    end
    
    return #errors == 0, errors
end


-- 通用参数个数验证
function FunctionCallChecker:validateParameterCount(callInfo)
    local funcName = callInfo.functionName
    local paramStr = callInfo.paramString
    
    -- 获取函数签名
    local signature = self.signatureExtractor:getSignature(funcName)
    if not signature then
        return true, {}  -- 不是API函数，跳过检查
    end
    
    -- 解析实际参数个数
    local actualParamCount = self:countParameters(paramStr)
    
    -- 验证参数个数
    local valid, errorMsg = self.signatureExtractor:validateCall(funcName, actualParamCount)
    if not valid then
        -- 增强错误信息，添加更多上下文
        local enhancedError = string.format("函数 %s 参数个数错误: %s (实际参数: %d个，调用: %s(%s))", 
            funcName, errorMsg, actualParamCount, funcName, 
            (#paramStr > 100) and (string.sub(paramStr, 1, 97) .. "...") or paramStr)
        return false, {enhancedError}
    end
    
    return true, {}
end

-- 字符串trim函数
local function trim(s)
    return s:gsub("^%s*", ""):gsub("%s*$", "")
end

-- 计算参数个数 - 重写版本，更简单更可靠
function FunctionCallChecker:countParameters(paramStr)
    if not paramStr or trim(paramStr) == "" then
        return 0
    end
    
    -- 移除所有注释
    paramStr = paramStr:gsub("%-%-%[%[.-%]%]", "")  -- 移除多行注释
    paramStr = paramStr:gsub("%-%-[^\r\n]*", "")   -- 移除单行注释
    

    
    local count = 0
    local depth = {
        paren = 0,      -- ()
        bracket = 0,    -- []  
        brace = 0,      -- {}
        func = 0        -- function...end
    }
    local blockStack = {}  -- 栈来跟踪不同类型的语句块
    local inString = false
    local stringChar = nil
    local i = 1
    
    while i <= #paramStr do
        local char = paramStr:sub(i, i)
        
        if not inString then
            -- 检查字符串开始
            if char == '"' or char == "'" then
                inString = true
                stringChar = char
            -- 检查各种括号
            elseif char == '(' then
                depth.paren = depth.paren + 1
            elseif char == ')' then
                depth.paren = depth.paren - 1
            elseif char == '[' then
                depth.bracket = depth.bracket + 1
            elseif char == ']' then
                depth.bracket = depth.bracket - 1
            elseif char == '{' then
                depth.brace = depth.brace + 1
            elseif char == '}' then
                depth.brace = depth.brace - 1
                         -- 检查关键字
             elseif char == 'f' then
                 local remaining = paramStr:sub(i)
                 if remaining:match("^function%W") or remaining:match("^function$") then
                     depth.func = depth.func + 1
                     table.insert(blockStack, "function")
                     i = i + 7  -- 跳过"function"的7个字符，循环末尾的+1会移动到下一个字符
                 elseif remaining:match("^for%W") then
                     table.insert(blockStack, "for")
                     i = i + 2  -- 跳过"for"的2个字符
                 end
             elseif char == 'i' then
                 local remaining = paramStr:sub(i)
                 if remaining:match("^if%W") then
                     table.insert(blockStack, "if")
                     i = i + 1  -- 跳过"if"的1个字符
                 end
             elseif char == 'w' then
                 local remaining = paramStr:sub(i)
                 if remaining:match("^while%W") then
                     table.insert(blockStack, "while")
                     i = i + 4  -- 跳过"while"的4个字符
                 end
             -- 检查end关键字  
             elseif char == 'e' then
                 local remaining = paramStr:sub(i)
                 if remaining:match("^end%W") or remaining:match("^end$") then
                     if #blockStack > 0 then
                         local blockType = table.remove(blockStack)  -- 弹出最近的语句块
                         if blockType == "function" then
                             depth.func = depth.func - 1
                         end
                     end
                     i = i + 2  -- 跳过"end"的2个字符，循环末尾的+1会移动到下一个字符
                 end
            -- 检查参数分隔符（逗号）
            elseif char == ',' then
                -- 只有在顶层时，逗号才算作参数分隔符
                if depth.paren == 0 and depth.bracket == 0 and depth.brace == 0 and depth.func == 0 then
                    count = count + 1
                end
            end
        else
            -- 在字符串内，检查字符串结束
            if char == stringChar then
                -- 检查是否是转义的引号
                if i == 1 or paramStr:sub(i-1, i-1) ~= '\\' then
                    inString = false
                    stringChar = nil
                end
            end
        end
        
        i = i + 1
    end
    
    -- 如果有非空参数内容（去掉空白后），至少有一个参数
    local trimmedParam = trim(paramStr)
    if trimmedParam ~= "" then
        count = count + 1
    end
    

    
    return count
end

-- 检查API范围
function FunctionCallChecker:validateApiScope(callInfo, filePath)
    local funcName = callInfo.functionName
    local errors = {}
    
    -- 标准化文件路径
    local normalizedPath = filePath:gsub("\\", "/"):gsub("//+", "/")
    
    -- 查找匹配的目录
    local allowedPrefixes = nil
    for dirPattern, prefixes in pairs(self.directoryApiMap) do
        if normalizedPath:match(dirPattern) then
            allowedPrefixes = prefixes
            break
        end
    end
    
    -- 如果没有匹配的目录，不进行API范围检查
    if not allowedPrefixes then
        return true, {}
    end
    
    -- 检查函数是否以允许的前缀开头
    local allowed = false
    for _, prefix in ipairs(allowedPrefixes) do
        if funcName:sub(1, #prefix) == prefix then
            allowed = true
            break
        end
    end
    
    if not allowed then
        -- 检查函数是否存在于API中
        local signature = self.signatureExtractor:getSignature(funcName)
        if signature then
            -- 函数存在但不在允许范围内
            local allowedStr = table.concat(allowedPrefixes, ", ")
            table.insert(errors, string.format("函数 %s 不允许在此目录中使用，只能使用: %s", funcName, allowedStr))
        else
            -- 函数不存在
            table.insert(errors, string.format("调用了未定义的函数: %s", funcName))
        end
    end
    
    return #errors == 0, errors
end

-- 检查单个函数调用
function FunctionCallChecker:validateFunctionCall(callInfo, filePath)
    local funcName = callInfo.functionName
    local errors = {}
    
    -- 1. 首先进行API范围检查
    local scopeValid, scopeErrors = self:validateApiScope(callInfo, filePath)
    if not scopeValid then
        for _, err in ipairs(scopeErrors) do
            table.insert(errors, err)
        end
    end
    
    -- 2. 然后进行通用参数个数检查（只有在API范围内的函数才检查参数）
    if scopeValid then
        local countValid, countErrors = self:validateParameterCount(callInfo)
        if not countValid then
            for _, err in ipairs(countErrors) do
                table.insert(errors, err)
            end
        end
    end
    
    -- 3. 最后进行特殊验证（如果有）
    if scopeValid and callInfo.rule and callInfo.rule.validator then
        local validator = callInfo.rule.validator
        local specialValid, specialErrors = nil, {}
        
        if validator == "validateTaskConfig" then
            specialValid, specialErrors = self:validateTaskConfig(callInfo.paramString, callInfo)
        else
            specialValid, specialErrors = false, {string.format("未知的验证器: %s (函数: %s)", validator, funcName)}
        end
        
        if not specialValid then
            for _, err in ipairs(specialErrors) do
                -- 为特殊验证错误添加更多上下文
                local enhancedError = string.format("函数 %s 的第%d个参数配置错误: %s", 
                    funcName, callInfo.rule.paramIndex or 1, err)
                table.insert(errors, enhancedError)
            end
        end
    end
    
    return #errors == 0, errors
end

-- 检查整个文件
function FunctionCallChecker:checkFile(filePath)
    local success, result = self:parseFile(filePath)
    if not success then
        return false, result
    end
    
    local allErrors = {}
    
    for _, callInfo in ipairs(result) do
        local valid, errors = self:validateFunctionCall(callInfo, filePath)
        if not valid then
            local errorInfo = {
                file = filePath,
                startLine = callInfo.startLine,
                endLine = callInfo.endLine or callInfo.startLine,
                function_name = callInfo.functionName,
                errors = errors
            }
            table.insert(allErrors, errorInfo)
        end
    end
    
    return #allErrors == 0, allErrors
end

-- 格式化错误报告
function FunctionCallChecker:formatErrorReport(errors)
    local report = {}
    
    table.insert(report, "=== 函数调用检查报告 ===")
    table.insert(report, "")
    
    if #errors == 0 then
        table.insert(report, "✅ 未发现问题")
    else
        table.insert(report, string.format("❌ 发现 %d 个问题:", #errors))
        table.insert(report, "")
        
        for i, error in ipairs(errors) do
            table.insert(report, string.format("%d. 文件: %s", i, error.file))
            if error.startLine == error.endLine then
                table.insert(report, string.format("   行号: %d", error.startLine))
            else
                table.insert(report, string.format("   行号: %d-%d", error.startLine, error.endLine))
            end
            table.insert(report, string.format("   函数: %s", error.function_name))
            table.insert(report, "   错误:")
            
            for j, errorMsg in ipairs(error.errors) do
                table.insert(report, string.format("     - %s", errorMsg))
            end
            table.insert(report, "")
        end
    end
    
    return table.concat(report, "\n")
end

return FunctionCallChecker 