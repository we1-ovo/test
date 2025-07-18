local M = {}

function M.init()
    -- 设置技能基础属性
    Skill_SetMPCost(0, "仙人传授不需要耗费自身修为")
    Skill_SetCooldown(0, "技能可以随时使用但通常只用一次")
    Skill_SetCastRange(0, "只能对自己释放")
    Skill_SetMainTargetType("self", "技能本质是一个表演性质的释放过程")
    Skill_SetDesc("传授御风术的仙术技能", "仙人传授技能")
end

function M.cb()
    -- 选择自己作为施法目标
    Skill_CollectMainTarget("选择自己作为施法目标")
    
    -- 老修士说话，传授御风术的话语
    Skill_Say("静心凝神，感受风的流动。御风之术，乃是借天地之力，驭风而行。吸气纳灵，呼气引风，心随意动，身随风行。", 3000, "传授御风术的仙人话语")
    
    -- 为自己添加无敌状态，表现传功时的庄严神圣
    Skill_SelfAddBuff("buff_invincible", 1, 1000, {}, "传功时的庄严神圣状态")
    
    -- 创建青色风系灵力光效
    Skill_CreateSelfPosCircleRegion(2, 2000, "创建青色风系灵力光效")
    
    -- 在自己位置创建静态子物体
    Skill_CreateStaticSubObjAtSelfPos(2000, "创建静态视觉效果")
    SubObj_SetTriggerType("trigger_delay", 1000, "设置子物体1秒后自动消失")
    SubObj_SetSize("normal", "设置子物体大小为正常")
    
    -- 技能持续4秒，给玩家充分观赏时间
    Skill_Sleep(4000, "技能持续4秒")
end

return M