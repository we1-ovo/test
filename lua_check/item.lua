---@description 系统ID术语说明
---
---@description TID:
---    模板ID, 一般用来作为变量名称，用来标识某种类型的模板！！！
---
---@description NpcTID:
---    NPC的模板ID(string)，一般用来作为变量名称，用来标识某种类型的NPC！！！比如'狼'是一种NPC，但是10只狼的NpcTID是一样的，他们的NpcUUID是不一样的
---
---@description ItemTID:
---    物品的模板ID(string)，一般用来作为变量名称，用来标识某种类型的物品！！！比如'恢复水晶'是一种物品，但是10个恢复水晶的ItemTID是一样的，他们的ItemUUID是不一样的
---
---@description SkillTID:
---    技能的模板ID(string)，一般用来作为变量名称，用来标识某种类型的技能！！！SkillTID一般从策划设计文档中获取，其他'SkillName','技能名称'都是SkillTID的别称
---
---@description NpcUUID:
---    NPC的唯一标识(string)，一般用来作为变量名称，用来标识一个唯一具体的NPC实体！！！比如10只狼的NpcUUID是不一样的，他们的NpcTID是一样的
---    通常在召唤NPC时LEVEL_SummonNPC()会返回一个NpcUUID，用来标识这个NPC
---    如果需要在非Level系统process.lua的其他系统代码文件获取process.lua召唤的NPC的UUID，可以通过LEVEL_BlackboardSet设置，通过LEVEL_BlackboardGet获取
---    在没有特殊说明情况下，'Player','player'都可以作为玩家的NpcUUID在代码中使用，他们是一个特殊的预定义的UUID标志符。
---
---@description xxxNpcUUID:
---    组合描述(string)，'xxx'是泛指用来修饰区分不同的@Terms.NpcUUID，一般用来作为变量名称，描述一个有特定用途的NpcUUID实体！！！比如'targetNpcUUID'是目标NPC的NpcUUID,可以依次类推根据变量名来理解
---
---@description LocatorID:
---    坐标定位器(string)，一般用来作为变量名称，用来标识地图上一个位置，比如'出生点'是一个locator。
---    IMPORTANT: LocatorID是标记地图的一个点，一个Pos, 不是区域!!!
---    定义在文件Locator.lua(由地图系统生成)中，经常作为定位参数使用。
---    不支持动态坐标点(例如“相对于玩家位置”、“追踪目标”)。
---    只有地图策划Agent和关卡策划Agent在文档设计阶段可以根据关卡流程需要自由创建并命名新的`LocatorID`（必须遵循`locator_`前缀规范），并在文档中详细描述其位置和用途。地图策划后续将依据这些设计在地图中创建这些点并更新`Locator.lua`文件。
---    当Agent的任务是'生成代码'时，必须使用提供的`Locator.lua`中已有的`LocatorID`。当Agent被要求设计文档时，可以创建逻辑上需要的新LocatorID（必须遵循`locator_`前缀规范）并加以描述。Agent务必根据当前任务目标判断应遵循哪一原则。
---
---@description Pos:
---    位置，(table{x number,y number,z number}), 一般用来作为变量名称和返回值，用来标识地图上一个位置，释放技能的时候传入一个Pos，表示释放技能的位置
---
---@description Dir:
---    方向，(table{x number,y number,z number}), 一般用来作为变量名称和返回值，用来标识一个方向，释放技能的时候传入一个Dir，表示释放技能的方向,如果填充nil，一般是朝向目标。
---
---@description EmotionID:
---    情绪ID(string)，表示NPC/Player/旁白说话时的情绪。
---    支持的情绪范围：["happy", "sad", "angry", "fearful", "disgust", "surprised", "neutral"]
---
---@description propName:
---    属性名称以及对应的含义如下:
---    hpMax: 最大生命值
---    hpGen: 生命回复速度每秒
---    mpMax: 最大法力值
---    mpGen: 法力回复速度每秒
---    speed: 移动速度,单位米/秒，如果速度是0，NPC无法移动, 属于木桩NPC或者堡垒NPC。
---    strength: 力量:决定攻击力,1点力量为1点攻击力
---    defense: 防御:决定防御力,1点防御可以减少1点伤害
---    agility: 敏捷:决定技能冷却时间,冷却CD缩减=敏捷/1000
---
---@description context:
---    很多API的最后一个参数，string类型，填写调用此API的目的和效果，用于日志记录，简要记录，大概15个字。
---


-- 使用统一验证模块，专注于API定义
-- 加载统一验证模块
local ValidationModule = require("lua_check.validation")
local validateParam = ValidationModule.validateParam

---@description 作用: Item修改指定属性@Terms.propName的数值.
---@param propName string 属性名@Terms.propName
---@param value number 属性改变的数值
function Item_AddProp(propName, value)
    validateParam("propName", propName, "string", "Item_AddProp")
    validateParam("value", value, "number", "Item_AddProp")
    validateParam("", nil, "", "Item_AddProp")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: Item获取指定属性@Terms.propName的数值.
---@param propName string 属性名@Terms.propName
---@return number value 属性的数值
function Item_GetProp(propName)
    validateParam("propName", propName, "string", "Item_GetProp")
    validateParam("", nil, "", "Item_GetProp")
    -- TODO: Implement the function logic here
    return 0
end
---@description 作用: 获取自己的的MP值.
---@return number value MP的数值
function Item_GetMp()
    validateParam("", nil, "", "Item_GetMp")
    -- TODO: Implement the function logic here
    return 0
end
---@description 作用: 获取自己的血值.
---@return number value HP的数值
function Item_GetHp()
    validateParam("", nil, "", "Item_GetHp")
    -- TODO: Implement the function logic here
    return 0
end
---@description 作用: 修改自己的MP值.
---@param value number MP的修改数值，正数增加，负数减少
function Item_ModMp(value)
    validateParam("value", value, "number", "Item_ModMp")
    validateParam("", nil, "", "Item_ModMp")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 修改物品所有者HP值.
---@param value number HP的修改数值，正数增加，负数减少
function Item_ModHp(value)
    validateParam("value", value, "number", "Item_ModHp")
    validateParam("", nil, "", "Item_ModHp")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 使用物品，所有者触发喊话.
---@param message string 喊话的内容
function Item_Say(message)
    validateParam("message", message, "string", "Item_Say")
    validateParam("", nil, "", "Item_Say")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 使用物品，所有者获得exp的经验值.
---@param exp number 获得的经验值
function Item_AddExp(exp)
    validateParam("exp", exp, "number", "Item_AddExp")
    validateParam("", nil, "", "Item_AddExp")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 释放技能,目标随机或自己。Item可以通过这个API释放配合的技能@Terms.SkillTID，实现投掷，设置buff陷阱等效果。
---@param SkillTID string 技能名@Terms.SkillTID
---@param randTarget boolean true:随机选择目标;false:使用物品所有者作为目标
function Item_CastSkill(SkillTID, randTarget)
    validateParam("SkillTID", SkillTID, "string", "Item_CastSkill")
    validateParam("randTarget", randTarget, "boolean", "Item_CastSkill")
    validateParam("", nil, "", "Item_CastSkill")
    -- TODO: Implement the function logic here
    return 
end
