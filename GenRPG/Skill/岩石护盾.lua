local M = {}

function M.init()
    Skill_SetCooldown(15000, "设置技能冷却时间为15秒")
    Skill_SetCastRange(0, "设置技能施法范围为0，只能对自己释放")
    Skill_SetMainTargetType("self", "设置主目标类型为自己")
    Skill_SetDesc("防御技能，在身体表面形成一层岩石护盾，持续8秒，提供200点护盾值", "防御增强技能")
end

function M.cb()
    -- 选择自己作为目标
    Skill_CollectMainTarget("选择自己作为技能目标")
    
    -- 为自己添加物理护盾，护盾值为200，持续8秒
    local shieldArgs = {200, 'shield_physical'}
    Skill_SelfAddBuff('buff_shield', 1, 8000, shieldArgs, "添加200点物理护盾，持续8秒")
    
    -- 技能持续时间，等待护盾效果结束
    Skill_Sleep(8000, "等待护盾效果结束")
end

return M