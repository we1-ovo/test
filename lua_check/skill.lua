

-- 使用统一验证模块，专注于API定义
-- 加载统一验证模块
local ValidationModule = require("lua_check.validation")
local validateParam = ValidationModule.validateParam

---@description 作用: 设置技能魔法消耗为cost.此API仅对Player生效，NPC释放技能不消耗魔法.
---@param cost number 魔法消耗值
---@param context string 调用原因@Terms.context
function Skill_SetMPCost(cost, context)
    validateParam("cost", cost, "number", "Skill_SetMPCost")
    validateParam("context", context, "string", "Skill_SetMPCost")
    validateParam("", nil, "", "Skill_SetMPCost")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 设置技能冷却时间(毫秒)为cooldown.NPC释放技能不考虑，给player使用.
---@param cooldown number 冷却时间(单位毫秒)
---@param context string 调用原因@Terms.context
function Skill_SetCooldown(cooldown, context)
    validateParam("cooldown", cooldown, "number", "Skill_SetCooldown")
    validateParam("context", context, "string", "Skill_SetCooldown")
    validateParam("", nil, "", "Skill_SetCooldown")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 设置技能施法范围为range,0只能选择自身.
---@param range number 施法范围,0只能选择自身
---@param context string 调用原因@Terms.context
function Skill_SetCastRange(range, context)
    validateParam("range", range, "number", "Skill_SetCastRange")
    validateParam("context", context, "string", "Skill_SetCastRange")
    validateParam("", nil, "", "Skill_SetCastRange")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 设置技能主目标类型为targetType，决定技能对哪种类型的单位释放.
---@param targetType string 目标类型，可选值为'enemy'、'friend'、'self'
---@param context string 调用原因@Terms.context
function Skill_SetMainTargetType(targetType, context)
    validateParam("targetType", targetType, "string", "Skill_SetMainTargetType")
    validateParam("context", context, "string", "Skill_SetMainTargetType")
    validateParam("", nil, "", "Skill_SetMainTargetType")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 设置技能描述为desc.
---@param desc string 技能描述文本
---@param context string 调用原因@Terms.context
function Skill_SetDesc(desc, context)
    validateParam("desc", desc, "string", "Skill_SetDesc")
    validateParam("context", context, "string", "Skill_SetDesc")
    validateParam("", nil, "", "Skill_SetDesc")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 选择主目标.
---@param context string 调用原因@Terms.context
function Skill_CollectMainTarget(context)
    validateParam("context", context, "string", "Skill_CollectMainTarget")
    validateParam("", nil, "", "Skill_CollectMainTarget")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 选择圆形区域半径为radius米的目标，最多maxCount个.
---@param radius number 圆形区域半径(米)
---@param maxCount number 最大目标数量
---@param context string 调用原因@Terms.context
function Skill_CollectCircleTargets(radius, maxCount, context)
    validateParam("radius", radius, "number", "Skill_CollectCircleTargets")
    validateParam("maxCount", maxCount, "number", "Skill_CollectCircleTargets")
    validateParam("context", context, "string", "Skill_CollectCircleTargets")
    validateParam("", nil, "", "Skill_CollectCircleTargets")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 选择扇形区域半径为radius夹角为angle的目标，最多maxCount个.
---@param radius number 扇形区域半径
---@param angle number 扇形夹角
---@param maxCount number 最大目标数量
---@param context string 调用原因@Terms.context
function Skill_CollectSectorTargets(radius, angle, maxCount, context)
    validateParam("radius", radius, "number", "Skill_CollectSectorTargets")
    validateParam("angle", angle, "number", "Skill_CollectSectorTargets")
    validateParam("maxCount", maxCount, "number", "Skill_CollectSectorTargets")
    validateParam("context", context, "string", "Skill_CollectSectorTargets")
    validateParam("", nil, "", "Skill_CollectSectorTargets")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 选择自己朝向的长方形区域宽为width高为height的目标，最多maxCount个.
---@param width number 长方形宽度
---@param height number 长方形高度
---@param maxCount number 最大目标数量
---@param prefabStr string 预制体名称，当前仅支持空字符串
---@param context string 调用原因@Terms.context
function Skill_CollectRectangleTargets(width, height, maxCount, prefabStr, context)
    validateParam("width", width, "number", "Skill_CollectRectangleTargets")
    validateParam("height", height, "number", "Skill_CollectRectangleTargets")
    validateParam("maxCount", maxCount, "number", "Skill_CollectRectangleTargets")
    validateParam("prefabStr", prefabStr, "string", "Skill_CollectRectangleTargets")
    validateParam("context", context, "string", "Skill_CollectRectangleTargets")
    validateParam("", nil, "", "Skill_CollectRectangleTargets")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 选择目标方向的长方形区域宽为width高为height的目标，最多maxCount个.
---@param width number 长方形宽度
---@param height number 长方形高度
---@param maxCount number 最大目标数量
---@param prefabStr string 预制体名称，当前仅支持空字符串
---@param context string 调用原因@Terms.context
function Skill_CollectDirRectangleTargets(width, height, maxCount, prefabStr, context)
    validateParam("width", width, "number", "Skill_CollectDirRectangleTargets")
    validateParam("height", height, "number", "Skill_CollectDirRectangleTargets")
    validateParam("maxCount", maxCount, "number", "Skill_CollectDirRectangleTargets")
    validateParam("prefabStr", prefabStr, "string", "Skill_CollectDirRectangleTargets")
    validateParam("context", context, "string", "Skill_CollectDirRectangleTargets")
    validateParam("", nil, "", "Skill_CollectDirRectangleTargets")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 依次选择距离上个目标半径为radius的最近目标，最多选择maxCount个目标.
---@param radius number 区域半径
---@param maxCount number 最大目标数量
---@param context string 调用原因@Terms.context
function Skill_CollectNearbyTargets(radius, maxCount, context)
    validateParam("radius", radius, "number", "Skill_CollectNearbyTargets")
    validateParam("maxCount", maxCount, "number", "Skill_CollectNearbyTargets")
    validateParam("context", context, "string", "Skill_CollectNearbyTargets")
    validateParam("", nil, "", "Skill_CollectNearbyTargets")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 为选中的敌人目标添加buffTID的buff，概率为prob，持续时间(单位毫秒)为duration.
---@param buffTID string Buff的TID@Terms.TID
---@param prob number 概率，0到1之间
---@param duration number 持续时间(单位毫秒)
---@param buffArg table 额外参数，根据不同的buff类型有不同的参数, 参考@Terms.buffTID中的参数说明
---@param context string 调用原因@Terms.context
function Skill_TargetEnemyAddBuff(buffTID, prob, duration, buffArg, context)
    validateParam("buffTID", buffTID, "string", "Skill_TargetEnemyAddBuff")
    validateParam("prob", prob, "number", "Skill_TargetEnemyAddBuff")
    validateParam("duration", duration, "number", "Skill_TargetEnemyAddBuff")
    validateParam("buffArg", buffArg, "table", "Skill_TargetEnemyAddBuff")
    validateParam("context", context, "string", "Skill_TargetEnemyAddBuff")
    validateParam("", nil, "", "Skill_TargetEnemyAddBuff")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 为选中的友方目标添加buffTID的buff，概率为prob，持续时间(单位毫秒)为duration.
---@param buffTID string Buff的TID@Terms.TID
---@param prob number 概率，0到1之间
---@param duration number 持续时间(单位毫秒)
---@param buffArg table 额外参数，根据不同的buff类型有不同的参数 @Terms.buffTID
---@param context string 调用原因@Terms.context
function Skill_TargetFriendAddBuff(buffTID, prob, duration, buffArg, context)
    validateParam("buffTID", buffTID, "string", "Skill_TargetFriendAddBuff")
    validateParam("prob", prob, "number", "Skill_TargetFriendAddBuff")
    validateParam("duration", duration, "number", "Skill_TargetFriendAddBuff")
    validateParam("buffArg", buffArg, "table", "Skill_TargetFriendAddBuff")
    validateParam("context", context, "string", "Skill_TargetFriendAddBuff")
    validateParam("", nil, "", "Skill_TargetFriendAddBuff")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 为自己添加buffTID的buff，概率为prob，持续时间(单位毫秒)为duration.
---@param buffTID string Buff的TID@Terms.TID
---@param prob number 概率，0到1之间
---@param duration number 持续时间(单位毫秒)
---@param buffArg table 额外参数，根据不同的buff类型有不同的参数 @Terms.buffTID
---@param context string 调用原因@Terms.context
function Skill_SelfAddBuff(buffTID, prob, duration, buffArg, context)
    validateParam("buffTID", buffTID, "string", "Skill_SelfAddBuff")
    validateParam("prob", prob, "number", "Skill_SelfAddBuff")
    validateParam("duration", duration, "number", "Skill_SelfAddBuff")
    validateParam("buffArg", buffArg, "table", "Skill_SelfAddBuff")
    validateParam("context", context, "string", "Skill_SelfAddBuff")
    validateParam("", nil, "", "Skill_SelfAddBuff")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 清除所有负面状态.
---@param context string 调用原因@Terms.context
function Skill_ClearAllDeBuff(context)
    validateParam("context", context, "string", "Skill_ClearAllDeBuff")
    validateParam("", nil, "", "Skill_ClearAllDeBuff")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 对选中目标造成伤害，伤害类型为damageType，伤害值为自己攻击力的scale倍.
---@param damageType string 伤害类型 @Terms.damageType
---@param scale number 伤害倍率，相对于自己攻击力
---@param context string 调用原因@Terms.context
function Skill_TargetScaleDamage(damageType, scale, context)
    validateParam("damageType", damageType, "string", "Skill_TargetScaleDamage")
    validateParam("scale", scale, "number", "Skill_TargetScaleDamage")
    validateParam("context", context, "string", "Skill_TargetScaleDamage")
    validateParam("", nil, "", "Skill_TargetScaleDamage")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 对选中目标造成伤害，伤害类型为damageType，伤害值为damage.
---@param damageType string 伤害类型 @Terms.damageType
---@param damage number 伤害值
---@param context string 调用原因@Terms.context
function Skill_TargetDamage(damageType, damage, context)
    validateParam("damageType", damageType, "string", "Skill_TargetDamage")
    validateParam("damage", damage, "number", "Skill_TargetDamage")
    validateParam("context", context, "string", "Skill_TargetDamage")
    validateParam("", nil, "", "Skill_TargetDamage")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 对选中目标造成伤害，伤害类型为damageType，伤害值为目标最大生命值的damagePercent%.
---@param damageType string 伤害类型 @Terms.damageType
---@param damagePercent number 目标最大生命值的百分比，0到100之间
---@param context string 调用原因@Terms.context
function Skill_TargetMaxHpDamage(damageType, damagePercent, context)
    validateParam("damageType", damageType, "string", "Skill_TargetMaxHpDamage")
    validateParam("damagePercent", damagePercent, "number", "Skill_TargetMaxHpDamage")
    validateParam("context", context, "string", "Skill_TargetMaxHpDamage")
    validateParam("", nil, "", "Skill_TargetMaxHpDamage")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 对自己造成伤害，伤害类型为damageType，伤害值为damage，填写负数则为治疗.
---@param damageType string 伤害类型 @Terms.damageType
---@param damage number 伤害值，负数为治疗
---@param context string 调用原因@Terms.context
function Skill_SelfDamage(damageType, damage, context)
    validateParam("damageType", damageType, "string", "Skill_SelfDamage")
    validateParam("damage", damage, "number", "Skill_SelfDamage")
    validateParam("context", context, "string", "Skill_SelfDamage")
    validateParam("", nil, "", "Skill_SelfDamage")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 创建一个向**自己前方**（根据偏移角度和距离调整后）匀速移动的子物体
---@param speed number 初始速度,米/秒
---@param duration number 持续时间(单位毫秒)
---@param offsetAngle number 偏移角度，0为正前方
---@param offset number 在水平面上与dir垂直的向量偏移距离（正值为右方偏移）
---@param prefabStr string 子物体的prefab名字，为空为默认子物体, 当前仅支持空字符串
---@param context string 调用原因@Terms.context
function Skill_CreateCVSubObjToDir(speed, duration, offsetAngle, offset, prefabStr, context)
    validateParam("speed", speed, "number", "Skill_CreateCVSubObjToDir")
    validateParam("duration", duration, "number", "Skill_CreateCVSubObjToDir")
    validateParam("offsetAngle", offsetAngle, "number", "Skill_CreateCVSubObjToDir")
    validateParam("offset", offset, "number", "Skill_CreateCVSubObjToDir")
    validateParam("prefabStr", prefabStr, "string", "Skill_CreateCVSubObjToDir")
    validateParam("context", context, "string", "Skill_CreateCVSubObjToDir")
    validateParam("", nil, "", "Skill_CreateCVSubObjToDir")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 创建一个向目标移动的子物体.
---@param speed number 初始速度(米/秒)
---@param prefabStr string 子物体的prefab名字，为空为默认子物体, 当前仅支持空字符串
---@param context string 调用原因@Terms.context
function Skill_CreateCVSubObjToTarget(speed, prefabStr, context)
    validateParam("speed", speed, "number", "Skill_CreateCVSubObjToTarget")
    validateParam("prefabStr", prefabStr, "string", "Skill_CreateCVSubObjToTarget")
    validateParam("context", context, "string", "Skill_CreateCVSubObjToTarget")
    validateParam("", nil, "", "Skill_CreateCVSubObjToTarget")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 创建一个围绕自己移动的子物体,顺时针旋转,outSpeed为0时为圆形，否则为螺旋线.
---@param speed number 初始速度（每秒旋转的角度1~360）
---@param duration number 持续时间(单位毫秒)
---@param radius number 距离自己的半径，米
---@param offsetAngle number 偏移角度，0为正前方
---@param outSpeed number 子物体远离自己的速度，>0为远离，<0为靠近，=0则不远离
---@param context string 调用原因@Terms.context
function Skill_CreateSelfCircleSubObj(speed, duration, radius, offsetAngle, outSpeed, context)
    validateParam("speed", speed, "number", "Skill_CreateSelfCircleSubObj")
    validateParam("duration", duration, "number", "Skill_CreateSelfCircleSubObj")
    validateParam("radius", radius, "number", "Skill_CreateSelfCircleSubObj")
    validateParam("offsetAngle", offsetAngle, "number", "Skill_CreateSelfCircleSubObj")
    validateParam("outSpeed", outSpeed, "number", "Skill_CreateSelfCircleSubObj")
    validateParam("context", context, "string", "Skill_CreateSelfCircleSubObj")
    validateParam("", nil, "", "Skill_CreateSelfCircleSubObj")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 在目标位置创建一个静止的子物体.
---@param duration number 持续时间(单位毫秒)，为0则永久存在
---@param context string 调用原因@Terms.context
function Skill_CreateStaticSubObjAtTargetPos(duration, context)
    validateParam("duration", duration, "number", "Skill_CreateStaticSubObjAtTargetPos")
    validateParam("context", context, "string", "Skill_CreateStaticSubObjAtTargetPos")
    validateParam("", nil, "", "Skill_CreateStaticSubObjAtTargetPos")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 在自己脚下创建一个静止的子物体.
---@param duration number 持续时间(单位毫秒)，为0则永久存在
---@param context string 调用原因@Terms.context
function Skill_CreateStaticSubObjAtSelfPos(duration, context)
    validateParam("duration", duration, "number", "Skill_CreateStaticSubObjAtSelfPos")
    validateParam("context", context, "string", "Skill_CreateStaticSubObjAtSelfPos")
    validateParam("", nil, "", "Skill_CreateStaticSubObjAtSelfPos")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 设置子物体的位置{x,y,z}.
---@param Pos table 位置坐标参考@Terms.Pos，table{'x': number, 'y': number, 'z': number}
---@param context string 调用原因@Terms.context
function SubObj_SetPos(Pos, context)
    validateParam("Pos", Pos, "table", "SubObj_SetPos")
    validateParam("context", context, "string", "SubObj_SetPos")
    validateParam("", nil, "", "SubObj_SetPos")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 设置子物体的朝向{x,y,z}.
---@param dir table 方向向量,参考@Terms.Dir，table{'x': number, 'y': number, 'z': number}
---@param context string 调用原因@Terms.context
function SubObj_SetDir(dir, context)
    validateParam("dir", dir, "table", "SubObj_SetDir")
    validateParam("context", context, "string", "SubObj_SetDir")
    validateParam("", nil, "", "SubObj_SetDir")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 设置子物体的大小.
---@param size string 大小，可选值为'small', 'normal', 'big'
---@param context string 调用原因@Terms.context
function SubObj_SetSize(size, context)
    validateParam("size", size, "string", "SubObj_SetSize")
    validateParam("context", context, "string", "SubObj_SetSize")
    validateParam("", nil, "", "SubObj_SetSize")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 设置子物体的触发类型，参数参考@Terms.triggerType。
---@param triggerType string 触发类型 @Terms.triggerType。
---@param param number 依赖于@Terms.triggerType。
---@param context string 调用原因@Terms.context
function SubObj_SetTriggerType(triggerType, param, context)
    validateParam("triggerType", triggerType, "string", "SubObj_SetTriggerType")
    validateParam("param", param, "number", "SubObj_SetTriggerType")
    validateParam("context", context, "string", "SubObj_SetTriggerType")
    validateParam("", nil, "", "SubObj_SetTriggerType")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 设置子物体的触发半径.
---@param radius number 触发半径
---@param context string 调用原因@Terms.context
function SubObj_SetTriggerRadius(radius, context)
    validateParam("radius", radius, "number", "SubObj_SetTriggerRadius")
    validateParam("context", context, "string", "SubObj_SetTriggerRadius")
    validateParam("", nil, "", "SubObj_SetTriggerRadius")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 设置子物体的触发伤害.
---@param damageType string 伤害类型 @Terms.damageType
---@param damage number 伤害值
---@param context string 调用原因@Terms.context
function SubObj_SetTriggerDamage(damageType, damage, context)
    validateParam("damageType", damageType, "string", "SubObj_SetTriggerDamage")
    validateParam("damage", damage, "number", "SubObj_SetTriggerDamage")
    validateParam("context", context, "string", "SubObj_SetTriggerDamage")
    validateParam("", nil, "", "SubObj_SetTriggerDamage")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 设置子物体的触发buff.
---@param buffTID string Buff的TID@Terms.TID
---@param prob number 概率，0到1之间
---@param duration number 持续时间(单位毫秒)
---@param buffArg table 额外参数，根据不同的buff类型有不同的参数 @Terms.buffTID
---@param context string 调用原因@Terms.context
function SubObj_SetTriggerBuff(buffTID, prob, duration, buffArg, context)
    validateParam("buffTID", buffTID, "string", "SubObj_SetTriggerBuff")
    validateParam("prob", prob, "number", "SubObj_SetTriggerBuff")
    validateParam("duration", duration, "number", "SubObj_SetTriggerBuff")
    validateParam("buffArg", buffArg, "table", "SubObj_SetTriggerBuff")
    validateParam("context", context, "string", "SubObj_SetTriggerBuff")
    validateParam("", nil, "", "SubObj_SetTriggerBuff")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 朝相对自己面前的angle角度移动，speed为移动速度，移动距离为distance.
---@param angle number 相对自己面前的角度
---@param speed number 移动速度
---@param distance number 移动距离
---@param context string 调用原因@Terms.context
function Skill_MoveTo(angle, speed, distance, context)
    validateParam("angle", angle, "number", "Skill_MoveTo")
    validateParam("speed", speed, "number", "Skill_MoveTo")
    validateParam("distance", distance, "number", "Skill_MoveTo")
    validateParam("context", context, "string", "Skill_MoveTo")
    validateParam("", nil, "", "Skill_MoveTo")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 移动到目标位置，speedScale为自身移动速度的缩放比例.
---@param speedScale number 速度缩放比例
---@param context string 调用原因@Terms.context
function Skill_MoveToTarget(speedScale, context)
    validateParam("speedScale", speedScale, "number", "Skill_MoveToTarget")
    validateParam("context", context, "string", "Skill_MoveToTarget")
    validateParam("", nil, "", "Skill_MoveToTarget")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 瞬间移动到目标位置.
---@param context string 调用原因@Terms.context
function Skill_TeleportToTarget(context)
    validateParam("context", context, "string", "Skill_TeleportToTarget")
    validateParam("", nil, "", "Skill_TeleportToTarget")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 在自己前方2米范围内随机点处召唤类型为NpcTID的NPC.
---@param NpcTID string Npc类型@Terms.NpcTID
---@param context string 调用原因@Terms.context
function Skill_Summon(NpcTID, context)
    validateParam("NpcTID", NpcTID, "string", "Skill_Summon")
    validateParam("context", context, "string", "Skill_Summon")
    validateParam("", nil, "", "Skill_Summon")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 获取自己当前血量.
---@return number HP 自己当前血量
function Skill_GetSelfHP()
    validateParam("", nil, "", "Skill_GetSelfHP")
    -- TODO: Implement the function logic here
    return 0
end
---@description 作用: 获取自己最大血量.
---@return number MaxHP 自己最大血量
function Skill_GetSelfMaxHP()
    validateParam("", nil, "", "Skill_GetSelfMaxHP")
    -- TODO: Implement the function logic here
    return 0
end
---@description 作用: 获取自己的朝向.
---@return table Dir 自己的朝向向量
function Skill_GetSelfDir()
    validateParam("", nil, "", "Skill_GetSelfDir")
    -- TODO: Implement the function logic here
    return {x=0,y=0,z=0}
end
---@description 作用: 获取自己的位置.
---@return table Pos 自己的位置坐标,参考@Terms.Pos
function Skill_GetSelfPos()
    validateParam("", nil, "", "Skill_GetSelfPos")
    -- TODO: Implement the function logic here
    return {x=0,y=0,z=0}
end
---@description 作用: 获取敌人的位置.
---@return table Pos 敌人的位置坐标,参考@Terms.Pos
function Skill_GetEnemyPos()
    validateParam("", nil, "", "Skill_GetEnemyPos")
    -- TODO: Implement the function logic here
    return {x=0,y=0,z=0}
end
---@description 作用: 以目标位置为中心创建一个静止的圆形buff区域.
---@description 说明: 适用于需要在目标位置（如敌人脚下）创建固定区域的场景.
---@param radius number 区域半径，单位为米
---@param duration number 区域持续时间(单位毫秒)
---@param context string 调用原因@Terms.context
function Skill_CreateTargetPosCircleRegion(radius, duration, context)
    validateParam("radius", radius, "number", "Skill_CreateTargetPosCircleRegion")
    validateParam("duration", duration, "number", "Skill_CreateTargetPosCircleRegion")
    validateParam("context", context, "string", "Skill_CreateTargetPosCircleRegion")
    validateParam("", nil, "", "Skill_CreateTargetPosCircleRegion")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 以目标为中心创建一个跟随目标移动的圆形buff区域.
---@description 说明: 适合需要绑定目标（如跟随敌人或友方单位）的动态区域.
---@param radius number 区域半径，单位为米
---@param duration number 区域持续时间(单位毫秒)
---@param context string 调用原因@Terms.context
function Skill_CreateTargetCircleRegion(radius, duration, context)
    validateParam("radius", radius, "number", "Skill_CreateTargetCircleRegion")
    validateParam("duration", duration, "number", "Skill_CreateTargetCircleRegion")
    validateParam("context", context, "string", "Skill_CreateTargetCircleRegion")
    validateParam("", nil, "", "Skill_CreateTargetCircleRegion")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 以自身位置为中心创建一个静止的圆形buff区域.
---@description 说明: 适用于在施法者当前位置创建固定区域的技能.
---@param radius number 区域半径，单位为米
---@param duration number 区域持续时间(单位毫秒)
---@param context string 调用原因@Terms.context
function Skill_CreateSelfPosCircleRegion(radius, duration, context)
    validateParam("radius", radius, "number", "Skill_CreateSelfPosCircleRegion")
    validateParam("duration", duration, "number", "Skill_CreateSelfPosCircleRegion")
    validateParam("context", context, "string", "Skill_CreateSelfPosCircleRegion")
    validateParam("", nil, "", "Skill_CreateSelfPosCircleRegion")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 以自身为中心创建一个跟随自身的圆形buff区域.
---@description 说明: 适合需要围绕施法者移动的buff区域.
---@param radius number 区域半径，单位为米
---@param duration number 区域持续时间(单位毫秒)
---@param context string 调用原因@Terms.context
function Skill_CreateSelfCircleRegion(radius, duration, context)
    validateParam("radius", radius, "number", "Skill_CreateSelfCircleRegion")
    validateParam("duration", duration, "number", "Skill_CreateSelfCircleRegion")
    validateParam("context", context, "string", "Skill_CreateSelfCircleRegion")
    validateParam("", nil, "", "Skill_CreateSelfCircleRegion")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 每秒钟为进入区域的目标增加一个buffTID的buff，如果已经有了则添加失败.
---@param buffTID string Buff的TID@Terms.buffTID
---@param prob number 添加buff的概率，取值范围0到1
---@param duration number buff持续时间(单位毫秒)
---@param buffArg table buff的额外参数，格式参考Terms.buffTID
---@param targetType string 目标类型，可选值'enemy'（敌人）或'friend'（友方）
---@param context string 调用原因@Terms.context
function Region_AddStayBuff(buffTID, prob, duration, buffArg, targetType, context)
    validateParam("buffTID", buffTID, "string", "Region_AddStayBuff")
    validateParam("prob", prob, "number", "Region_AddStayBuff")
    validateParam("duration", duration, "number", "Region_AddStayBuff")
    validateParam("buffArg", buffArg, "table", "Region_AddStayBuff")
    validateParam("targetType", targetType, "string", "Region_AddStayBuff")
    validateParam("context", context, "string", "Region_AddStayBuff")
    validateParam("", nil, "", "Region_AddStayBuff")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 持续释放技能duration毫秒，为了占住技能时间线. 技能的定身，引导，吟唱等时间操作，都可以使用这个函数.
---@param duration number 持续时间(单位毫秒)
---@param context string 调用原因@Terms.context
function Skill_Sleep(duration, context)
    validateParam("duration", duration, "number", "Skill_Sleep")
    validateParam("context", context, "string", "Skill_Sleep")
    validateParam("", nil, "", "Skill_Sleep")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 取消当前技能释放，一般用于event回调函数中.
---@param context string 调用原因@Terms.context
function Skill_Cancel(context)
    validateParam("context", context, "string", "Skill_Cancel")
    validateParam("", nil, "", "Skill_Cancel")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 注册事件，skillEventName为事件名，func为事件处理函数，函数参数查看@Terms.skillEventName。
---@param skillEventName string 事件名 @Terms.skillEventName。
---@param func function 事件处理函数,有参数函数，参数查看@Terms.skillEventName。
---@param context string 调用原因@Terms.context
function Skill_RegisterEvent(skillEventName, func, context)
    validateParam("skillEventName", skillEventName, "string", "Skill_RegisterEvent")
    validateParam("func", func, "function", "Skill_RegisterEvent")
    validateParam("context", context, "string", "Skill_RegisterEvent")
    validateParam("", nil, "", "Skill_RegisterEvent")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 喊话，message为说的内容，duration为持续时间(单位毫秒).
---@param message string 消息内容
---@param duration number 持续时间(单位毫秒)
---@param context string 调用原因@Terms.context
function Skill_Say(message, duration, context)
    validateParam("message", message, "string", "Skill_Say")
    validateParam("duration", duration, "number", "Skill_Say")
    validateParam("context", context, "string", "Skill_Say")
    validateParam("", nil, "", "Skill_Say")
    -- TODO: Implement the function logic here
    return 
end
