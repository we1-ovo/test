-- 综合检查器 - 扫描所有GenRPG文件并检查文件结构和函数调用
local ComprehensiveChecker = {}

-- 加载依赖
local FunctionCallChecker = require("lua_check.function_call_checker")

-- 创建检查器实例
function ComprehensiveChecker:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    
    o.functionCallChecker = FunctionCallChecker:new()
    o.checkedFiles = {}
    o.allErrors = {}
    o.structureErrors = {}
    o.baseDir = nil  -- 添加基础目录记录
    
    return o
end

-- 工具函数：标准化路径
function ComprehensiveChecker:normalizePath(path)
    -- 移除多余的斜杠和路径分隔符
    local normalized = path:gsub("//+", "/")
    -- 移除开头的 ./
    normalized = normalized:gsub("^%./", "")
    -- 移除结尾的斜杠
    normalized = normalized:gsub("/$", "")
    return normalized
end

-- 工具函数：安全地拼接路径
function ComprehensiveChecker:joinPath(base, ...)
    local parts = {self:normalizePath(base)}
    for _, part in ipairs({...}) do
        if part and part ~= "" then
            table.insert(parts, self:normalizePath(part))
        end
    end
    return table.concat(parts, "/")
end

-- 工具函数：检查目录是否存在
function ComprehensiveChecker:directoryExists(path)
    local normalizedPath = self:normalizePath(path)
    local handle = io.popen("test -d '" .. normalizedPath .. "' && echo 'EXISTS' || echo 'NOT_EXISTS'")
    if handle then
        local result = handle:read("*l")
        handle:close()
        return result == "EXISTS"
    end
    return false
end

-- 工具函数：检查文件是否存在
function ComprehensiveChecker:fileExists(path)
    local normalizedPath = self:normalizePath(path)
    local handle = io.popen("test -f '" .. normalizedPath .. "' && echo 'EXISTS' || echo 'NOT_EXISTS'")
    if handle then
        local result = handle:read("*l")
        handle:close()
        return result == "EXISTS"
    end
    return false
end

-- 工具函数：获取目录下的所有条目
function ComprehensiveChecker:getDirectoryContents(dirPath)
    local contents = {}
    local normalizedPath = self:normalizePath(dirPath)
    local handle = io.popen("ls -1 '" .. normalizedPath .. "' 2>/dev/null")
    if handle then
        for item in handle:lines() do
            table.insert(contents, item)
        end
        handle:close()
    end
    return contents
end

-- 工具函数：获取目录下的所有子目录
function ComprehensiveChecker:getSubdirectories(dirPath)
    local subdirs = {}
    local contents = self:getDirectoryContents(dirPath)
    
    for _, item in ipairs(contents) do
        local fullPath = self:joinPath(dirPath, item)
        if self:directoryExists(fullPath) then
            table.insert(subdirs, item)
        end
    end
    
    return subdirs
end

-- 工具函数：获取目录下的所有.lua文件
function ComprehensiveChecker:getLuaFiles(dirPath)
    local luaFiles = {}
    local contents = self:getDirectoryContents(dirPath)
    
    for _, item in ipairs(contents) do
        if item:match("%.lua$") then
            table.insert(luaFiles, item)
        end
    end
    
    return luaFiles
end

-- 记录结构错误
function ComprehensiveChecker:recordStructureError(category, message)
    table.insert(self.structureErrors, {
        category = category,
        message = message,
        timestamp = os.date("%Y-%m-%d %H:%M:%S")
    })
    -- 同时记录到全局错误收集器
    if _G.GlobalErrorCollector then
        _G.GlobalErrorCollector:addError("COMPREHENSIVE_CHECKER", category, message, nil, nil)
    end
end

-- 检查Skill目录结构
function ComprehensiveChecker:checkSkillDirectory(baseDir)
    local skillDir = self:joinPath(baseDir, "Skill")
    
    if not self:directoryExists(skillDir) then
        print("   ℹ️  Skill目录不存在，这是可选的")
        return true  -- 改为返回true，表示这是正常的
    end
    
    local luaFiles = self:getLuaFiles(skillDir)
    print(string.format("   找到 %d 个技能文件", #luaFiles))
    
    -- 技能文件名应该使用SkillTID构成，*.lua
    for _, fileName in ipairs(luaFiles) do
        local fullPath = self:joinPath(skillDir, fileName)
        table.insert(self.checkedFiles, fullPath)
        
        -- 这里可以添加SkillTID格式检查
        -- print(string.format("   ✓ 技能文件: %s", fileName))
    end
    
    return true
end

-- 检查NPC目录结构
function ComprehensiveChecker:checkNPCDirectory(baseDir)
    local npcDir = self:joinPath(baseDir, "NPC")
    
    if not self:directoryExists(npcDir) then
        print("   ℹ️  NPC目录不存在，这是可选的")
        return true  -- 改为返回true，表示这是正常的
    end
    
    local npcSubdirs = self:getSubdirectories(npcDir)
    print(string.format("   找到 %d 个NPC子目录", #npcSubdirs))
    
    local hasErrors = false
    
    -- 每个NPC目录名为NpcTID，必须有onUpdateStrategy.lua
    for _, npcTID in ipairs(npcSubdirs) do
        local npcSubDir = self:joinPath(npcDir, npcTID)
        local strategyFile = self:joinPath(npcSubDir, "onUpdateStrategy.lua")
        
        -- print(string.format("   🤖 检查NPC: %s", npcTID))
        
        if not self:fileExists(strategyFile) then
            self:recordStructureError("NPC", string.format("NPC目录 '%s' 缺少必需的 onUpdateStrategy.lua 文件", npcTID))
            print(string.format("     ❌ 缺少: onUpdateStrategy.lua"))
            hasErrors = true
        else
            table.insert(self.checkedFiles, strategyFile)
            -- print(string.format("     ✓ onUpdateStrategy.lua"))
        end
    end
    
    return not hasErrors
end

-- 检查Level目录结构
function ComprehensiveChecker:checkLevelDirectory(baseDir)
    local levelDir = self:joinPath(baseDir, "Level")
    
    local hasErrors = false
    
    if not self:directoryExists(levelDir) then
        self:recordStructureError("LEVEL", "Level目录不存在: " .. levelDir)
        -- 记录错误但不要立即返回，继续处理
        hasErrors = true
        return not hasErrors
    end
    
    local stageSubdirs = self:getSubdirectories(levelDir)
    print(string.format("   找到 %d 个关卡目录", #stageSubdirs))
    
    local requiredFiles = {"process.lua", "onStageSuccess.lua", "onStageFailed.lua"}
    
    -- 每个关卡目录必须有三个必需文件
    for _, stageName in ipairs(stageSubdirs) do
        local stageDir = self:joinPath(levelDir, stageName)
        -- print(string.format("   🎮 检查关卡: %s", stageName))
        
        for _, requiredFile in ipairs(requiredFiles) do
            local filePath = self:joinPath(stageDir, requiredFile)
            
            if not self:fileExists(filePath) then
                self:recordStructureError("LEVEL", string.format("关卡目录 '%s' 缺少必需的 %s 文件", stageName, requiredFile))
                print(string.format("     ❌ 缺少: %s", requiredFile))
                hasErrors = true
            else
                table.insert(self.checkedFiles, filePath)
                -- print(string.format("     ✓ %s", requiredFile))
            end
        end
    end
    
    return not hasErrors
end

-- 检查Prof目录结构
function ComprehensiveChecker:checkProfDirectory(baseDir)
    local profDir = self:joinPath(baseDir, "Prof")
    
    if not self:directoryExists(profDir) then
        self:recordStructureError("PROF", "Prof目录不存在: " .. profDir)
        -- 记录错误但继续处理
        return false
    end
    
    local luaFiles = self:getLuaFiles(profDir)
    print(string.format("   找到 %d 个职业/角色文件", #luaFiles))
    
    local hasErrors = false
    
    -- 检查是否有player.lua
    local playerFile = self:joinPath(profDir, "player.lua")
    if not self:fileExists(playerFile) then
        self:recordStructureError("PROF", "Prof目录缺少必需的 player.lua 文件")
        print("     ❌ 缺少: player.lua")
        hasErrors = true
    else
        table.insert(self.checkedFiles, playerFile)
        -- print("     ✓ player.lua")
    end
    
    -- 其他文件名应该使用NpcTID构成
    for _, fileName in ipairs(luaFiles) do
        if fileName ~= "player.lua" then
            local fullPath = self:joinPath(profDir, fileName)
            table.insert(self.checkedFiles, fullPath)
            -- print(string.format("   ✓ 角色定义文件: %s", fileName))
        end
    end
    
    return not hasErrors
end

-- 检查Item目录结构和内容
function ComprehensiveChecker:checkItemDirectory(baseDir)
    local itemDir = self:joinPath(baseDir, "Item")
    
    if not self:directoryExists(itemDir) then
        print("   ℹ️  Item目录不存在，这是可选的")
        return true  -- 改为返回true，表示这是正常的
    end
    
    local luaFiles = self:getLuaFiles(itemDir)
    print(string.format("   找到 %d 个物品文件", #luaFiles))
    
    if #luaFiles == 0 then
        print("   ℹ️  Item目录为空，这是合法的")
        return true
    end
    
    -- 使用ItemChecker进行深度检查
    local ItemChecker = require("lua_check.item_checker")
    local itemChecker = ItemChecker:new()
    
    local itemCheckSuccess = itemChecker:checkItemDirectory(itemDir)
    
    -- 将检查的文件添加到checkedFiles列表（用于其他检查器）
    for _, fileName in ipairs(luaFiles) do
        local fullPath = self:joinPath(itemDir, fileName)
        table.insert(self.checkedFiles, fullPath)
    end
    
    -- 如果有错误，将其添加到结构错误列表
    local itemErrors = itemChecker:getErrors()
    if #itemErrors > 0 then
        for _, error in ipairs(itemErrors) do
            self:recordStructureError("ITEM", error.message)
        end
    end
    
    return itemCheckSuccess
end

-- 检查Locator目录结构
function ComprehensiveChecker:checkLocatorDirectory(baseDir)
    local locatorDir = self:joinPath(baseDir, "Locator")
    print("🔍 检查Locator目录结构...")
    
    local hasErrors = false
    
    if not self:directoryExists(locatorDir) then
        self:recordStructureError("LOCATOR", "Locator目录不存在: " .. locatorDir)
        hasErrors = true
    else
        local locatorFile = self:joinPath(locatorDir, "Locator.lua")
        
        if not self:fileExists(locatorFile) then
            self:recordStructureError("LOCATOR", "Locator目录缺少必需的 Locator.lua 文件")
            print("     ❌ 缺少: Locator.lua")
            hasErrors = true
        else
            table.insert(self.checkedFiles, locatorFile)
            -- print("     ✓ Locator.lua")
        end
    end
    
    return not hasErrors
end

-- 检查NPC和Prof目录的对应关系
function ComprehensiveChecker:checkNPCProfConsistency(baseDir)
    print("🔍 检查NPC和Prof目录的对应关系...")
    
    local npcDir = self:joinPath(baseDir, "NPC")
    local profDir = self:joinPath(baseDir, "Prof")
    
    -- 如果NPC目录不存在，跳过一致性检查
    if not self:directoryExists(npcDir) then
        print("   ℹ️  NPC目录不存在，跳过NPC-Prof一致性检查")
        return true
    end
    
    if not self:directoryExists(profDir) then
        self:recordStructureError("CONSISTENCY", "NPC目录存在但Prof目录不存在")
        -- 记录错误但继续处理其他检查
        return false
    end
    
    local npcSubdirs = self:getSubdirectories(npcDir)
    local profFiles = self:getLuaFiles(profDir)
    
    local hasErrors = false
    
    -- 创建Prof文件名集合（去掉.lua扩展名）
    local profNames = {}
    for _, fileName in ipairs(profFiles) do
        local baseName = fileName:match("^(.+)%.lua$")
        if baseName and baseName ~= "player" then
            profNames[baseName] = true
        end
    end
    
    -- 每个有NPC AI的必定有对应于Prof目录下的<NpcTID>.lua描述属性
    for _, npcTID in ipairs(npcSubdirs) do
        if not profNames[npcTID] then
            local errorMessage = string.format("FATAL: NPC '%s' 在Prof目录中缺少对应的 %s.lua 文件", npcTID, npcTID)
            self:recordStructureError("CONSISTENCY", errorMessage)
            print(string.format("     ❌ %s", errorMessage))
            -- 不再直接终止程序，而是记录为严重错误并继续
            if _G.GlobalErrorCollector then
                _G.GlobalErrorCollector:addError("CONSISTENCY_CHECK", "FATAL_ERROR", errorMessage, nil, nil)
            end
            hasErrors = true
        else
            -- print(string.format("     ✓ NPC '%s' 有对应的Prof文件", npcTID))
        end
    end
    
    return not hasErrors
end

-- 检查单个文件
function ComprehensiveChecker:checkFile(filePath)
    local valid, errors = self.functionCallChecker:checkFile(filePath)
    
    if not valid then
        for _, error in ipairs(errors) do
            error.file = filePath
            table.insert(self.allErrors, error)
        end
    end
    
    return valid, errors
end

-- 检查所有文件的内容
function ComprehensiveChecker:checkAllFileContents()
    local fileCount = #self.checkedFiles
    local errorFileCount = 0
    
    if fileCount == 0 then
        print("   ⚠️  没有找到需要检查的文件")
        return true
    end
    
    for i, filePath in ipairs(self.checkedFiles) do
        -- print(string.format("📄 [%d/%d] 检查: %s", i, fileCount, filePath))
        
        local valid, errors = self:checkFile(filePath)
        
        if not valid then
            errorFileCount = errorFileCount + 1
            -- 不在这里输出错误详情，避免与main.lua中的详细输出重复
        else
            -- print("   ✅ 没有发现问题")
        end
    end
    
    print(string.format("📊 文件内容检查完成: %d/%d 个文件有问题", errorFileCount, fileCount))
    
    return errorFileCount == 0
end

-- 主检查方法
function ComprehensiveChecker:checkAllLevelFiles(baseDir, enableStaticCheck)
    print("=== 开始综合结构检查 ===")
    
    -- 标准化基础目录路径
    self.baseDir = self:normalizePath(baseDir or ".")
    
    -- 默认关闭静态检查
    enableStaticCheck = enableStaticCheck or false
    
    -- 检查各个目录结构
    local structureResults = {
        skill = self:checkSkillDirectory(self.baseDir),
        npc = self:checkNPCDirectory(self.baseDir),
        level = self:checkLevelDirectory(self.baseDir),
        prof = self:checkProfDirectory(self.baseDir),
        item = self:checkItemDirectory(self.baseDir),
        locator = self:checkLocatorDirectory(self.baseDir)
    }
    
    
    -- 检查NPC和Prof的对应关系
    local consistencyResult = self:checkNPCProfConsistency(self.baseDir)
    
    
    -- 检查文件内容（静态检查）
    local contentResult = true
    if enableStaticCheck then
        if #self.structureErrors == 0 then
            contentResult = self:checkAllFileContents()
        else
            print("🚫 由于结构错误，跳过文件内容检查")
        end
    else
        print("🔧 静态检查已禁用 (使用 --enable-static-check 启用)")
    end
    
    -- 汇总结果
    local structureSuccess = true
    for _, result in pairs(structureResults) do
        structureSuccess = structureSuccess and result
    end
    
    local overallSuccess = structureSuccess and consistencyResult and contentResult
    
    print("\n=== 检查结果汇总 ===")
    print(string.format("📂 目录结构: %s", structureSuccess and "✅ 通过" or "❌ 失败"))
    print(string.format("🔗 一致性检查: %s", consistencyResult and "✅ 通过" or "❌ 失败"))
    if enableStaticCheck then
        print(string.format("📄 文件内容: %s", contentResult and "✅ 通过" or "❌ 失败"))
    else
        print("📄 文件内容: 🔧 已禁用")
    end
    print(string.format("🎯 总体结果: %s", overallSuccess and "✅ 通过" or "❌ 失败"))
    
    if #self.structureErrors > 0 then
        print(string.format("\n📋 结构错误: %d 个", #self.structureErrors))
        for _, error in ipairs(self.structureErrors) do
            print(string.format("   - [%s] %s", error.category, error.message))
        end
    end
    
    if enableStaticCheck and #self.allErrors > 0 then
        -- print(string.format("📋 内容错误: %d 个", #self.allErrors))
    elseif not enableStaticCheck then
        print("📋 内容错误: 未检查 (静态检查已禁用)")
    end
    
    -- 合并所有错误
    local allCombinedErrors = {}
    
    -- 添加结构错误
    for _, error in ipairs(self.structureErrors) do
        table.insert(allCombinedErrors, {
            file = error.category,
            startLine = 0,
            endLine = 0,
            function_name = "STRUCTURE_CHECK",
            errors = {error.message}
        })
    end
    
    -- 添加内容错误
    for _, error in ipairs(self.allErrors) do
        table.insert(allCombinedErrors, error)
    end
    
    return overallSuccess, allCombinedErrors
end

-- 生成详细报告
function ComprehensiveChecker:generateReport()
    local report = {}
    
    table.insert(report, "=== 综合检查报告 ===")
    table.insert(report, "")
    table.insert(report, string.format("📊 统计信息:"))
    table.insert(report, string.format("   - 已检查文件: %d", #self.checkedFiles))
    table.insert(report, string.format("   - 结构错误: %d", #self.structureErrors))
    table.insert(report, string.format("   - 内容错误: %d", #self.allErrors))
    table.insert(report, string.format("   - 总错误数: %d", #self.structureErrors + #self.allErrors))
    table.insert(report, "")
    
    if #self.structureErrors == 0 and #self.allErrors == 0 then
        table.insert(report, "✅ 恭喜！所有检查都通过了")
    else
        if #self.structureErrors > 0 then
            table.insert(report, "❌ 发现的结构问题:")
            table.insert(report, "")
            
            local errorsByCategory = {}
            for _, error in ipairs(self.structureErrors) do
                if not errorsByCategory[error.category] then
                    errorsByCategory[error.category] = {}
                end
                table.insert(errorsByCategory[error.category], error)
            end
            
            for category, errors in pairs(errorsByCategory) do
                table.insert(report, string.format("📁 %s 目录:", category))
                for i, error in ipairs(errors) do
                    table.insert(report, string.format("   %d. %s", i, error.message))
                end
                table.insert(report, "")
            end
        end
        
        if #self.allErrors > 0 then
            table.insert(report, "❌ 发现的内容问题:")
            table.insert(report, "")
            
            -- 按文件分组错误
            local errorsByFile = {}
            for _, error in ipairs(self.allErrors) do
                if not errorsByFile[error.file] then
                    errorsByFile[error.file] = {}
                end
                table.insert(errorsByFile[error.file], error)
            end
            
            local fileIndex = 1
            for filePath, errors in pairs(errorsByFile) do
                table.insert(report, string.format("📄 %d. 文件: %s", fileIndex, filePath))
                table.insert(report, string.format("   问题数量: %d", #errors))
                table.insert(report, "")
                
                for i, error in ipairs(errors) do
                    table.insert(report, string.format("   问题 %d:", i))
                    if error.startLine == error.endLine then
                        table.insert(report, string.format("     行号: %d", error.startLine))
                    else
                        table.insert(report, string.format("     行号: %d-%d", error.startLine, error.endLine))
                    end
                    table.insert(report, string.format("     函数: %s", error.function_name))
                    table.insert(report, "     错误:")
                    
                    for j, errorMsg in ipairs(error.errors) do
                        table.insert(report, string.format("       - %s", errorMsg))
                    end
                    table.insert(report, "")
                end
                
                fileIndex = fileIndex + 1
            end
        end
    end
    
    table.insert(report, "")
    table.insert(report, "=== 检查完成 ===")
    
    return table.concat(report, "\n")
end

-- 保存报告到文件
function ComprehensiveChecker:saveReport(filename)
    local report = self:generateReport()
    
    local file = io.open(filename, "w")
    if file then
        file:write(report)
        file:close()
        print(string.format("📄 报告已保存到: %s", filename))
        return true
    else
        print(string.format("❌ 无法保存报告到: %s", filename))
        return false
    end
end

-- 获取错误统计
function ComprehensiveChecker:getErrorStatistics()
    local stats = {
        totalStructureErrors = #self.structureErrors,
        totalContentErrors = #self.allErrors,
        totalFiles = #self.checkedFiles,
        errorsByCategory = {},
        errorsByFunction = {}
    }
    
    -- 统计结构错误
    for _, error in ipairs(self.structureErrors) do
        if not stats.errorsByCategory[error.category] then
            stats.errorsByCategory[error.category] = 0
        end
        stats.errorsByCategory[error.category] = stats.errorsByCategory[error.category] + 1
    end
    
    -- 统计内容错误
    for _, error in ipairs(self.allErrors) do
        if not stats.errorsByFunction[error.function_name] then
            stats.errorsByFunction[error.function_name] = 0
        end
        stats.errorsByFunction[error.function_name] = stats.errorsByFunction[error.function_name] + 1
    end
    
    return stats
end

-- 打印错误统计
function ComprehensiveChecker:printStatistics()
    local stats = self:getErrorStatistics()
    
    print("=== 错误统计 ===")
    
    print(string.format("📊 总体统计:"))
    print(string.format("   - 检查文件数: %d", stats.totalFiles))
    print(string.format("   - 结构错误数: %d", stats.totalStructureErrors))
    print(string.format("   - 内容错误数: %d", stats.totalContentErrors))
    print("")
    
    if stats.totalStructureErrors > 0 then
        print("📁 按目录分类:")
        for category, count in pairs(stats.errorsByCategory) do
            print(string.format("   - %s: %d", category, count))
        end
    end
    
    if stats.totalContentErrors > 0 then
        print("📈 按函数分类:")
        for funcName, count in pairs(stats.errorsByFunction) do
            print(string.format("   - %s: %d", funcName, count))
        end
    end
    
end

return ComprehensiveChecker 