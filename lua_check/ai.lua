---@description 作用: 获取UUID为targetUUID的自身所在位置. 如果targetUUID空字符串，则获取自身位置@Terms.Pos.
---@param targetUUID string targetUUID目标，如果空字符串，则为自己
---@return table Pos 位置Pos(table) @Terms.Pos,包含x,y,z三个number类型的字段.
function NPC_GetPos(targetUUID)
    if type(targetUUID) ~= "string" then
        error("Sig:Pos NPC_GetPos(string targetUUID),参数错误: targetUUID必须是string类型")
    end
    -- TODO: Implement the function logic here
    return {}
end
---@description 作用: 获取UUID为targetUUID的自身当前移动速度. 如果targetUUID空字符串，则获取自身速度.
---@param targetUUID string targetUUID目标，如果空字符串，则为自己
---@return number Speed UUID为targetUUID的自身当前移动速度.
function NPC_GetSpeed(targetUUID)
    if type(targetUUID) ~= "string" then
        error("Sig:number NPC_GetSpeed(string targetUUID),参数错误: targetUUID必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 0
end
---@description 作用: 获取UUID为targetUUID的当前血量. 如果targetUUID空字符串，则获取自身血量.
---@param targetUUID string targetUUID目标，如果空字符串，则为自己
---@return number HP UUID为targetUUID的当前血量.
function NPC_GetHP(targetUUID)
    if type(targetUUID) ~= "string" then
        error("Sig:number NPC_GetHP(string targetUUID),参数错误: targetUUID必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 0
end
---@description 作用: 获取UUID为targetUUID的最大血量. 如果targetUUID空字符串，则获取自身最大血量.
---@param targetUUID string targetUUID目标，如果空字符串，则为自己
---@return number MaxHP UUID为targetUUID的最大血量.
function NPC_GetMaxHP(targetUUID)
    if type(targetUUID) ~= "string" then
        error("Sig:number NPC_GetMaxHP(string targetUUID),参数错误: targetUUID必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 0
end
---@description 作用: 获取UUID为targetUUID的当前蓝量. 如果targetUUID空字符串，则获取自身蓝量.
---@param targetUUID string targetUUID目标，如果空字符串，则为自己
---@return number MP UUID为targetUUID的当前蓝量.
function NPC_GetMP(targetUUID)
    if type(targetUUID) ~= "string" then
        error("Sig:number NPC_GetMP(string targetUUID),参数错误: targetUUID必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 0
end
---@description 作用: 获取UUID为targetUUID的最大蓝量. 如果targetUUID空字符串，则获取自身最大蓝量.
---@param targetUUID string UUID为targetUUID目标，如果空字符串，则为自己
---@return number MaxMP UUID为targetUUID的最大蓝量.
function NPC_GetMaxMP(targetUUID)
    if type(targetUUID) ~= "string" then
        error("Sig:number NPC_GetMaxMP(string targetUUID),参数错误: targetUUID必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 0
end
---@description 作用: 获取以pos位置为圆心，radius为半径的圆形区域内的敌人总数量.
---@param pos table 圆心位置{x,y,z number} @Terms.Pos
---@param radius number 半径
---@return number Count 圆形区域内的敌人总数量.
function NPC_GetNearbyEnemyCount(pos, radius)
    if type(pos) ~= "table" and pos ~= nil then
        error("Sig:int NPC_GetNearbyEnemyCount(table pos, number radius), 参数错误: pos必须是table类型或nil")
    end
    if type(radius) ~= "number" then
        error("Sig:int NPC_GetNearbyEnemyCount(table pos, number radius), 参数错误: radius必须是number类型")
    end
    -- TODO: Implement the function logic here
    return 0
end
---@description 作用: 获取以pos位置为圆心，radius为半径的圆形区域内的所有敌人, 该函数会返回一个BattleEntity的UUID的数组, 距离pos距离越近的BattleEntity在数组中越靠前.
---@param pos table 圆心位置{x,y,z number} @Terms.Pos
---@param radius number 半径
---@return table UUIDs BattleEntity的UUID数组, 距离pos距离越近的在数组中越靠前.
function NPC_GetNearbyEnemies(pos, radius)
    if type(pos) ~= "table" and pos ~= nil then
        error("Sig:table NPC_GetNearbyEnemies(table pos, number radius), 参数错误: pos必须是table类型或nil")
    end
    if type(radius) ~= "number" then
        error("Sig:table NPC_GetNearbyEnemies(table pos, number radius), 参数错误: radius必须是number类型")
    end
    -- TODO: Implement the function logic here
    return {}
end
---@description 作用: 获取以pos位置为圆心，radius为半径的圆形区域内的友军总数量.
---@param pos table 圆心位置{x,y,z number} @Terms.Pos
---@param radius number 半径
---@return number Count 圆形区域内的友军总数量.
function NPC_GetNearbyFriendCount(pos, radius)
    if type(pos) ~= "table" and pos ~= nil then
        error("Sig:int NPC_GetNearbyFriendCount(table pos, number radius), 参数错误: pos必须是table类型或nil")
    end
    if type(radius) ~= "number" then
        error("Sig:int NPC_GetNearbyFriendCount(table pos, number radius), 参数错误: radius必须是number类型")
    end
    -- TODO: Implement the function logic here
    return 0
end
---@description 作用: 获取以pos位置为圆心，radius为半径的圆形区域内的所有友军, 该函数会返回一个BattleEntity的UUID数组, 距离pos距离越近的BattleEntity在数组中越靠前.
---@param pos table 圆心位置{x,y,z number} @Terms.Pos
---@param radius number 半径
---@return table UUIDs BattleEntity的UUID数组, 距离pos距离越近的在数组中越靠前.
function NPC_GetNearbyFriends(pos, radius)
    if type(pos) ~= "table" and pos ~= nil then
        error("Sig:table NPC_GetNearbyFriends(table pos, number radius), 参数错误: pos必须是table类型或nil")
    end
    if type(radius) ~= "number" then
        error("Sig:table NPC_GetNearbyFriends(table pos, number radius), 参数错误: radius必须是number类型")
    end
    -- TODO: Implement the function logic here
    return {}
end
---@description 作用: 判断名为NpcUUID的BattleEntity是否还活着.
---@param NpcUUID string @Terms.NpcUUID
---@return boolean Alive 是否还活着.
function NPC_IsAlive(NpcUUID)
    if type(NpcUUID) ~= "string" then
        error("Sig:bool NPC_IsAlive(string NpcUUID),参数错误: NpcUUID必须是string类型")
    end
    -- TODO: Implement the function logic here
    return false
end
---@description 作用: 查询自身当前是否在名为LocatorID的locator附近，和该locator距离小于distance时返回true，如果没有指定distance，使用默认值2米.
---@param LocatorID string locator名
---@param distance number 可选, 检测距离，默认值2米
---@return boolean Reached 是否在名为LocatorID的locator附近，和该locator距离小于distance时返回true，如果没有指定distance，使用默认值2米.
function NPC_IsReached(LocatorID, distance)
    if type(LocatorID) ~= "string" then
        error("Sig:bool NPC_IsReached(string LocatorID, number distance),参数错误: LocatorID必须是string类型")
    end
    if type(distance) ~= "number" then
        error("Sig:bool NPC_IsReached(string LocatorID, number distance), 参数错误: distance必须是number类型")
    end
    -- TODO: Implement the function logic here
    return false
end
---@description 作用: 从小黑板读信息.
---@param key string key
---@return string value 小黑板读信息.
function NPC_BlackboardGet(key)
    if type(key) ~= "string" then
        error("Sig:string NPC_BlackboardGet(string key),参数错误: key必须是string类型")
    end
    -- TODO: Implement the function logic here
    return ""
end
---@description 作用: 获取技能名为SkillTID的技能的施法距离.
---@param SkillTID string 技能名@Terms.SkillTID
---@return number Range 技能的施法距离.
function NPC_GetSkillCastRange(SkillTID)
    if type(SkillTID) ~= "string" then
        error("Sig:number NPC_GetSkillCastRange(string SkillTID),参数错误: SkillTID必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 0
end
---@description 作用: 选择自己range范围内最近的一个目标，返回目标(BattleEntity)的UUID.
---@param radius number 范围
---@return string targetUUID 目标UUID
function NPC_AutoSelectTarget(radius)
    if type(radius) ~= "number" then
        error("Sig:string NPC_AutoSelectTarget(number radius), 参数错误: radius必须是number类型")
    end
    -- TODO: Implement the function logic here
    return ""
end
---@description 作用: 获取以center为圆心radius为半径的圆形内的一个随机位置.
---@param center table 圆心位置{x,y,z number} @Terms.Pos
---@param radius number 半径
---@return table Pos 中心center,半径radius的圆形内的一个随机位置{x,y,z number} @Terms.Pos
function NPC_GetRandomPos(center, radius)
    if type(center) ~= "table" and center ~= nil then
        error("Sig:Pos NPC_GetRandomPos(Pos center, number radius), 参数错误: center必须是table类型或nil")
    end
    if type(radius) ~= "number" then
        error("Sig:Pos NPC_GetRandomPos(Pos center, number radius), 参数错误: radius必须是number类型")
    end
    -- TODO: Implement the function logic here
    return {}
end
---@description 作用: 判断targetUUID是否有buffTID的buff以及是否是负面状态.如果targetUUID填空字符串，则表示检测自身.
---@param targetUUID string 目标UUID
---@param buffTID string buffTID
---@return boolean HasBuff 是否有buffTID的buff
---@return boolean IsNegative 是否是负面状态
function NPC_IsBuffed(targetUUID, buffTID)
    if type(targetUUID) ~= "string" then
        error("Sig:(boolean HasBuff,boolean IsNegative) NPC_IsBuffed(string targetUUID, string buffTID),参数错误: targetUUID必须是string类型")
    end
    if type(buffTID) ~= "string" then
        error("Sig:(boolean HasBuff,boolean IsNegative) NPC_IsBuffed(string targetUUID, string buffTID),参数错误: buffTID必须是string类型")
    end
    -- TODO: Implement the function logic here
    return false, false
end
---@description 作用: 获取自己存活的时间，单位为秒.
---@return number Time 存活的时间，单位为秒.
function NPC_GetElapsedTime()
    -- TODO: Implement the function logic here
    return 0
end
---@description 作用: 获取位置a和b间的距离, 单位为米.
---@param a table 位置a{x,y,z number} @Terms.Pos
---@param b table 位置b{x,y,z number} @Terms.Pos
---@return number Distance 位置a和b间的距离, 单位为米.
function NPC_Distance(a, b)
    if type(a) ~= "table" and a ~= nil then
        error("Sig:number NPC_Distance(Pos a, Pos b), 参数错误: a必须是table类型或nil")
    end
    if type(b) ~= "table" and b ~= nil then
        error("Sig:number NPC_Distance(Pos a, Pos b), 参数错误: b必须是table类型或nil")
    end
    -- TODO: Implement the function logic here
    return 0
end
---@description 作用: 写信息到小黑板, 注意value是字符串类型.不能将函数写入小黑板.
---@param key string key
---@param value string value
function NPC_BlackboardSet(key, value)
    if type(key) ~= "string" then
        error("Sig:NPC_BlackboardSet(string key, string value),参数错误: key必须是string类型")
    end
    if type(value) ~= "string" then
        error("Sig:NPC_BlackboardSet(string key, string value),参数错误: value必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 开始或结束无敌状态，无敌状态中不会受到伤害.
---@param enable boolean true表示开始无敌，false表示结束.
function NPC_Invincible(enable)
    if type(enable) ~= "boolean" then
        error("Sig:NPC_Invincible(bool enable), 参数错误: enable必须是boolean类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 让所属NPC说句话.
---@param content string 话的具体内容.
function NPC_Say(content)
    if type(content) ~= "string" then
        error("Sig:NPC_Say(string content),参数错误: content必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 离开场景，即让所属NPC从当前场景消失不见.
function NPC_Leave()
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 当前NPC释放名为指定SkillTID的技能.NPC释放技能忽略技能Cooldown和MPCost,必定释放成功，系统必定会选择一个合适的目标，调用者无须关心目标。
---@param SkillTID string 技能名@Terms.SkillTID
function NPC_CastSkill(SkillTID)
    if type(SkillTID) ~= "string" then
        error("Sig:NPC_CastSkill(string SkillTID),参数错误: SkillTID必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 随机返回一个当前NPC可以释放的技能@Terms.SkillTID.
---@return string SkillTID 技能名 @Terms.SkillTID
function NPC_RandomAvailableSkill()
    -- TODO: Implement the function logic here
    return ""
end
---@description 作用: 调整移动速度.
---@param speed number 期望值，<0表示恢复默认速度.
function NPC_SetSpeed(speed)
    if type(speed) ~= "number" then
        error("Sig:NPC_SetSpeed(number speed), 参数错误: speed必须是number类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 开始向名为LocatorID的locator所在位置移动.
---@param stateDir table 移动终止后的朝向 @Terms.Dir
---@param context string 上下文，用于调试日志
---@param LocatorID string @Terms.LocatorID
---@param durationMax number 单位秒，最多走durationMax秒后结束时本次移动
function NPC_MoveToLocator(stateDir, context, LocatorID, durationMax)
    if type(stateDir) ~= "table" and stateDir ~= nil then
        error("Sig:NPC_MoveToLocator(table stateDir, string context, string LocatorID, number durationMax), 参数错误: stateDir必须是table类型或nil")
    end
    if type(context) ~= "string" then
        error("Sig:NPC_MoveToLocator(table stateDir, string context, string LocatorID, number durationMax),参数错误: context必须是string类型")
    end
    if type(LocatorID) ~= "string" then
        error("Sig:NPC_MoveToLocator(table stateDir, string context, string LocatorID, number durationMax),参数错误: LocatorID必须是string类型")
    end
    if type(durationMax) ~= "number" then
        error("Sig:NPC_MoveToLocator(table stateDir, string context, string LocatorID, number durationMax), 参数错误: durationMax必须是number类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 开始向pos位置移动.
---@param stateDir table 朝向 @Terms.Dir
---@param context string 上下文，用于调试日志
---@param pos table 位置{x,y,z number} @Terms.Pos
---@param durationMax number 最多走durationMax秒后结束时本次移动
function NPC_MoveToPos(stateDir, context, pos, durationMax)
    if type(stateDir) ~= "table" and stateDir ~= nil then
        error("Sig:NPC_MoveToPos(table stateDir, string context, table pos, number durationMax), 参数错误: stateDir必须是table类型或nil")
    end
    if type(context) ~= "string" then
        error("Sig:NPC_MoveToPos(table stateDir, string context, table pos, number durationMax),参数错误: context必须是string类型")
    end
    if type(pos) ~= "table" and pos ~= nil then
        error("Sig:NPC_MoveToPos(table stateDir, string context, table pos, number durationMax), 参数错误: pos必须是table类型或nil")
    end
    if type(durationMax) ~= "number" then
        error("Sig:NPC_MoveToPos(table stateDir, string context, table pos, number durationMax), 参数错误: durationMax必须是number类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 以当前位置为防守点进行防守.
---@param stateDir table 朝向 @Terms.Dir
---@param context string 上下文，用于调试日志
function NPC_Defend(stateDir, context)
    if type(stateDir) ~= "table" and stateDir ~= nil then
        error("Sig:NPC_Defend(table stateDir, string context), 参数错误: stateDir必须是table类型或nil")
    end
    if type(context) ~= "string" then
        error("Sig:NPC_Defend(table stateDir, string context),参数错误: context必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 跟随NpcUUID的BattleEntity一起移动.
---@param stateDir table 朝向 @Terms.Dir
---@param context string 上下文，用于调试日志
---@param NpcUUID string @Terms.NpcUUID
function NPC_Follow(stateDir, context, NpcUUID)
    if type(stateDir) ~= "table" and stateDir ~= nil then
        error("Sig:NPC_Follow(table stateDir, string context, string NpcUUID), 参数错误: stateDir必须是table类型或nil")
    end
    if type(context) ~= "string" then
        error("Sig:NPC_Follow(table stateDir, string context, string NpcUUID),参数错误: context必须是string类型")
    end
    if type(NpcUUID) ~= "string" then
        error("Sig:NPC_Follow(table stateDir, string context, string NpcUUID),参数错误: NpcUUID必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 保护名为targetUUID的BattleEntity.
---@param stateDir table 朝向 @Terms.Dir
---@param context string 上下文，用于调试日志
---@param targetUUID string 目标UUID
function NPC_Guard(stateDir, context, targetUUID)
    if type(stateDir) ~= "table" and stateDir ~= nil then
        error("Sig:NPC_Guard(table stateDir, string context, string targetUUID), 参数错误: stateDir必须是table类型或nil")
    end
    if type(context) ~= "string" then
        error("Sig:NPC_Guard(table stateDir, string context, string targetUUID),参数错误: context必须是string类型")
    end
    if type(targetUUID) ~= "string" then
        error("Sig:NPC_Guard(table stateDir, string context, string targetUUID),参数错误: targetUUID必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 追targetUUID的BattleEntity, 到stopDistance停止追击.
---@param stateDir table 朝向 @Terms.Dir
---@param context string 上下文，用于调试日志
---@param targetUUID string 目标UUID
---@param stopDistance number 到stopDistance停止追击
function NPC_Chase(stateDir, context, targetUUID, stopDistance)
    if type(stateDir) ~= "table" and stateDir ~= nil then
        error("Sig:NPC_Chase(table stateDir, string context, string targetUUID, number stopDistance), 参数错误: stateDir必须是table类型或nil")
    end
    if type(context) ~= "string" then
        error("Sig:NPC_Chase(table stateDir, string context, string targetUUID, number stopDistance),参数错误: context必须是string类型")
    end
    if type(targetUUID) ~= "string" then
        error("Sig:NPC_Chase(table stateDir, string context, string targetUUID, number stopDistance),参数错误: targetUUID必须是string类型")
    end
    if type(stopDistance) ~= "number" then
        error("Sig:NPC_Chase(table stateDir, string context, string targetUUID, number stopDistance), 参数错误: stopDistance必须是number类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 朝着名为LocatorID的locator位置边打边撤退, 引诱敌人来追击, 多个LocatorID表示路径点序列，NPC将按顺序逐个移动.
---@param stateDir table 朝向 @Terms.Dir
---@param context string 上下文，用于调试日志
---@param LocatorIDs string... 多个LocatorID表示路径点序列，NPC将按顺序逐个移动,@Terms.LocatorID
function NPC_Lure(stateDir, context, LocatorIDs)
    if type(stateDir) ~= "table" and stateDir ~= nil then
        error("Sig:NPC_Lure(table stateDir, string context, string... LocatorIDs), 参数错误: stateDir必须是table类型或nil")
    end
    if type(context) ~= "string" then
        error("Sig:NPC_Lure(table stateDir, string context, string... LocatorIDs),参数错误: context必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
