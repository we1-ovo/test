-- 函数签名提取器
-- 从API定义文件中自动提取函数签名信息（参数个数、类型等）

local FunctionSignatureExtractor = {}

-- 创建提取器实例
function FunctionSignatureExtractor:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    
    -- 存储提取的函数签名
    o.signatures = {}
    
    return o
end

-- 从文件内容中提取函数签名
function FunctionSignatureExtractor:extractFromContent(content, moduleName)
    local signatures = {}
    
    -- 分行处理
    local lines = {}
    for line in content:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end
    
    local i = 1
    while i <= #lines do
        local line = lines[i]
        
        -- 匹配函数定义：function XXXX_FunctionName(param1, param2, ...)
        local funcName, paramStr = line:match("function%s+([%w_]+)%s*%(([^)]*)%)")
        
        if funcName and (funcName:match("^LEVEL_") or funcName:match("^NPC_") or funcName:match("^Skill_") or funcName:match("^Item_")) then
            -- 解析参数列表
            local params = {}
            if paramStr and paramStr:trim() ~= "" then
                -- 分割参数，处理可能的空格
                for param in paramStr:gmatch("([^,]+)") do
                    local cleanParam = param:gsub("^%s*", ""):gsub("%s*$", "")
                    if cleanParam ~= "" then
                        table.insert(params, cleanParam)
                    end
                end
            end
            
            -- 提取参数类型信息（从validateParam调用中）
            local paramTypes = {}
            local j = i + 1
            local validateParamCount = 0
            
            -- 向下查找validateParam调用，限制查找范围
            while j <= #lines and j <= i + 20 do
                local validateLine = lines[j]
                
                -- 匹配validateParam调用
                local paramName, paramType = validateLine:match('validateParam%("([^"]+)",%s*[^,]+,%s*"([^"]+)"')
                if paramName and paramType then
                    paramTypes[paramName] = paramType
                    validateParamCount = validateParamCount + 1
                end
                
                -- 如果遇到下一个函数定义或者文件结束，停止查找
                if validateLine:match("^function%s+") and j > i then
                    break
                end
                
                j = j + 1
            end
            
            -- 存储函数签名
            signatures[funcName] = {
                name = funcName,
                paramCount = #params,
                paramNames = params,
                paramTypes = paramTypes,
                validateParamCount = validateParamCount,
                module = moduleName
            }
        end
        
        i = i + 1
    end
    
    return signatures
end

-- 从API定义文件中提取所有函数签名
function FunctionSignatureExtractor:extractFromFiles()
    local apiFiles = {
        {file = "lua_check/level.lua", module = "LEVEL"},
        {file = "lua_check/ai.lua", module = "NPC"},
        {file = "lua_check/skill.lua", module = "SKILL"},
        {file = "lua_check/item.lua", module = "ITEM"}
    }
    
    self.signatures = {}
    
    for _, apiFile in ipairs(apiFiles) do
        local file = io.open(apiFile.file, "r")
        if file then
            local content = file:read("*all")
            file:close()
            
            local moduleSignatures = self:extractFromContent(content, apiFile.module)
            
            -- 合并到总签名表中
            for funcName, signature in pairs(moduleSignatures) do
                self.signatures[funcName] = signature
            end
        else
            print("⚠️ 警告：无法打开API定义文件: " .. apiFile.file)
        end
    end
    
    return self.signatures
end

-- 获取函数签名
function FunctionSignatureExtractor:getSignature(funcName)
    return self.signatures[funcName]
end

-- 验证函数调用的参数个数
function FunctionSignatureExtractor:validateCall(funcName, actualParamCount)
    local signature = self:getSignature(funcName)
    if not signature then
        return false, "未找到函数签名: " .. funcName
    end
    
    if actualParamCount ~= signature.paramCount then
        return false, string.format(
            "参数个数不匹配: %s 期望 %d 个参数，实际传入 %d 个参数",
            funcName, signature.paramCount, actualParamCount
        )
    end
    
    return true, "参数个数验证通过"
end

-- 获取所有API函数名列表
function FunctionSignatureExtractor:getAllAPIFunctions()
    local functions = {}
    for funcName, _ in pairs(self.signatures) do
        table.insert(functions, funcName)
    end
    table.sort(functions)
    return functions
end

-- 打印签名信息（用于调试）
function FunctionSignatureExtractor:printSignatures()
    print("🔍 提取的函数签名信息:")
    for funcName, sig in pairs(self.signatures) do
        print(string.format("  %s: %d个参数 [%s]", 
            funcName, sig.paramCount, table.concat(sig.paramNames, ", ")))
    end
end

-- 工具函数：字符串trim
function string:trim()
    return self:gsub("^%s*", ""):gsub("%s*$", "")
end

return FunctionSignatureExtractor 