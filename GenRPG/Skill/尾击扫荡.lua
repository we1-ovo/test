local M = {}

function M.init()
    -- 技能初始化设置
    Skill_SetMPCost(250, "设置魔法消耗为250点")
    Skill_SetCooldown(10000, "设置技能冷却时间为10秒")
    Skill_SetCastRange(8, "设置技能释放范围为8米")
    Skill_SetMainTargetType("enemy", "设置技能主目标类型为敌人")
    Skill_SetDesc("终极AOE技能，龙尾横扫周围区域，造成大量物理伤害并可能击退目标", "龙尾横扫技能描述")
end

function M.cb()
    -- 技能释放逻辑
    -- 3秒前摇时间，模拟蓄力过程
    Skill_Say("吼！准备承受我的怒火吧！", 3000, "龙尾扫荡前的咆哮")
    Skill_Sleep(3000, "技能蓄力前摇3秒")
    
    -- 选择AOE范围内的敌人
    Skill_CollectCircleTargets(8, 20, "选择8米范围内最多20个敌人")
    
    -- 随机伤害值在400-450之间
    local damage = math.random(400, 450)
    Skill_TargetDamage("damage_physical", damage, "造成物理伤害" .. damage .. "点")
    
    -- 30%几率击退目标3米
    if math.random() <= 0.3 then
        Skill_TargetEnemyAddBuff("buff_beat_back", 1, 500, {3}, "击退敌人3米")
    end
    
    -- 创建震地效果
    Skill_CreateSelfPosCircleRegion(8, 1000, "创建震地效果区域")
    
    -- 技能释放完毕
end

return M