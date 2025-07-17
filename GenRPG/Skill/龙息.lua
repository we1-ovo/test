local M = {}

function M.init()
    -- 初始化技能参数
    Skill_SetMPCost(40, "设置魔法消耗为40点")
    Skill_SetCooldown(4000, "设置技能冷却时间为4秒")
    Skill_SetCastRange(8, "设置技能射程为8米")
    Skill_SetMainTargetType("enemy", "设置目标类型为敌人")
    Skill_SetDesc("千年蛟龙的基础攻击技能，从口中喷射出炽热龙息，形成扇形范围攻击。攻击范围为前方30度角、射程8米的扇形区域，造成基础攻击力1.2倍的物理伤害。", "蛟龙喷射炽热龙息")
end

function M.cb()
    -- 模拟吸气动作前摇
    Skill_Sleep(1000, "吸气动作前摇1秒")
    
    -- 选择扇形范围内的敌人
    Skill_CollectSectorTargets(8, 30, 10, "选择前方30度角8米范围内的敌人")
    
    -- 对选中的敌人造成1.2倍基础攻击力的物理伤害
    Skill_TargetScaleDamage("damage_physical", 1.2, "造成1.2倍基础攻击力的物理伤害")
    
    -- 播放咆哮音效
    Skill_Say("吼！", 1000, "龙息咆哮音效")
end

return M