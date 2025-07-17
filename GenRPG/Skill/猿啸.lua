local M = {}

function M.init()
    -- 设置技能基础属性
    Skill_SetMPCost(30, "增益技能消耗30点魔法值")
    Skill_SetCooldown(15000, "冷却时间15秒")
    Skill_SetCastRange(0, "自身增益技能范围为0")
    Skill_SetMainTargetType("self", "目标类型为自身")
    Skill_SetDesc("发出震天怒吼，提升自身攻击力20%，持续8秒。常在战斗开始或血量低于50%时使用。", "山猿增强技能")
end

function M.cb()
    -- 选择自身为目标
    Skill_CollectMainTarget("选择自身为技能目标")
    
    -- 咆哮动画和音效模拟
    Skill_Say("吼！！！", 1000, "山猿发出震天怒吼")
    
    -- 添加攻击力增益buff
    Skill_SelfAddBuff('buff_attack', 1, 8000, {20}, "提升自身20%攻击力，持续8秒")
    
    -- 创建视觉效果增强表现
    Skill_CreateSelfCircleRegion(1.5, 1000, "创建怒吼视觉效果区域")
    Region_AddStayBuff('buff_speed', 0, 1000, {0}, 'enemy', "仅用于视觉效果，无实际buff")
end

return M