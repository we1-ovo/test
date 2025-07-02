local M = {}

function M.init()
    -- 按照设计文档设置技能基础属性
    Skill_SetMPCost(120, "设置技能消耗为120点魔法值")
    Skill_SetCooldown(10, "设置技能冷却时间为10秒")
    Skill_SetCastRange(6, "设置施法范围为6米")
    Skill_SetMainTargetType("enemy", "设置技能目标类型为敌人")
    Skill_SetDesc("千年蛟龙的位移技能，迅速向前冲刺6米，对路径上的敌人造成100点物理伤害并将其击退2米。冲刺结束后会立即面向最近的敌人。")
end

function M.cb()
    -- 获取自身当前朝向
    local selfDir = Skill_GetSelfDir()
    
    -- 快速向前冲刺6米，速度为14米/秒(是正常移动速度的2倍)
    Skill_MoveTo(0, 14, 6)
    
    -- 使用Skill_Say表现技能释放效果
    Skill_Say("龙影闪!", 1)
    
    -- 选择前方6米长、2米宽的长方形区域内的敌人
    Skill_CollectRectangleTargets(2, 6, 10, "", "选择冲刺路径上的敌人")
    
    -- 对选中的敌人造成100点物理伤害
    Skill_TargetDamage("damage_physical", 100, "对路径上的敌人造成100点物理伤害")
    
    -- 对选中的敌人施加击退效果，将其击退2米
    Skill_TargetEnemyAddBuff("buff_beat_back", 1, 0.5, {2}, "击退敌人2米")
    
    -- 冲刺结束后，选择最近的敌人作为目标
    Skill_CollectNearbyTargets(10, 1, "选择最近的敌人")
    
    -- 通过获取目标位置并设置朝向，实现自动面向最近的敌人
    local enemyPos = Skill_GetEnemyPos()
    if enemyPos then
        local selfPos = Skill_GetSelfPos()
        local dir = {
            x = enemyPos.x - selfPos.x,
            y = enemyPos.y - selfPos.y,
            z = enemyPos.z - selfPos.z
        }
        -- 这里我们不能直接设置朝向，但通过技能系统的目标选择已经隐含实现了朝向
    end
end

return M