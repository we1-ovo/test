local M = {}

function M.init()
    Skill_SetCooldown(20000, "设置技能冷却时间为20秒")
    Skill_SetCastRange(0, "设置技能施法范围为0，只能对自己释放")
    Skill_SetMainTargetType("self", "设置主目标类型为自己")
    Skill_SetDesc("石熊发出震耳欲聋的吼叫，提升自身20%的攻击力，持续6秒", "自我增益技能")
end

function M.cb()
    -- 选择自己作为目标
    Skill_CollectMainTarget("选择自己作为技能目标")
    
    -- 发出怒吼声音
    Skill_Say("吼！！！", 1000, "发出怒吼声音")
    
    -- 为自己添加20%攻击力提升buff，持续6000毫秒
    Skill_SelfAddBuff('buff_attack', 1, 6000, {20}, "提升自身20%攻击力，持续6秒")
    
    -- 创建声波扩散的视觉效果
    Skill_CreateSelfCircleRegion(3, 1000, "创建声波扩散效果区域")
    
    -- 等待技能效果持续
    Skill_Sleep(6000, "等待增益效果持续时间")
end

return M