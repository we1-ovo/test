local M = {}

function M.init()
    -- 初始化技能参数
    Skill_SetMPCost(80, "设置魔法消耗为80点")
    Skill_SetCooldown(20, "设置技能冷却时间为20秒")
    Skill_SetCastRange(8, "设置施法范围为8米")
    Skill_SetMainTargetType("enemy", "设置目标类型为敌人")
    Skill_SetDesc("千年蛟龙仰天长啸，释放强大威压，降低8米范围内敌人20%的移动速度，持续5秒。同时恢复自身5%最大生命值。血量低于50%时会使用。")
end

function M.cb()
    -- 检查血量是否低于50%
    local currentHP = Skill_GetSelfHP()
    local maxHP = Skill_GetSelfMaxHP()
    
    if currentHP / maxHP > 0.5 then
        -- 血量高于50%，取消技能释放
        Skill_Cancel()
        return
    end
    
    -- 发出咆哮
    Skill_Say("吼！！！", 2)
    
    -- 选择8米范围内的所有敌人
    Skill_CollectCircleTargets(8, 20, "选择8米范围内的敌人")
    
    -- 对选中的敌人添加减速buff
    Skill_TargetEnemyAddBuff("buff_speed", 1, 5, {-0.2}, "降低敌人20%移动速度，持续5秒")
    
    -- 创建圆形区域效果表示咆哮声波
    Skill_CreateSelfCircleRegion(8, 1, "创建咆哮的声波扩散效果")
    
    -- 计算治疗量为最大生命值的5%
    local healAmount = maxHP * 0.05 * -1  -- 负数表示治疗
    
    -- 为自己恢复生命值
    Skill_SelfDamage("damage_physical", healAmount, "恢复自身5%最大生命值")
    
    -- 等待技能效果显示完成
    Skill_Sleep(1000, "等待技能效果显示完成")
end

return M