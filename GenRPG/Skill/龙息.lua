local M = {}

function M.init()
    -- 初始化技能属性
    Skill_SetMPCost(100, "设置魔法消耗为100点")
    Skill_SetCooldown(4000, "设置技能冷却时间为4秒")
    Skill_SetCastRange(10, "设置技能释放范围为10米")
    Skill_SetMainTargetType("enemy", "设置技能目标类型为敌人")
    Skill_SetDesc("千年蛟龙的主要攻击技能，释放扇形范围的强力龙息", "龙息技能描述")
end

function M.cb()
    -- 技能释放逻辑
    -- 2秒前摇时间，模拟蓄力过程
    Skill_Say("吼！！！", 2000, "龙息蓄力的咆哮音效")
    Skill_Sleep(2000, "技能前摇时间2秒")
    
    -- 选择120度扇形范围内的敌人目标
    Skill_CollectSectorTargets(10, 120, 10, "选择前方120度扇形10米范围内最多10个敌人")
    
    -- 随机生成180-220之间的伤害值
    local damage = math.random(180, 220)
    
    -- 对选中的敌人造成伤害
    Skill_TargetDamage("damage_magic", damage, "对目标造成" .. damage .. "点魔法伤害")
end

return M