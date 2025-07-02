local M = {}

function M.init()
    -- 技能初始化数值部分
    Skill_SetMPCost(50, "设置魔法消耗为50点")
    Skill_SetCooldown(7, "设置技能冷却时间为7秒")
    Skill_SetCastRange(10, "设置技能施法范围为10米")
    Skill_SetMainTargetType("enemy", "设置目标类型为敌人")
    Skill_SetDesc("千年蛟龙喷吐炽热龙息，对前方扇形区域造成高额伤害。扇形范围为前方10米，角度120度。伤害为自身攻击力的1.8倍。")
end

function M.cb()
    -- 技能释放逻辑部分
    
    -- 施法前摇，1秒时间
    Skill_Say("龙之怒焰即将降临！", 1)
    Skill_Sleep(1000, "施法前摇1秒，龙头仰起并发光")
    
    -- 选择扇形区域内的敌人
    Skill_CollectSectorTargets(10, 120, 20, "选择前方120度扇形、10米范围内的所有敌方目标")
    
    -- 对选中目标造成伤害
    Skill_TargetScaleDamage("damage_magic", 1.8, "造成1.8倍自身攻击力的魔法伤害")
    
    -- 创建一个区域效果模拟龙息喷射
    Skill_CreateSelfPosCircleRegion(10, 1, "创建龙息效果区域")
end

return M