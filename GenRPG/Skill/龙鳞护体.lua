local M = {}

function M.init()
    -- 设置技能基本属性，根据设计文档
    Skill_SetMPCost(80, "消耗魔法值80点")
    Skill_SetCooldown(15000, "冷却时间15秒")
    Skill_SetCastRange(0, "只能作用于自身")
    Skill_SetMainTargetType("self", "目标类型为自己")
    Skill_SetDesc("千年蛟龙的防御技能，激活体表鳞片发出金色光芒，获得一个相当于最大生命值20%的护盾，持续8秒。护盾被击破时会对5米范围内敌人造成200点魔法伤害。", "龙鳞护体技能描述")
end

function M.cb()
    -- 选择自己作为技能目标
    Skill_CollectMainTarget("选择自身为目标")
    
    -- 获取自身最大生命值
    local maxHP = Skill_GetSelfMaxHP()
    
    -- 计算护盾值（最大生命值的20%）
    local shieldValue = maxHP * 0.2
    
    -- 创建护盾参数：护盾值、护盾类型、被击破时造成的伤害值、伤害范围
    local shieldArgs = {shieldValue, 'shield_physical', 200, 5}
    
    -- 为自身添加护盾buff，护盾被击破时会自动对范围内敌人造成伤害
    Skill_SelfAddBuff('buff_shield', 1, 8000, shieldArgs, "添加基于最大生命值20%的物理护盾")
    
    -- 等待护盾持续时间
    Skill_Sleep(8000, "等待护盾持续时间结束")
end

return M