---@description 作用: 设置技能魔法消耗为cost.此API只对于player适用, NPC使用技能时跳过此消耗.
---@param cost number 魔法消耗值
---@param context string 调用此API的目的和效果，用于日志记录
function Skill_SetMPCost(cost, context)
    if type(cost) ~= "number" then
        error("Sig:Skill_SetMPCost(cost, context), 参数错误: cost必须是number类型")
    end
    if type(context) ~= "string" then
        error("Sig:Skill_SetMPCost(cost, context),参数错误: context必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 设置技能冷却时间为cooldown.NPC释放技能不考虑，给player使用.
---@param cooldown number 冷却时间（秒）
---@param context string 调用此API的目的和效果，用于日志记录
function Skill_SetCooldown(cooldown, context)
    if type(cooldown) ~= "number" then
        error("Sig:Skill_SetCooldown(cooldown, context), 参数错误: cooldown必须是number类型")
    end
    if type(context) ~= "string" then
        error("Sig:Skill_SetCooldown(cooldown, context),参数错误: context必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 设置技能施法范围为range.
---@param range number 施法范围
---@param context string 调用此API的目的和效果，用于日志记录
function Skill_SetCastRange(range, context)
    if type(range) ~= "number" then
        error("Sig:Skill_SetCastRange(range, context), 参数错误: range必须是number类型")
    end
    if type(context) ~= "string" then
        error("Sig:Skill_SetCastRange(range, context),参数错误: context必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 设置技能主目标类型为targetType，决定技能对哪种类型的单位释放.
---@param targetType string 目标类型，可选值为'enemy'、'friend'、'self'
---@param context string 调用此API的目的和效果，用于日志记录
function Skill_SetMainTargetType(targetType, context)
    if type(targetType) ~= "string" then
        error("Sig:Skill_SetMainTargetType(targetType, context),参数错误: targetType必须是string类型")
    end
    if type(context) ~= "string" then
        error("Sig:Skill_SetMainTargetType(targetType, context),参数错误: context必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 设置技能描述为desc.
---@param desc string 技能描述文本
function Skill_SetDesc(desc)
    if type(desc) ~= "string" then
        error("Sig:Skill_SetDesc(desc),参数错误: desc必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 选择主目标.
---@param context string 调用此API的目的和效果，用于日志记录
function Skill_CollectMainTarget(context)
    if type(context) ~= "string" then
        error("Sig:Skill_CollectMainTarget(context),参数错误: context必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 选择圆形区域半径为radius的目标，最多maxCount个.
---@param radius number 圆形区域半径
---@param maxCount number 最大目标数量
---@param context string 调用此API的目的和效果，用于日志记录
function Skill_CollectCircleTargets(radius, maxCount, context)
    if type(radius) ~= "number" then
        error("Sig:Skill_CollectCircleTargets(radius, maxCount, context), 参数错误: radius必须是number类型")
    end
    if type(maxCount) ~= "number" then
        error("Sig:Skill_CollectCircleTargets(radius, maxCount, context), 参数错误: maxCount必须是number类型")
    end
    if type(context) ~= "string" then
        error("Sig:Skill_CollectCircleTargets(radius, maxCount, context),参数错误: context必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 选择扇形区域半径为radius夹角为angle的目标，最多maxCount个.
---@param radius number 扇形区域半径
---@param angle number 扇形夹角
---@param maxCount number 最大目标数量
---@param context string 调用此API的目的和效果，用于日志记录
function Skill_CollectSectorTargets(radius, angle, maxCount, context)
    if type(radius) ~= "number" then
        error("Sig:Skill_CollectSectorTargets(radius, angle, maxCount, context), 参数错误: radius必须是number类型")
    end
    if type(angle) ~= "number" then
        error("Sig:Skill_CollectSectorTargets(radius, angle, maxCount, context), 参数错误: angle必须是number类型")
    end
    if type(maxCount) ~= "number" then
        error("Sig:Skill_CollectSectorTargets(radius, angle, maxCount, context), 参数错误: maxCount必须是number类型")
    end
    if type(context) ~= "string" then
        error("Sig:Skill_CollectSectorTargets(radius, angle, maxCount, context),参数错误: context必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 选择自己朝向的长方形区域宽为width高为height的目标，最多maxCount个.
---@param width number 长方形宽度
---@param height number 长方形高度
---@param maxCount number 最大目标数量
---@param prefabStr string 预制体名称，当前仅支持空字符串
---@param context string 调用此API的目的和效果，用于日志记录
function Skill_CollectRectangleTargets(width, height, maxCount, prefabStr, context)
    if type(width) ~= "number" then
        error("Sig:Skill_CollectRectangleTargets(width, height, maxCount, prefabStr, context), 参数错误: width必须是number类型")
    end
    if type(height) ~= "number" then
        error("Sig:Skill_CollectRectangleTargets(width, height, maxCount, prefabStr, context), 参数错误: height必须是number类型")
    end
    if type(maxCount) ~= "number" then
        error("Sig:Skill_CollectRectangleTargets(width, height, maxCount, prefabStr, context), 参数错误: maxCount必须是number类型")
    end
    if type(prefabStr) ~= "string" then
        error("Sig:Skill_CollectRectangleTargets(width, height, maxCount, prefabStr, context),参数错误: prefabStr必须是string类型")
    end
    if type(context) ~= "string" then
        error("Sig:Skill_CollectRectangleTargets(width, height, maxCount, prefabStr, context),参数错误: context必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 选择目标方向的的长方形区域宽为width高为height的目标，最多maxCount个.
---@param width number 长方形宽度
---@param height number 长方形高度
---@param maxCount number 最大目标数量
---@param prefabStr string 预制体名称，当前仅支持空字符串
---@param context string 调用此API的目的和效果，用于日志记录
function Skill_CollectDirRectangleTargets(width, height, maxCount, prefabStr, context)
    if type(width) ~= "number" then
        error("Sig:Skill_CollectDirRectangleTargets(width, height, maxCount, prefabStr, context), 参数错误: width必须是number类型")
    end
    if type(height) ~= "number" then
        error("Sig:Skill_CollectDirRectangleTargets(width, height, maxCount, prefabStr, context), 参数错误: height必须是number类型")
    end
    if type(maxCount) ~= "number" then
        error("Sig:Skill_CollectDirRectangleTargets(width, height, maxCount, prefabStr, context), 参数错误: maxCount必须是number类型")
    end
    if type(prefabStr) ~= "string" then
        error("Sig:Skill_CollectDirRectangleTargets(width, height, maxCount, prefabStr, context),参数错误: prefabStr必须是string类型")
    end
    if type(context) ~= "string" then
        error("Sig:Skill_CollectDirRectangleTargets(width, height, maxCount, prefabStr, context),参数错误: context必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 依次选择距离上个目标半径为radius的最近目标，选择maxCount次.
---@param radius number 区域半径
---@param maxCount number 选择次数
---@param context string 调用此API的目的和效果，用于日志记录
function Skill_CollectNearbyTargets(radius, maxCount, context)
    if type(radius) ~= "number" then
        error("Sig:Skill_CollectNearbyTargets(radius, maxCount, context), 参数错误: radius必须是number类型")
    end
    if type(maxCount) ~= "number" then
        error("Sig:Skill_CollectNearbyTargets(radius, maxCount, context), 参数错误: maxCount必须是number类型")
    end
    if type(context) ~= "string" then
        error("Sig:Skill_CollectNearbyTargets(radius, maxCount, context),参数错误: context必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 为选中的敌人目标添加buffTID的buff，概率为prob，持续时间为duration.
---@param buffTID string Buff的TID@Terms.TID
---@param prob number 概率，0到1之间
---@param duration number 持续时间
---@param buffArg table 额外参数，根据不同的buff类型有不同的参数, 参考@Terms.buffTID中的参数说明
---@param context string 调用此API的目的和效果，用于日志记录
function Skill_TargetEnemyAddBuff(buffTID, prob, duration, buffArg, context)
    if type(buffTID) ~= "string" then
        error("Sig:Skill_TargetEnemyAddBuff(buffTID, prob, duration, buffArg, context),参数错误: buffTID必须是string类型")
    end
    if type(prob) ~= "number" then
        error("Sig:Skill_TargetEnemyAddBuff(buffTID, prob, duration, buffArg, context), 参数错误: prob必须是number类型")
    end
    if type(duration) ~= "number" then
        error("Sig:Skill_TargetEnemyAddBuff(buffTID, prob, duration, buffArg, context), 参数错误: duration必须是number类型")
    end
    if type(buffArg) ~= "table" and buffArg ~= nil then
        error("Sig:Skill_TargetEnemyAddBuff(buffTID, prob, duration, buffArg, context), 参数错误: buffArg必须是table类型或nil")
    end
    if type(context) ~= "string" then
        error("Sig:Skill_TargetEnemyAddBuff(buffTID, prob, duration, buffArg, context),参数错误: context必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 为选中的友方目标添加buffTID的buff，概率为prob，持续时间为duration.
---@param buffTID string Buff的TID@Terms.TID
---@param prob number 概率，0到1之间
---@param duration number 持续时间
---@param buffArg table 额外参数，根据不同的buff类型有不同的参数 @Terms.buffTID
---@param context string 调用此API的目的和效果，用于日志记录
function Skill_TargetFriendAddBuff(buffTID, prob, duration, buffArg, context)
    if type(buffTID) ~= "string" then
        error("Sig:Skill_TargetFriendAddBuff(buffTID, prob, duration, buffArg, context),参数错误: buffTID必须是string类型")
    end
    if type(prob) ~= "number" then
        error("Sig:Skill_TargetFriendAddBuff(buffTID, prob, duration, buffArg, context), 参数错误: prob必须是number类型")
    end
    if type(duration) ~= "number" then
        error("Sig:Skill_TargetFriendAddBuff(buffTID, prob, duration, buffArg, context), 参数错误: duration必须是number类型")
    end
    if type(buffArg) ~= "table" and buffArg ~= nil then
        error("Sig:Skill_TargetFriendAddBuff(buffTID, prob, duration, buffArg, context), 参数错误: buffArg必须是table类型或nil")
    end
    if type(context) ~= "string" then
        error("Sig:Skill_TargetFriendAddBuff(buffTID, prob, duration, buffArg, context),参数错误: context必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 为自己添加buffTID的buff，概率为prob，持续时间为duration.
---@param buffTID string Buff的TID@Terms.TID
---@param prob number 概率，0到1之间
---@param duration number 持续时间
---@param buffArg table 额外参数，根据不同的buff类型有不同的参数 @Terms.buffTID
---@param context string 调用此API的目的和效果，用于日志记录
function Skill_SelfAddBuff(buffTID, prob, duration, buffArg, context)
    if type(buffTID) ~= "string" then
        error("Sig:Skill_SelfAddBuff(buffTID, prob, duration, buffArg, context),参数错误: buffTID必须是string类型")
    end
    if type(prob) ~= "number" then
        error("Sig:Skill_SelfAddBuff(buffTID, prob, duration, buffArg, context), 参数错误: prob必须是number类型")
    end
    if type(duration) ~= "number" then
        error("Sig:Skill_SelfAddBuff(buffTID, prob, duration, buffArg, context), 参数错误: duration必须是number类型")
    end
    if type(buffArg) ~= "table" and buffArg ~= nil then
        error("Sig:Skill_SelfAddBuff(buffTID, prob, duration, buffArg, context), 参数错误: buffArg必须是table类型或nil")
    end
    if type(context) ~= "string" then
        error("Sig:Skill_SelfAddBuff(buffTID, prob, duration, buffArg, context),参数错误: context必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 清除所有负面状态.
---@param context string 调用此API的目的和效果，用于日志记录
function Skill_ClearAllDeBuff(context)
    if type(context) ~= "string" then
        error("Sig:Skill_ClearAllDeBuff(context),参数错误: context必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 设置自己是否无敌，enable为true则无敌，false则不无敌.
---@param enable boolean 是否启用无敌
---@param context string 调用此API的目的和效果，用于日志记录
function Skill_Invincible(enable, context)
    if type(enable) ~= "boolean" then
        error("Sig:Skill_Invincible(enable, context), 参数错误: enable必须是boolean类型")
    end
    if type(context) ~= "string" then
        error("Sig:Skill_Invincible(enable, context),参数错误: context必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 对选中目标造成伤害，伤害类型为damageType，伤害值为自己攻击力的scale倍.
---@param damageType string 伤害类型 @Terms.damageType
---@param scale number 伤害倍率，相对于自己攻击力
---@param context string 调用此API的目的和效果，用于日志记录
function Skill_TargetScaleDamage(damageType, scale, context)
    if type(damageType) ~= "string" then
        error("Sig:Skill_TargetScaleDamage(damageType, scale, context),参数错误: damageType必须是string类型")
    end
    if type(scale) ~= "number" then
        error("Sig:Skill_TargetScaleDamage(damageType, scale, context), 参数错误: scale必须是number类型")
    end
    if type(context) ~= "string" then
        error("Sig:Skill_TargetScaleDamage(damageType, scale, context),参数错误: context必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 对选中目标造成伤害，伤害类型为damageType，伤害值为damage.
---@param damageType string 伤害类型 @Terms.damageType
---@param damage number 伤害值
---@param context string 调用此API的目的和效果，用于日志记录
function Skill_TargetDamage(damageType, damage, context)
    if type(damageType) ~= "string" then
        error("Sig:Skill_TargetDamage(damageType, damage, context),参数错误: damageType必须是string类型")
    end
    if type(damage) ~= "number" then
        error("Sig:Skill_TargetDamage(damageType, damage, context), 参数错误: damage必须是number类型")
    end
    if type(context) ~= "string" then
        error("Sig:Skill_TargetDamage(damageType, damage, context),参数错误: context必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 对选中目标造成伤害，伤害类型为damageType，伤害值为目标最大生命值的damagePercent%.
---@param damageType string 伤害类型 @Terms.damageType
---@param damagePercent number 目标最大生命值的百分比，0到100之间
---@param context string 调用此API的目的和效果，用于日志记录
function Skill_TargetMaxHpDamage(damageType, damagePercent, context)
    if type(damageType) ~= "string" then
        error("Sig:Skill_TargetMaxHpDamage(damageType, damagePercent, context),参数错误: damageType必须是string类型")
    end
    if type(damagePercent) ~= "number" then
        error("Sig:Skill_TargetMaxHpDamage(damageType, damagePercent, context), 参数错误: damagePercent必须是number类型")
    end
    if type(context) ~= "string" then
        error("Sig:Skill_TargetMaxHpDamage(damageType, damagePercent, context),参数错误: context必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 对自己造成伤害，伤害类型为damageType，伤害值为damage，填写负数则为治疗.
---@param damageType string 伤害类型 @Terms.damageType
---@param damage number 伤害值，负数为治疗
---@param context string 调用此API的目的和效果，用于日志记录
function Skill_SelfDamage(damageType, damage, context)
    if type(damageType) ~= "string" then
        error("Sig:Skill_SelfDamage(damageType, damage, context),参数错误: damageType必须是string类型")
    end
    if type(damage) ~= "number" then
        error("Sig:Skill_SelfDamage(damageType, damage, context), 参数错误: damage必须是number类型")
    end
    if type(context) ~= "string" then
        error("Sig:Skill_SelfDamage(damageType, damage, context),参数错误: context必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 创建一个向目标方向匀速移动的子物体.
---@param speed number 初始速度
---@param duration number 持续时间
---@param offAngle number 偏移角度，0为正前方
---@param offPos number 与dir垂直的向量偏移距离
---@param prefabStr string 子物体的prefab名字，为空为默认子物体, 当前仅支持空字符串
---@param context string 调用此API的目的和效果，用于日志记录
function Skill_CreateCVSubObjToDir(speed, duration, offAngle, offPos, prefabStr, context)
    if type(speed) ~= "number" then
        error("Sig:Skill_CreateCVSubObjToDir(speed, duration, offAngle, offPos, prefabStr, context), 参数错误: speed必须是number类型")
    end
    if type(duration) ~= "number" then
        error("Sig:Skill_CreateCVSubObjToDir(speed, duration, offAngle, offPos, prefabStr, context), 参数错误: duration必须是number类型")
    end
    if type(offAngle) ~= "number" then
        error("Sig:Skill_CreateCVSubObjToDir(speed, duration, offAngle, offPos, prefabStr, context), 参数错误: offAngle必须是number类型")
    end
    if type(offPos) ~= "number" then
        error("Sig:Skill_CreateCVSubObjToDir(speed, duration, offAngle, offPos, prefabStr, context), 参数错误: offPos必须是number类型")
    end
    if type(prefabStr) ~= "string" then
        error("Sig:Skill_CreateCVSubObjToDir(speed, duration, offAngle, offPos, prefabStr, context),参数错误: prefabStr必须是string类型")
    end
    if type(context) ~= "string" then
        error("Sig:Skill_CreateCVSubObjToDir(speed, duration, offAngle, offPos, prefabStr, context),参数错误: context必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 创建一个向目标移动的子物体.
---@param speed number 初始速度(米/秒)
---@param prefabStr string 子物体的prefab名字，为空为默认子物体, 当前仅支持空字符串
---@param context string 调用此API的目的和效果，用于日志记录
function Skill_CreateCVSubObjToTarget(speed, prefabStr, context)
    if type(speed) ~= "number" then
        error("Sig:Skill_CreateCVSubObjToTarget(speed, prefabStr, context), 参数错误: speed必须是number类型")
    end
    if type(prefabStr) ~= "string" then
        error("Sig:Skill_CreateCVSubObjToTarget(speed, prefabStr, context),参数错误: prefabStr必须是string类型")
    end
    if type(context) ~= "string" then
        error("Sig:Skill_CreateCVSubObjToTarget(speed, prefabStr, context),参数错误: context必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 创建一个围绕自己移动的子物体,顺时针旋转,outSpeed为0时为圆形，否则为螺旋线.
---@param speed number 初始速度（每秒旋转的角度1~360）
---@param duration number 持续时间,秒
---@param radius number 距离自己的半径，米
---@param offAngle number 偏移角度，0为正前方
---@param outSpeed number 子物体远离自己的速度，>0为远离，<0为靠近，=0则不远离
---@param context string 调用此API的目的和效果，用于日志记录
function Skill_CreateSelfCircleSubObj(speed, duration, radius, offAngle, outSpeed, context)
    if type(speed) ~= "number" then
        error("Sig:Skill_CreateSelfCircleSubObj(speed, duration, radius, offAngle, outSpeed, context), 参数错误: speed必须是number类型")
    end
    if type(duration) ~= "number" then
        error("Sig:Skill_CreateSelfCircleSubObj(speed, duration, radius, offAngle, outSpeed, context), 参数错误: duration必须是number类型")
    end
    if type(radius) ~= "number" then
        error("Sig:Skill_CreateSelfCircleSubObj(speed, duration, radius, offAngle, outSpeed, context), 参数错误: radius必须是number类型")
    end
    if type(offAngle) ~= "number" then
        error("Sig:Skill_CreateSelfCircleSubObj(speed, duration, radius, offAngle, outSpeed, context), 参数错误: offAngle必须是number类型")
    end
    if type(outSpeed) ~= "number" then
        error("Sig:Skill_CreateSelfCircleSubObj(speed, duration, radius, offAngle, outSpeed, context), 参数错误: outSpeed必须是number类型")
    end
    if type(context) ~= "string" then
        error("Sig:Skill_CreateSelfCircleSubObj(speed, duration, radius, offAngle, outSpeed, context),参数错误: context必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 在目标位置创建一个静止的子物体.
---@param duration number 持续时间，为0则永久存在
---@param context string 调用此API的目的和效果，用于日志记录
function Skill_CreateStaticSubObjAtTargetPos(duration, context)
    if type(duration) ~= "number" then
        error("Sig:Skill_CreateStaticSubObjAtTargetPos(duration, context), 参数错误: duration必须是number类型")
    end
    if type(context) ~= "string" then
        error("Sig:Skill_CreateStaticSubObjAtTargetPos(duration, context),参数错误: context必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 在自己脚下创建一个静止的子物体.
---@param duration number 持续时间，为0则永久存在
---@param context string 调用此API的目的和效果，用于日志记录
function Skill_CreateStaticSubObjAtSelfPos(duration, context)
    if type(duration) ~= "number" then
        error("Sig:Skill_CreateStaticSubObjAtSelfPos(duration, context), 参数错误: duration必须是number类型")
    end
    if type(context) ~= "string" then
        error("Sig:Skill_CreateStaticSubObjAtSelfPos(duration, context),参数错误: context必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 设置子物体的位置{x,y,z}.
---@param Pos table 位置坐标参考@Terms.Pos，table{'x': number, 'y': number, 'z': number}
function SubObj_SetPos(Pos)
    if type(Pos) ~= "table" and Pos ~= nil then
        error("Sig:SubObj_SetPos(Pos), 参数错误: Pos必须是table类型或nil")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 设置子物体的朝向{x,y,z}.
---@param dir table 方向向量,参考@Terms.Dir，table{'x': number, 'y': number, 'z': number}
function SubObj_SetDir(dir)
    if type(dir) ~= "table" and dir ~= nil then
        error("Sig:SubObj_SetDir(dir), 参数错误: dir必须是table类型或nil")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 设置子物体的大小.
---@param size string 大小，可选值为'small', 'normal', 'big'
---@param context string 调用此API的目的和效果，用于日志记录
function SubObj_SetSize(size, context)
    if type(size) ~= "string" then
        error("Sig:SubObj_SetSize(size, context),参数错误: size必须是string类型")
    end
    if type(context) ~= "string" then
        error("Sig:SubObj_SetSize(size, context),参数错误: context必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 设置子物体的触发类型.
---@param triggerType string 触发类型 @Terms.triggerType
---@param param number 依赖于triggerType, 是trigger_collision时,param为触发次数，为0则无限制; 为trigger_delay时，param延迟触发时间(毫秒)
---@param context string 调用此API的目的和效果，用于日志记录
function SubObj_SetTriggerType(triggerType, param, context)
    if type(triggerType) ~= "string" then
        error("Sig:SubObj_SetTriggerType(triggerType, param, context),参数错误: triggerType必须是string类型")
    end
    if type(param) ~= "number" then
        error("Sig:SubObj_SetTriggerType(triggerType, param, context), 参数错误: param必须是number类型")
    end
    if type(context) ~= "string" then
        error("Sig:SubObj_SetTriggerType(triggerType, param, context),参数错误: context必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 设置子物体的触发半径.
---@param radius number 触发半径
---@param context string 调用此API的目的和效果，用于日志记录
function SubObj_SetTriggerRadius(radius, context)
    if type(radius) ~= "number" then
        error("Sig:SubObj_SetTriggerRadius(radius, context), 参数错误: radius必须是number类型")
    end
    if type(context) ~= "string" then
        error("Sig:SubObj_SetTriggerRadius(radius, context),参数错误: context必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 设置子物体的触发伤害.
---@param damageType string 伤害类型 @Terms.damageType
---@param damage number 伤害值
---@param context string 调用此API的目的和效果，用于日志记录
function SubObj_SetTriggerDamage(damageType, damage, context)
    if type(damageType) ~= "string" then
        error("Sig:SubObj_SetTriggerDamage(damageType, damage, context),参数错误: damageType必须是string类型")
    end
    if type(damage) ~= "number" then
        error("Sig:SubObj_SetTriggerDamage(damageType, damage, context), 参数错误: damage必须是number类型")
    end
    if type(context) ~= "string" then
        error("Sig:SubObj_SetTriggerDamage(damageType, damage, context),参数错误: context必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 设置子物体的触发buff.
---@param buffTID string Buff的TID@Terms.TID
---@param prob number 概率，0到1之间
---@param duration number 持续时间
---@param buffArg table 额外参数，根据不同的buff类型有不同的参数 @Terms.buffTID
---@param context string 调用此API的目的和效果，用于日志记录
function SubObj_SetTriggerBuff(buffTID, prob, duration, buffArg, context)
    if type(buffTID) ~= "string" then
        error("Sig:SubObj_SetTriggerBuff(buffTID, prob, duration, buffArg, context),参数错误: buffTID必须是string类型")
    end
    if type(prob) ~= "number" then
        error("Sig:SubObj_SetTriggerBuff(buffTID, prob, duration, buffArg, context), 参数错误: prob必须是number类型")
    end
    if type(duration) ~= "number" then
        error("Sig:SubObj_SetTriggerBuff(buffTID, prob, duration, buffArg, context), 参数错误: duration必须是number类型")
    end
    if type(buffArg) ~= "table" and buffArg ~= nil then
        error("Sig:SubObj_SetTriggerBuff(buffTID, prob, duration, buffArg, context), 参数错误: buffArg必须是table类型或nil")
    end
    if type(context) ~= "string" then
        error("Sig:SubObj_SetTriggerBuff(buffTID, prob, duration, buffArg, context),参数错误: context必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 以目标的坐标创建一个圆形区域.
---@param radius number 区域半径
---@param duration number 持续时间
---@param context string 调用此API的目的和效果，用于日志记录
function Skill_CreateTargetPosCircleRegion(radius, duration, context)
    if type(radius) ~= "number" then
        error("Sig:Skill_CreateTargetPosCircleRegion(radius, duration, context), 参数错误: radius必须是number类型")
    end
    if type(duration) ~= "number" then
        error("Sig:Skill_CreateTargetPosCircleRegion(radius, duration, context), 参数错误: duration必须是number类型")
    end
    if type(context) ~= "string" then
        error("Sig:Skill_CreateTargetPosCircleRegion(radius, duration, context),参数错误: context必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 以目标创建一个圆形区域，区域跟随目标.
---@param radius number 区域半径
---@param duration number 持续时间
---@param context string 调用此API的目的和效果，用于日志记录
function Skill_CreateTargetCircleRegion(radius, duration, context)
    if type(radius) ~= "number" then
        error("Sig:Skill_CreateTargetCircleRegion(radius, duration, context), 参数错误: radius必须是number类型")
    end
    if type(duration) ~= "number" then
        error("Sig:Skill_CreateTargetCircleRegion(radius, duration, context), 参数错误: duration必须是number类型")
    end
    if type(context) ~= "string" then
        error("Sig:Skill_CreateTargetCircleRegion(radius, duration, context),参数错误: context必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 以自己的坐标创建一个圆形区域.
---@param radius number 区域半径
---@param duration number 持续时间
---@param context string 调用此API的目的和效果，用于日志记录
function Skill_CreateSelfPosCircleRegion(radius, duration, context)
    if type(radius) ~= "number" then
        error("Sig:Skill_CreateSelfPosCircleRegion(radius, duration, context), 参数错误: radius必须是number类型")
    end
    if type(duration) ~= "number" then
        error("Sig:Skill_CreateSelfPosCircleRegion(radius, duration, context), 参数错误: duration必须是number类型")
    end
    if type(context) ~= "string" then
        error("Sig:Skill_CreateSelfPosCircleRegion(radius, duration, context),参数错误: context必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 以自己创建一个圆形区域，区域跟随自己.
---@param radius number 区域半径
---@param duration number 持续时间
---@param context string 调用此API的目的和效果，用于日志记录
function Skill_CreateSelfCircleRegion(radius, duration, context)
    if type(radius) ~= "number" then
        error("Sig:Skill_CreateSelfCircleRegion(radius, duration, context), 参数错误: radius必须是number类型")
    end
    if type(duration) ~= "number" then
        error("Sig:Skill_CreateSelfCircleRegion(radius, duration, context), 参数错误: duration必须是number类型")
    end
    if type(context) ~= "string" then
        error("Sig:Skill_CreateSelfCircleRegion(radius, duration, context),参数错误: context必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 区域内停留的目标添加buff.
---@param buffTID string Buff的TID@Terms.TID
---@param prob number 概率，0到1之间
---@param duration number 持续时间
---@param buffArg table 额外参数，根据不同的buff类型有不同的参数 @Terms.buffTID
---@param targetType string 目标类型: 'enemy'为敌人，'friend'为友方
---@param context string 调用此API的目的和效果，用于日志记录
function Region_AddStayBuff(buffTID, prob, duration, buffArg, targetType, context)
    if type(buffTID) ~= "string" then
        error("Sig:Region_AddStayBuff(buffTID, prob, duration, buffArg, targetType, context),参数错误: buffTID必须是string类型")
    end
    if type(prob) ~= "number" then
        error("Sig:Region_AddStayBuff(buffTID, prob, duration, buffArg, targetType, context), 参数错误: prob必须是number类型")
    end
    if type(duration) ~= "number" then
        error("Sig:Region_AddStayBuff(buffTID, prob, duration, buffArg, targetType, context), 参数错误: duration必须是number类型")
    end
    if type(buffArg) ~= "table" and buffArg ~= nil then
        error("Sig:Region_AddStayBuff(buffTID, prob, duration, buffArg, targetType, context), 参数错误: buffArg必须是table类型或nil")
    end
    if type(targetType) ~= "string" then
        error("Sig:Region_AddStayBuff(buffTID, prob, duration, buffArg, targetType, context),参数错误: targetType必须是string类型")
    end
    if type(context) ~= "string" then
        error("Sig:Region_AddStayBuff(buffTID, prob, duration, buffArg, targetType, context),参数错误: context必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 朝相对自己面前的angle角度移动，speed为移动速度，移动距离为distance.
---@param angle number 相对自己面前的角度
---@param speed number 移动速度
---@param distance number 移动距离
function Skill_MoveTo(angle, speed, distance)
    if type(angle) ~= "number" then
        error("Sig:Skill_MoveTo(angle, speed, distance), 参数错误: angle必须是number类型")
    end
    if type(speed) ~= "number" then
        error("Sig:Skill_MoveTo(angle, speed, distance), 参数错误: speed必须是number类型")
    end
    if type(distance) ~= "number" then
        error("Sig:Skill_MoveTo(angle, speed, distance), 参数错误: distance必须是number类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 移动到目标位置，speedScale为自身移动速度的缩放比例.
---@param speedScale number 速度缩放比例
function Skill_MoveToTarget(speedScale)
    if type(speedScale) ~= "number" then
        error("Sig:Skill_MoveToTarget(speedScale), 参数错误: speedScale必须是number类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 瞬间移动到目标位置.
function Skill_TeleportToTarget()
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 在自己附近召唤类型为NpcTID的NPC.
---@param NpcTID string Npc类型@Terms.NpcTID
function Skill_Summon(NpcTID)
    if type(NpcTID) ~= "string" then
        error("Sig:Skill_Summon(NpcTID),参数错误: NpcTID必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 获取自己当前血量.
---@return number HP 自己当前血量
function Skill_GetSelfHP()
    -- TODO: Implement the function logic here
    return 0
end
---@description 作用: 获取自己最大血量.
---@return number MaxHP 自己最大血量
function Skill_GetSelfMaxHP()
    -- TODO: Implement the function logic here
    return 0
end
---@description 作用: 获取自己的朝向.
---@return table Dir 自己的朝向向量
function Skill_GetSelfDir()
    -- TODO: Implement the function logic here
    return {}
end
---@description 作用: 获取自己的位置.
---@return table Pos 自己的位置坐标,参考@Terms.Pos
function Skill_GetSelfPos()
    -- TODO: Implement the function logic here
    return {}
end
---@description 作用: 获取敌人的位置.
---@return table Pos 敌人的位置坐标,参考@Terms.Pos
function Skill_GetEnemyPos()
    -- TODO: Implement the function logic here
    return {}
end
---@description 作用: 以目标位置为中心创建一个静止的圆形buff区域.
---@description 说明: 适用于需要在目标位置（如敌人脚下）创建固定区域的场景.
---@param radius number 区域半径，单位为米
---@param duration number 区域持续时间，单位为秒
---@param context string 调用此API的目的和效果，用于日志记录
function Skill_CreateTargetPosCircleRegion(radius, duration, context)
    if type(radius) ~= "number" then
        error("Sig:Skill_CreateTargetPosCircleRegion(radius, duration, context), 参数错误: radius必须是number类型")
    end
    if type(duration) ~= "number" then
        error("Sig:Skill_CreateTargetPosCircleRegion(radius, duration, context), 参数错误: duration必须是number类型")
    end
    if type(context) ~= "string" then
        error("Sig:Skill_CreateTargetPosCircleRegion(radius, duration, context),参数错误: context必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 以目标为中心创建一个跟随目标移动的圆形buff区域.
---@description 说明: 适合需要绑定目标（如跟随敌人或友方单位）的动态区域.
---@param radius number 区域半径，单位为米
---@param duration number 区域持续时间，单位为秒
---@param context string 调用此API的目的和效果，用于日志记录
function Skill_CreateTargetCircleRegion(radius, duration, context)
    if type(radius) ~= "number" then
        error("Sig:Skill_CreateTargetCircleRegion(radius, duration, context), 参数错误: radius必须是number类型")
    end
    if type(duration) ~= "number" then
        error("Sig:Skill_CreateTargetCircleRegion(radius, duration, context), 参数错误: duration必须是number类型")
    end
    if type(context) ~= "string" then
        error("Sig:Skill_CreateTargetCircleRegion(radius, duration, context),参数错误: context必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 以自身位置为中心创建一个静止的圆形buff区域.
---@description 说明: 适用于在施法者当前位置创建固定区域的技能.
---@param radius number 区域半径，单位为米
---@param duration number 区域持续时间，单位为秒
---@param context string 调用此API的目的和效果，用于日志记录
function Skill_CreateSelfPosCircleRegion(radius, duration, context)
    if type(radius) ~= "number" then
        error("Sig:Skill_CreateSelfPosCircleRegion(radius, duration, context), 参数错误: radius必须是number类型")
    end
    if type(duration) ~= "number" then
        error("Sig:Skill_CreateSelfPosCircleRegion(radius, duration, context), 参数错误: duration必须是number类型")
    end
    if type(context) ~= "string" then
        error("Sig:Skill_CreateSelfPosCircleRegion(radius, duration, context),参数错误: context必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 以自身为中心创建一个跟随自身的圆形buff区域.
---@description 说明: 适合需要围绕施法者移动的buff区域.
---@param radius number 区域半径，单位为米
---@param duration number 区域持续时间，单位为秒
---@param context string 调用此API的目的和效果，用于日志记录
function Skill_CreateSelfCircleRegion(radius, duration, context)
    if type(radius) ~= "number" then
        error("Sig:Skill_CreateSelfCircleRegion(radius, duration, context), 参数错误: radius必须是number类型")
    end
    if type(duration) ~= "number" then
        error("Sig:Skill_CreateSelfCircleRegion(radius, duration, context), 参数错误: duration必须是number类型")
    end
    if type(context) ~= "string" then
        error("Sig:Skill_CreateSelfCircleRegion(radius, duration, context),参数错误: context必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 为buff区域内停留的目标添加指定的buff.
---@param buffTID string Buff的TID@Terms.TID
---@param prob number 添加buff的概率，取值范围0到1
---@param duration number buff持续时间，单位为秒
---@param buffArg table buff的额外参数，格式参考Terms.buffTID
---@param targetType string 目标类型，可选值'enemy'（敌人）或'friend'（友方）
---@param context string 调用此API的目的和效果，用于日志记录
function Region_AddStayBuff(buffTID, prob, duration, buffArg, targetType, context)
    if type(buffTID) ~= "string" then
        error("Sig:Region_AddStayBuff(buffTID, prob, duration, buffArg, targetType, context),参数错误: buffTID必须是string类型")
    end
    if type(prob) ~= "number" then
        error("Sig:Region_AddStayBuff(buffTID, prob, duration, buffArg, targetType, context), 参数错误: prob必须是number类型")
    end
    if type(duration) ~= "number" then
        error("Sig:Region_AddStayBuff(buffTID, prob, duration, buffArg, targetType, context), 参数错误: duration必须是number类型")
    end
    if type(buffArg) ~= "table" and buffArg ~= nil then
        error("Sig:Region_AddStayBuff(buffTID, prob, duration, buffArg, targetType, context), 参数错误: buffArg必须是table类型或nil")
    end
    if type(targetType) ~= "string" then
        error("Sig:Region_AddStayBuff(buffTID, prob, duration, buffArg, targetType, context),参数错误: targetType必须是string类型")
    end
    if type(context) ~= "string" then
        error("Sig:Region_AddStayBuff(buffTID, prob, duration, buffArg, targetType, context),参数错误: context必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 持续释放技能duration毫秒，为了占住技能时间线. 技能的定身，引导，吟唱等时间操作，都可以使用这个函数.
---@param duration number 持续时间，单位为毫秒
---@param context string 调用此API的目的和效果，用于日志记录
function Skill_Sleep(duration, context)
    if type(duration) ~= "number" then
        error("Sig:Skill_Sleep(duration, context), 参数错误: duration必须是number类型")
    end
    if type(context) ~= "string" then
        error("Sig:Skill_Sleep(duration, context),参数错误: context必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 取消当前技能释放，一般用于event回调函数中.
function Skill_Cancel()
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 注册事件，eventName为事件名，func为事件处理函数.
---@param eventName string 事件名 @Terms.eventName
---@param func function 事件处理函数，无参数，无返回, 事件参数有对应API可获取
function Skill_RegisterEvent(eventName, func)
    if type(eventName) ~= "string" then
        error("Sig:Skill_RegisterEvent(eventName, func),参数错误: eventName必须是string类型")
    end
    if type(func) ~= "function" and func ~= nil then
        error("Sig:Skill_RegisterEvent(eventName, func), 参数错误: func必须是function类型或nil")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 喊话，message为说的内容，duration为持续时间.
---@param message string 消息内容
---@param duration number 持续时间，单位为秒
function Skill_Say(message, duration)
    if type(message) ~= "string" then
        error("Sig:Skill_Say(message, duration),参数错误: message必须是string类型")
    end
    if type(duration) ~= "number" then
        error("Sig:Skill_Say(message, duration), 参数错误: duration必须是number类型")
    end
    -- TODO: Implement the function logic here
    return 
end
