-- 测试文件示例
-- 展示API调用验证和资源检查功能

local TestModule = {}

-- 测试函数
function TestModule.cb()
    print("🚀 开始测试API调用...")
    
    -- 1. 测试Level系统API
    print("\n📋 测试Level系统API:")
    
    -- 正确的API调用
    LEVEL_SetStageTimeout(60)
    LEVEL_BlackboardSet("test_key", "test_value")
    local value = LEVEL_BlackboardGet("test_key")
    
    -- 错误的API调用（用于测试验证）
    pcall(function()
        LEVEL_SetStageTimeout(-10)  -- 负数timeout
    end)
    
    -- 2. 测试AI系统API
    print("\n📋 测试AI系统API:")
    
    -- 正确的API调用
    local pos = NPC_GetPos("")
    NPC_BlackboardSet("ai_state", "patrol")
    NPC_MoveTo({x = 100, y = 0, z = 100})
    
    -- 错误的API调用（用于测试验证）
    pcall(function()
        NPC_GetNearbyEnemyCount(nil, -5)  -- 负数radius
    end)
    
    -- 3. 测试Skill系统API
    print("\n📋 测试Skill系统API:")
    
    -- 正确的API调用
    local casterPos = Skill_GetCasterPos()
    Skill_SetSkillArg("damage", "100")
    Skill_PlaySound("sword_hit", casterPos)
    
    -- 错误的API调用（用于测试验证）
    pcall(function()
        Skill_DoDamage("mock_target", -50, "invalid_damage_type")  -- 负数伤害和无效类型
    end)
    
    -- 4. 测试资源引用（这些会产生资源不存在的错误）
    print("\n📋 测试资源引用:")
    
    pcall(function()
        LEVEL_SummonWithType("不存在的NPC", "不存在的定位器")
    end)
    
    pcall(function()
        NPC_CastSkill("mock_npc", "不存在的技能")
    end)
    
    print("\n✅ 测试完成！")
end

return TestModule 