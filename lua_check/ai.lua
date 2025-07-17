

-- 使用统一验证模块，专注于API定义
-- 加载统一验证模块
local ValidationModule = require("lua_check.validation")
local validateParam = ValidationModule.validateParam

---@description 作用: 获取UUID为targetNpcUUID实体的所在位置. 如果targetNpcUUID空字符串，则获取自身位置@Terms.Pos.
---@param targetNpcUUID string targetNpcUUID目标，如果空字符串，则为自己
---@return table Pos 位置Pos(table) @Terms.Pos,包含x,y,z三个number类型的字段.
function NPC_GetPos(targetNpcUUID)
    validateParam("targetNpcUUID", targetNpcUUID, "string", "NPC_GetPos")
    validateParam("", nil, "", "NPC_GetPos")
    -- TODO: Implement the function logic here
    return {x=0,y=0,z=0}
end
---@description 作用: 获取UUID为targetNpcUUID实体的当前移动速度. 如果targetNpcUUID空字符串，则获取自身速度(米/秒).
---@param targetNpcUUID string targetNpcUUID目标，如果空字符串，则为自己
---@return number speed UUID为targetNpcUUID的自身当前移动速度.
function NPC_GetSpeed(targetNpcUUID)
    validateParam("targetNpcUUID", targetNpcUUID, "string", "NPC_GetSpeed")
    validateParam("", nil, "", "NPC_GetSpeed")
    -- TODO: Implement the function logic here
    return 0
end
---@description 作用: 获取UUID为targetNpcUUID实体的当前血量. 如果targetNpcUUID空字符串，则获取自身血量.
---@param targetNpcUUID string targetNpcUUID目标，如果空字符串，则为自己
---@return number HP UUID为targetNpcUUID的当前血量.
function NPC_GetHP(targetNpcUUID)
    validateParam("targetNpcUUID", targetNpcUUID, "string", "NPC_GetHP")
    validateParam("", nil, "", "NPC_GetHP")
    -- TODO: Implement the function logic here
    return 0
end
---@description 作用: 获取UUID为targetNpcUUID实体的最大血量. 如果targetNpcUUID空字符串，则获取自身最大血量.
---@param targetNpcUUID string targetNpcUUID目标，如果空字符串，则为自己
---@return number MaxHP UUID为targetNpcUUID的最大血量.
function NPC_GetMaxHP(targetNpcUUID)
    validateParam("targetNpcUUID", targetNpcUUID, "string", "NPC_GetMaxHP")
    validateParam("", nil, "", "NPC_GetMaxHP")
    -- TODO: Implement the function logic here
    return 0
end
---@description 作用: 获取UUID为targetNpcUUID实体的当前蓝量. 如果targetNpcUUID空字符串，则获取自身蓝量.
---@param targetNpcUUID string targetNpcUUID目标，如果空字符串，则为自己
---@return number MP UUID为targetNpcUUID的当前蓝量.
function NPC_GetMP(targetNpcUUID)
    validateParam("targetNpcUUID", targetNpcUUID, "string", "NPC_GetMP")
    validateParam("", nil, "", "NPC_GetMP")
    -- TODO: Implement the function logic here
    return 0
end
---@description 作用: 获取targetNpcUUID实体的最大蓝量. 如果targetNpcUUID空字符串，则获取自身最大蓝量.
---@param targetNpcUUID string targetNpcUUID为目标实体，如果空字符串，则为自己
---@return number MaxMP UUID为targetNpcUUID的最大蓝量.
function NPC_GetMaxMP(targetNpcUUID)
    validateParam("targetNpcUUID", targetNpcUUID, "string", "NPC_GetMaxMP")
    validateParam("", nil, "", "NPC_GetMaxMP")
    -- TODO: Implement the function logic here
    return 0
end
---@description 作用: 获取以pos位置为圆心，radius为半径的圆形区域内的敌人总数量.
---@param pos table 圆心位置{x,y,z number} @Terms.Pos
---@param radius number 半径
---@return number Count 圆形区域内的敌人总数量.
function NPC_GetNearbyEnemyCount(pos, radius)
    validateParam("pos", pos, "table", "NPC_GetNearbyEnemyCount")
    validateParam("radius", radius, "number", "NPC_GetNearbyEnemyCount")
    validateParam("", nil, "", "NPC_GetNearbyEnemyCount")
    -- TODO: Implement the function logic here
    return 0
end
---@description 作用: 获取以pos位置为圆心，radius为半径的圆形区域内的所有敌人, 该函数会返回一个BattleEntity的UUID的数组, 距离pos距离越近的BattleEntity在数组中越靠前.
---@param pos table 圆心位置{x,y,z number} @Terms.Pos
---@param radius number 半径
---@return table UUIDs BattleEntity的UUID数组, 距离pos距离越近的在数组中越靠前.
function NPC_GetNearbyEnemies(pos, radius)
    validateParam("pos", pos, "table", "NPC_GetNearbyEnemies")
    validateParam("radius", radius, "number", "NPC_GetNearbyEnemies")
    validateParam("", nil, "", "NPC_GetNearbyEnemies")
    -- TODO: Implement the function logic here
    return {}
end
---@description 作用: 获取以pos位置为圆心，radius为半径的圆形区域内的友军总数量.
---@param pos table 圆心位置{x,y,z number} @Terms.Pos
---@param radius number 半径
---@return number Count 圆形区域内的友军总数量.
function NPC_GetNearbyFriendCount(pos, radius)
    validateParam("pos", pos, "table", "NPC_GetNearbyFriendCount")
    validateParam("radius", radius, "number", "NPC_GetNearbyFriendCount")
    validateParam("", nil, "", "NPC_GetNearbyFriendCount")
    -- TODO: Implement the function logic here
    return 0
end
---@description 作用: 获取以pos位置为圆心，radius为半径的圆形区域内的所有友军, 该函数会返回一个BattleEntity的UUID数组, 距离pos距离越近的BattleEntity在数组中越靠前.
---@param pos table 圆心位置{x,y,z number} @Terms.Pos
---@param radius number 半径
---@return table UUIDs BattleEntity的UUID数组, 距离pos距离越近的在数组中越靠前.
function NPC_GetNearbyFriends(pos, radius)
    validateParam("pos", pos, "table", "NPC_GetNearbyFriends")
    validateParam("radius", radius, "number", "NPC_GetNearbyFriends")
    validateParam("", nil, "", "NPC_GetNearbyFriends")
    -- TODO: Implement the function logic here
    return {}
end
---@description 作用: 判断名为NpcUUID的BattleEntity是否还活着.
---@param NpcUUID string @Terms.NpcUUID
---@return boolean Alive 是否还活着.
function NPC_IsAlive(NpcUUID)
    validateParam("NpcUUID", NpcUUID, "string", "NPC_IsAlive")
    validateParam("", nil, "", "NPC_IsAlive")
    -- TODO: Implement the function logic here
    return true
end
---@description 作用: 查询自身当前是否在名为LocatorID的locator附近，和该locator距离小于distance时返回true，如果没有指定distance，使用默认值2米.
---@param LocatorID string locator名
---@param distance number 可选, 检测距离，默认值2米
---@return boolean Reached 是否在名为LocatorID的locator附近，和该locator距离小于distance时返回true，如果没有指定distance，使用默认值2米.
function NPC_IsReached(LocatorID, distance)
    validateParam("LocatorID", LocatorID, "string", "NPC_IsReached")
    validateParam("distance", distance, "number", "NPC_IsReached")
    validateParam("", nil, "", "NPC_IsReached")
    -- TODO: Implement the function logic here
    return true
end
---@description 作用: 从小黑板读信息.
---@param key string key
---@return string value 小黑板读信息.
function NPC_BlackboardGet(key)
    validateParam("key", key, "string", "NPC_BlackboardGet")
    validateParam("", nil, "", "NPC_BlackboardGet")
    -- TODO: Implement the function logic here
    return "UnitTestReturnString"
end
---@description 作用: 获取技能名为SkillTID的技能的施法距离.
---@param SkillTID string 技能名@Terms.SkillTID
---@return number Range 技能的施法距离.
function NPC_GetSkillCastRange(SkillTID)
    validateParam("SkillTID", SkillTID, "string", "NPC_GetSkillCastRange")
    validateParam("", nil, "", "NPC_GetSkillCastRange")
    -- TODO: Implement the function logic here
    return 0
end
---@description 作用: 选择自己range范围内最近的一个目标，返回目标(BattleEntity)的UUID.
---@param radius number 范围
---@return string targetNpcUUID 目标UUID
function NPC_AutoSelectTarget(radius)
    validateParam("radius", radius, "number", "NPC_AutoSelectTarget")
    validateParam("", nil, "", "NPC_AutoSelectTarget")
    -- TODO: Implement the function logic here
    return "UnitTestReturnString"
end
---@description 作用: 获取以center为圆心radius为半径的圆形内的一个随机位置.
---@param center table 圆心位置{x,y,z number} @Terms.Pos
---@param radius number 半径
---@return table Pos 中心center,半径radius的圆形内的一个随机位置{x,y,z number} @Terms.Pos
function NPC_GetRandomPos(center, radius)
    validateParam("center", center, "table", "NPC_GetRandomPos")
    validateParam("radius", radius, "number", "NPC_GetRandomPos")
    validateParam("", nil, "", "NPC_GetRandomPos")
    -- TODO: Implement the function logic here
    return {x=0,y=0,z=0}
end
---@description 作用: 判断targetNpcUUID是否有buffTID的buff以及是否是负面状态.如果targetNpcUUID填空字符串，则表示检测自身.
---@param targetNpcUUID string 目标UUID
---@param buffTID string buffTID
---@return boolean HasBuff 是否有buffTID的buff
---@return boolean IsNegative 是否是负面状态
function NPC_IsBuffed(targetNpcUUID, buffTID)
    validateParam("targetNpcUUID", targetNpcUUID, "string", "NPC_IsBuffed")
    validateParam("buffTID", buffTID, "string", "NPC_IsBuffed")
    validateParam("", nil, "", "NPC_IsBuffed")
    -- TODO: Implement the function logic here
    return true, true
end
---@description 作用: 获取自己存活的时间，单位为毫秒.
---@return number Time 存活的时间，单位为毫秒.
function NPC_GetElapsedTime()
    validateParam("", nil, "", "NPC_GetElapsedTime")
    -- TODO: Implement the function logic here
    return 0
end
---@description 作用: 获取位置a和b间的距离, 单位为米.
---@param a table 位置a{x,y,z number} @Terms.Pos
---@param b table 位置b{x,y,z number} @Terms.Pos
---@return number Distance 位置a和b间的距离, 单位为米.
function NPC_Distance(a, b)
    validateParam("a", a, "table", "NPC_Distance")
    validateParam("b", b, "table", "NPC_Distance")
    validateParam("", nil, "", "NPC_Distance")
    -- TODO: Implement the function logic here
    return 0
end
---@description 作用: 写信息到小黑板,用于跨系统间的string传输，注意value是字符串类型。禁止将闭包或者其他函数写入小黑板.
---@param key string key
---@param value string value
function NPC_BlackboardSet(key, value)
    validateParam("key", key, "string", "NPC_BlackboardSet")
    validateParam("value", value, "string", "NPC_BlackboardSet")
    validateParam("", nil, "", "NPC_BlackboardSet")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 开始或结束无敌状态，无敌状态中不会受到伤害.
---@param enable boolean true表示开始无敌，false表示结束.
function NPC_Invincible(enable)
    validateParam("enable", enable, "boolean", "NPC_Invincible")
    validateParam("", nil, "", "NPC_Invincible")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 让所属NPC说句话.
---@param content string 话的具体内容.
function NPC_Say(content)
    validateParam("content", content, "string", "NPC_Say")
    validateParam("", nil, "", "NPC_Say")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 离开场景，即让所属NPC从当前场景消失不见.
function NPC_Leave()
    validateParam("", nil, "", "NPC_Leave")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 当前NPC释放SkillTID标识的技能.NPC释放技能忽略技能Cooldown和MPCost,必定释放成功，系统必定会选择一个合适的目标，调用者无须关心目标。
---@param SkillTID string 技能名@Terms.SkillTID
function NPC_CastSkill(SkillTID)
    validateParam("SkillTID", SkillTID, "string", "NPC_CastSkill")
    validateParam("", nil, "", "NPC_CastSkill")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 随机返回一个当前NPC可以释放的技能@Terms.SkillTID.
---@return string SkillTID 技能名, 参考@Terms.SkillTID
function NPC_RandomAvailableSkill()
    validateParam("", nil, "", "NPC_RandomAvailableSkill")
    -- TODO: Implement the function logic here
    return "UnitTestReturnString"
end
---@description 作用: 调整移动速度.
---@param speed number 期望值，<0表示恢复默认速度.
function NPC_SetSpeed(speed)
    validateParam("speed", speed, "number", "NPC_SetSpeed")
    validateParam("", nil, "", "NPC_SetSpeed")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 开始向名为LocatorID的locator所在位置移动,.
---@param stateDir table 移动终止后的朝向{x,y,z number} @Terms.Dir
---@param context string 上下文，用于调试日志
---@param LocatorID string @Terms.LocatorID
---@param durationMaxMs number 单位毫秒，最多走durationMaxMs毫秒后结束时本次移动
function NPC_MoveToLocator(stateDir, context, LocatorID, durationMaxMs)
    validateParam("stateDir", stateDir, "table", "NPC_MoveToLocator")
    validateParam("context", context, "string", "NPC_MoveToLocator")
    validateParam("LocatorID", LocatorID, "string", "NPC_MoveToLocator")
    validateParam("durationMaxMs", durationMaxMs, "number", "NPC_MoveToLocator")
    validateParam("", nil, "", "NPC_MoveToLocator")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 开始向pos{x,y,z number}位置移动.
---@param stateDir table 移动终止后的朝向{x,y,z number} @Terms.Dir
---@param context string 上下文，用于调试日志
---@param pos table 位置{x,y,z number} @Terms.Pos
---@param durationMaxMs number 最多走durationMaxMs毫秒后结束时本次移动
function NPC_MoveToPos(stateDir, context, pos, durationMaxMs)
    validateParam("stateDir", stateDir, "table", "NPC_MoveToPos")
    validateParam("context", context, "string", "NPC_MoveToPos")
    validateParam("pos", pos, "table", "NPC_MoveToPos")
    validateParam("durationMaxMs", durationMaxMs, "number", "NPC_MoveToPos")
    validateParam("", nil, "", "NPC_MoveToPos")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 以当前位置为防守点进行防守.
---@param stateDir table 移动终止后的朝向{x,y,z number} @Terms.Dir
---@param context string 上下文，用于调试日志
function NPC_Defend(stateDir, context)
    validateParam("stateDir", stateDir, "table", "NPC_Defend")
    validateParam("context", context, "string", "NPC_Defend")
    validateParam("", nil, "", "NPC_Defend")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 跟随NpcUUID的BattleEntity一起移动.
---@param stateDir table 移动终止后的朝向{x,y,z number} @Terms.Dir
---@param context string 上下文，用于调试日志
---@param NpcUUID string @Terms.NpcUUID
function NPC_Follow(stateDir, context, NpcUUID)
    validateParam("stateDir", stateDir, "table", "NPC_Follow")
    validateParam("context", context, "string", "NPC_Follow")
    validateParam("NpcUUID", NpcUUID, "string", "NPC_Follow")
    validateParam("", nil, "", "NPC_Follow")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 保护名为targetNpcUUID的BattleEntity.
---@param stateDir table 移动终止后的朝向{x,y,z number} @Terms.Dir
---@param context string 上下文，用于调试日志
---@param targetNpcUUID string 目标UUID
function NPC_Guard(stateDir, context, targetNpcUUID)
    validateParam("stateDir", stateDir, "table", "NPC_Guard")
    validateParam("context", context, "string", "NPC_Guard")
    validateParam("targetNpcUUID", targetNpcUUID, "string", "NPC_Guard")
    validateParam("", nil, "", "NPC_Guard")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 追targetNpcUUID的BattleEntity, 到stopDistance停止追击.
---@param stateDir table 移动终止后的朝向{x,y,z number} @Terms.Dir
---@param context string 上下文，用于调试日志
---@param targetNpcUUID string 目标UUID
---@param stopDistance number 到stopDistance停止追击
function NPC_Chase(stateDir, context, targetNpcUUID, stopDistance)
    validateParam("stateDir", stateDir, "table", "NPC_Chase")
    validateParam("context", context, "string", "NPC_Chase")
    validateParam("targetNpcUUID", targetNpcUUID, "string", "NPC_Chase")
    validateParam("stopDistance", stopDistance, "number", "NPC_Chase")
    validateParam("", nil, "", "NPC_Chase")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 朝着名为LocatorID的locator位置边打边撤退, 引诱敌人来追击, 多个LocatorID表示路径点序列，NPC将按顺序逐个移动.
---@param stateDir table 移动终止后的朝向{x,y,z number} @Terms.Dir
---@param context string 上下文，用于调试日志
---@param LocatorIDs string[] 多个LocatorID表示路径点序列，NPC将按顺序逐个移动,@Terms.LocatorID
function NPC_Lure(stateDir, context, LocatorIDs)
    validateParam("stateDir", stateDir, "table", "NPC_Lure")
    validateParam("context", context, "string", "NPC_Lure")
    validateParam("LocatorIDs", LocatorIDs, "table", "NPC_Lure")
    validateParam("", nil, "", "NPC_Lure")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 为选中的目标添加buffTID的buff，改变其状态和属性，概率为prob，持续时间为duration毫秒.
---@param NpcUUID string 目标@Terms.NpcUUID
---@param buffTID string Buff的TID@Terms.TID
---@param prob number 概率，0到1之间
---@param duration number 持续时间，单位毫秒
---@param buffArg table 额外参数，根据不同的buff类型有不同的参数, 参考@Terms.buffTID中的参数说明
---@param context string 调用原因@Terms.context
function NPC_AddBuff(NpcUUID, buffTID, prob, duration, buffArg, context)
    validateParam("NpcUUID", NpcUUID, "string", "NPC_AddBuff")
    validateParam("buffTID", buffTID, "string", "NPC_AddBuff")
    validateParam("prob", prob, "number", "NPC_AddBuff")
    validateParam("duration", duration, "number", "NPC_AddBuff")
    validateParam("buffArg", buffArg, "table", "NPC_AddBuff")
    validateParam("context", context, "string", "NPC_AddBuff")
    validateParam("", nil, "", "NPC_AddBuff")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 对目标造成伤害，伤害值为damage,负数为治疗.
---@param NpcUUID string 目标@Terms.NpcUUID
---@param damage number 伤害值,负数为治疗
---@param context string 调用原因@Terms.context
function NPC_DoDamage(NpcUUID, damage, context)
    validateParam("NpcUUID", NpcUUID, "string", "NPC_DoDamage")
    validateParam("damage", damage, "number", "NPC_DoDamage")
    validateParam("context", context, "string", "NPC_DoDamage")
    validateParam("", nil, "", "NPC_DoDamage")
    -- TODO: Implement the function logic here
    return 
end
