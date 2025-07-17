-- 修炼丹药的配置文件

local M = {
    -- id为物品TID，是物品类型的唯一标识，与文件名一致
    id = "修炼丹药",
    -- desc是物品的描述，会显示在物品信息中
    desc = "由灵草炼制而成的丹药，呈丹红色光泽。使用后大幅恢复生命与法力，并临时提升战斗属性",
    -- 选择红棕色宝石状模型，更符合丹红色光泽的描述
    prefab = "Assets/PolygonFantasyKingdom/Prefabs/Characters/CharacterAttachments/SM_Chr_Attach_Priest_Hat_01.prefab",
    avatar = "Assets/Avatars/Assets_PolygonFantasyKingdom_Prefabs_Characters_CharacterAttachments_SM_Chr_Attach_Priest_Hat_01.png",
    -- cooldown是物品的使用冷却时间，设置为3秒以平衡强大效果
    cooldown = 3000,
    -- 使用后删除，符合一次性消耗品特性
    deleteAfterUse = true,
    -- 可堆叠，允许玩家携带多个
    stackable = true,
    -- 需要玩家主动使用，而非自动使用
    autoUse = false,
    -- 在UI中显示，方便玩家查看和使用
    showInUI = true,
    -- 获得时不触发特殊效果
    onGet = nil,
    -- 丢弃时不触发特殊效果
    onLost = nil,
    -- 使用时触发恢复效果和临时属性提升
    onUse = function()
        -- 恢复大量HP（玩家最大生命的30%）
        local maxHp = Item_GetProp("hpMax")
        local healAmount = math.floor(maxHp * 0.3)
        Item_ModHp(healAmount)
        
        -- 恢复大量MP（玩家最大法力的40%）
        local maxMp = Item_GetProp("mpMax")
        local mpRestore = math.floor(maxMp * 0.4)
        Item_ModMp(mpRestore)
        
        -- 临时提升战斗属性（通过技能实现）
        Item_Say("道友服下修炼丹药，顿感灵力充盈，气血翻涌！")
        Item_CastSkill("丹药增益", false)
    end,
}

return M