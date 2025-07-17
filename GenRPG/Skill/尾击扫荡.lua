local M = {}

function M.init()
    -- 设置技能基础属性
    Skill_SetMPCost(100, "设置消耗100魔法值")
    Skill_SetCooldown(12000, "设置冷却时间12秒")
    Skill_SetCastRange(0, "设置施法范围为0(自身)")
    Skill_SetMainTargetType("enemy", "设置目标类型为敌人")
    Skill_SetDesc("千年蛟龙的终极技能，仅在血量低于50%时使用。蓄力3秒后甩动巨尾，对周围6米范围内所有目标造成双倍攻击力的物理伤害并击退2米。", "蛟龙尾击技能描述")
end

function M.cb()
    -- 检查血量是否低于50%
    local currentHP = Skill_GetSelfHP()
    local maxHP = Skill_GetSelfMaxHP()
    
    if currentHP > maxHP * 0.5 then
        -- 血量高于50%，取消释放
        Skill_Say("血量尚未达到临界点...", 1000, "血量不满足条件")
        Skill_Cancel("血量条件不满足，取消技能")
        return
    end
    
    -- 发出警告，蓄力开始
    Skill_Say("感受远古力量的愤怒吧！", 1000, "蓄力开始警告")
    
    -- 蓄力3秒
    Skill_Sleep(3000, "蓄力3秒，身体旋转")
    
    -- 选择周围6米范围内的敌人
    Skill_CollectCircleTargets(6, 50, "选择周围6米内所有敌人")
    
    -- 造成基础攻击力2倍的物理伤害
    Skill_TargetScaleDamage("damage_physical", 2, "造成2倍物理伤害")
    
    -- 给所有选中目标添加击退效果
    Skill_TargetEnemyAddBuff("buff_beat_back", 1, 500, {2}, "击退敌人2米")
    
    -- 创建技能特效区域
    Skill_CreateSelfPosCircleRegion(6, 1000, "创建尾击扫荡特效区域")
end

return M