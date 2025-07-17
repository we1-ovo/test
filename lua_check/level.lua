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

---@description 作用:这个是一个会阻塞process.lua的API，实现「执行初始化操作 → 周期性检查条件」的流程控制
---@description 该API作为stage流程控制的核心API, 适用于需要等待异步操作完成的场景（如stage控制、资源加载、状态检测）。
---@description LEVEL_DoProcess的参数超时，不会影响整个Stage的逻辑，只会影响当前的逻辑单元的执行时间，即使任务没有完成，也会继续执行下一个逻辑单元
---@description 重要: 可以将异步执行的API，通过do --> check --> finish的方式串联起来，实现阻塞执行效果！！！
---@description 作为延迟函数: 可以通过`LEVEL_DoProcess(function() end, function() return false end, 1000)`实现阻塞1秒的效果,注意checkFunction返回false。
---@param doFunction function 无参数无返回值的初始化函数，此函数内部可以执行阻塞函数!!!也可以执行非阻塞函数, 立即执行且仅执行一次。比如触发需要等待的操作（如发起网络请求、启动动画）
---@param checkFunction function 无参数的检查函数，内部可以执行非阻塞函数!!!. 需返回 `boolean`，周期性调用（间隔约200ms），返回 `true` 终止等待，`false` 继续检查.
---@param timeout number 超时时间,单位:毫秒，默认值为0。timeout正数值：超过该时间未成功则返回false. timeout为`0`：永不超时,流程将持续等待直到checkFunction返回true。
---@return boolean Finished `checkFunction`在超时前返回 `true`则返回`true`; 否则将在超时时间到达时返回`false`
function LEVEL_DoProcess(doFunction, checkFunction, timeout)
    validateParam("doFunction", doFunction, "function", "LEVEL_DoProcess")
    validateParam("checkFunction", checkFunction, "function", "LEVEL_DoProcess")
    validateParam("timeout", timeout, "number", "LEVEL_DoProcess")
    validateParam("", nil, "", "LEVEL_DoProcess")
    -- TODO: Implement the function logic here
    return true
end
---@description 作用: 这个是一个非阻塞的API，实现「定时执行操作」的流程控制。
---@description 可以通过设置interval==lifetime,可以实现定时器的延时执行一次的效果
---@description 主要: 可以将同步阻塞的API，通过LEVEL_AddTimerAsyncProcess(function, 0, 0)转换成非阻塞执行效果！！！
---@description 固定时间执行某任务: 比如在副本开启第60秒执行某个任务,可以使用LEVEL_AddTimerAsyncProcess(function, 60* 1000 - LEVEL_GetElapsed(), 0)实现(当前线程右阻塞函数，绝对时间需要去掉已经流逝的时间LEVEL_GetElapsed())。
---@param doFunction function() boolean 无参数有返回值的函数可以是阻塞或者非阻塞函数，为 `true` 表示执行成功，`false` 表示执行失败。
---@param interval number 定时器间隔时间（单位：毫秒），正数值：每隔该时间执行一次 `doFunction`，`0`：立即执行一次 `doFunction`不再执行
---@param lifetime number 定时器生命周期（单位：毫秒），正数值: 从当前算起，可以执行 `doFunction` 的总时长, 默认值为 `0`（无限执行，直到当前Stage结束）。
function LEVEL_AddTimerAsyncProcess(doFunction, interval, lifetime)
    validateParam("doFunction", doFunction, "function", "LEVEL_AddTimerAsyncProcess")
    validateParam("interval", interval, "number", "LEVEL_AddTimerAsyncProcess")
    validateParam("lifetime", lifetime, "number", "LEVEL_AddTimerAsyncProcess")
    validateParam("", nil, "", "LEVEL_AddTimerAsyncProcess")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 用于立即结束当前stage，标记stage失败。触发调用Stage[x]/onStageFailed.lua
---@param message string 失败原因描述
function LEVEL_AbortLevel(message)
    validateParam("message", message, "string", "LEVEL_AbortLevel")
    validateParam("", nil, "", "LEVEL_AbortLevel")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 用于立即结束当前LevelStage，标记阶段成功。触发调用Stage[x]/onStageSuccess.lua
---@param message string 成功原因描述
function LEVEL_EndStage(message)
    validateParam("message", message, "string", "LEVEL_EndStage")
    validateParam("", nil, "", "LEVEL_EndStage")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 设置当前阶段的持续时间，从超时时间会显示在玩家屏幕上,注意timeout单位为毫秒!!!。
---@description 超过该时间后会触发调用LEVEL_AbortLevel("LEVEL TIMEOUT"),触发调用Stage[x]/onStageFailed.lua
---@description 可以多次调用，以最后一次调用为准
---@param timeout number 设置当前阶段持续时间（单位：毫秒）,从当前时刻开始计时
function LEVEL_SetStageTimeout(timeout)
    validateParam("timeout", timeout, "number", "LEVEL_SetStageTimeout")
    validateParam("", nil, "", "LEVEL_SetStageTimeout")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 注册当前Stage需要击败的NPC，并在process.lua的逻辑执行完成的时候，用于判断Stage是成功完成，还是失败了。
---@description 如果注册的NPC都被击败了，Stage会触发LEVEL_EndStage,stage成功。
---@description 如果注册的NPC没有被击败，Stage会触发LEVEL_AbortLevel,stage失败。
---@description 注意: 无需额外检测，只要注册之后，Level框架会自动判断NPC是否存活,
---@param NpcUUIDArray string[] 需要击败的NPC的NpcUUID列表, 可以传入多个NpcUUID
function LEVEL_RegisterStageNPCNeedBeat(NpcUUIDArray)
    validateParam("NpcUUIDArray", NpcUUIDArray, "table", "LEVEL_RegisterStageNPCNeedBeat")
    validateParam("", nil, "", "LEVEL_RegisterStageNPCNeedBeat")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 注册当前Stage需要存活的NPC(例如被保护或被护送的NPC)，只要注册的npc死亡，Stage就会立即触发LEVEL_AbortLevel,stage失败。
---@description 如果在process.lua执行完成的时候，注册的NPC都存活，Stage会触发LEVEL_EndStage,stage成功。
---@description 如果任意时刻注册的NPC死亡，Stage会立即触发LEVEL_AbortLevel,stage失败。
---@param NpcUUIDArray string[] 需要存活的NPC的NpcUUID列表, 可以传入多个NpcUUID
function LEVEL_RegisterStageNPCNeedAlive(NpcUUIDArray)
    validateParam("NpcUUIDArray", NpcUUIDArray, "table", "LEVEL_RegisterStageNPCNeedAlive")
    validateParam("", nil, "", "LEVEL_RegisterStageNPCNeedAlive")
    -- TODO: Implement the function logic here
    return 
end
---@param NpcUUID string NPC的唯一标识符,@Terms.NpcUUID
---@param LocatorID string 坐标定位器的ID,@Terms.LocatorID
---@return number distance NPC与坐标定位器之间的距离,单位为米
function LEVEL_DistanceOfLocator(NpcUUID, LocatorID)
    validateParam("NpcUUID", NpcUUID, "string", "LEVEL_DistanceOfLocator")
    validateParam("LocatorID", LocatorID, "string", "LEVEL_DistanceOfLocator")
    validateParam("", nil, "", "LEVEL_DistanceOfLocator")
    -- TODO: Implement the function logic here
    return 0
end
---@param NpcUUID string NPC的唯一标识符,@Terms.NpcUUID
---@param Pos table 位置信息，表示一个位置，@Terms.Pos
---@return number distance NPC与位置之间的距离,单位为米
function LEVEL_DistanceOfPos(NpcUUID, Pos)
    validateParam("NpcUUID", NpcUUID, "string", "LEVEL_DistanceOfPos")
    validateParam("Pos", Pos, "table", "LEVEL_DistanceOfPos")
    validateParam("", nil, "", "LEVEL_DistanceOfPos")
    -- TODO: Implement the function logic here
    return 0
end
---@param NpcUUID string NPC的唯一标识符,@Terms.NpcUUID
---@param targetNpcUUID string 目标NPC的唯一标识符,@Terms.NpcUUID
---@return number distance NPC与目标NPC之间的距离,单位为米
function LEVEL_DistanceOfTarget(NpcUUID, targetNpcUUID)
    validateParam("NpcUUID", NpcUUID, "string", "LEVEL_DistanceOfTarget")
    validateParam("targetNpcUUID", targetNpcUUID, "string", "LEVEL_DistanceOfTarget")
    validateParam("", nil, "", "LEVEL_DistanceOfTarget")
    -- TODO: Implement the function logic here
    return 0
end
---@description 作用: 动态添加任务到玩家任务系统，给玩家提供游戏指引，情景对话，目标指引等。任务Desc一直在屏幕指引栏显示，任务对话在屏幕界面显示。 taskConfig为任务配置。
---@description 可以实现复杂的对话逻辑: 同步控制NPC朝向、镜头位置、语速、自动寻路、指引等。
---@description 对话API选择参考@DialogAPISelection
---@description 可以在process.lua中通过LEVEL_IsTaskFinished检查任务状态
---@description LEVEL_AddTask 也进行对话触发，主要用于任务的对话触发，引导玩家寻找对应的NPC，探索剧情。
---@description LEVEL_AddTask需要玩家主动找到目标NPC之后才会触发和NPC的对话，沉浸感最强。相较于其他接口，LEVEL_AddTask更加注重玩家的主动性。
---@description 注意事项：参数param,preChat两个同时为空的时候，可能需要考虑使用这个任务的目标是什么，是否考虑其他实现方式!!!
---@param taskConfig table 任务配置有大量字段，详细介绍在'taskConfig字段说明和举例'
function LEVEL_AddTask(taskConfig)
    validateParam("taskConfig", taskConfig, "table", "LEVEL_AddTask")
    validateParam("", nil, "", "LEVEL_AddTask")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 用于显示旁白，交代剧情上下文。不能控制其他任何表现，只能显示对话内容。
---@description 会在游戏界面显示对话，同时可以显示说话者的头像，主要用于旁白，剧情交代或者目标说明，比较简单。
---@description 表现是在游戏界面显示对话，会打断玩家的游戏体验,需要玩家点击确认才能继续游戏,一般用于剧情交代，目标说明等。
---@description 对话API选择参考@DialogAPISelection
---@param NpcTID string 喊话实体的NpcTID,空字符串来代表'旁白'。参考@Terms.NpcTID
---@param message string 喊话的内容，阻塞时间由message的长度决定，每秒钟大概显示10个字
---@param emotionID string 说话时的情绪。emotionID的参数说明@Terms.EmotionID
---@param speed number 说话速度，取值越大，语速越快。 范围[0.5,2]，默认值为1.0
function LEVEL_ShowDialog(NpcTID, message, emotionID, speed)
    validateParam("NpcTID", NpcTID, "string", "LEVEL_ShowDialog")
    validateParam("message", message, "string", "LEVEL_ShowDialog")
    validateParam("emotionID", emotionID, "string", "LEVEL_ShowDialog")
    validateParam("speed", speed, "number", "LEVEL_ShowDialog")
    validateParam("", nil, "", "LEVEL_ShowDialog")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 控制NpcNoPlayerUUID的NPC对dstNpcNoPlayerUUID的NPC说message, 说话的NPC头顶显示对话内容，主要用于周边环境渲染，情景渲染等等。不能向Player对话!!!
---@description NPC对话过程中，NpcNoPlayerUUID和无法dstNpcNoPlayerUUID执行其他AI逻辑。
---@description 目标NPC如果处于死亡状态则不会响应转向
---@description 对话API选择参考@DialogAPISelection
---@param NpcNoPlayerUUID string 说话NPC(非player)的唯一标识符 @Terms.NpcUUID
---@param dstNpcNoPlayerUUID string 目标NPC的UUID(非Player)。当设置为有效值时,NpcNoPlayerUUID的NPC会自动面向目标dstNpcNoPlayerUUID,dstNpcNoPlayerUUID也会面向NpcNoPlayerUUID, 直到对话结束
---@param message string 对话内容文本，会显示到NPC的头顶，游戏引擎会自动在NPC头顶显示为`<NpcTID名称>: <对话内容message>`的格式
---@param emotionID string 说话时的情绪。emotionID的参数说明@Terms.EmotionID
---@param speed number 说话速度，取值越大，语速越快。 范围[0.5,2]，默认值为1.0
function LEVEL_ShowMsgBubble(NpcNoPlayerUUID, dstNpcNoPlayerUUID, message, emotionID, speed)
    validateParam("NpcNoPlayerUUID", NpcNoPlayerUUID, "string", "LEVEL_ShowMsgBubble")
    validateParam("dstNpcNoPlayerUUID", dstNpcNoPlayerUUID, "string", "LEVEL_ShowMsgBubble")
    validateParam("message", message, "string", "LEVEL_ShowMsgBubble")
    validateParam("emotionID", emotionID, "string", "LEVEL_ShowMsgBubble")
    validateParam("speed", speed, "number", "LEVEL_ShowMsgBubble")
    validateParam("", nil, "", "LEVEL_ShowMsgBubble")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 检查任务是否完成
---@param taskId string 任务ID，即任务配置taskConfig中的id字段
---@return boolean finished 返回任务是否完成
function LEVEL_IsTaskFinished(taskId)
    validateParam("taskId", taskId, "string", "LEVEL_IsTaskFinished")
    validateParam("", nil, "", "LEVEL_IsTaskFinished")
    -- TODO: Implement the function logic here
    return true
end
---@description 作用: 设置多系统多文件全局共享的黑板变量，只能用于跨代码文件数据存储与通信。
---@description 最常用的情况是其他系统代码文件需要Level系统召唤的指定的NPC的NpcUUID,可以通过其系统的XXXX_BlackboardGet获取process.lua在通过LEVEL_SummonWithType召唤NPC后使用LEVEL_BlackboardSet存入黑板的NpcUUID。
---@description stage结束时自动清除stage周期内的所有的黑板变量
---@param key string 黑板变量键名，字符串类型，推荐使用`stage[x]_key`格式区分LevelStage
---@param value string 需要存储的字符串类型值，非字符串数据需调用tostring()转换
function LEVEL_BlackboardSet(key, value)
    validateParam("key", key, "string", "LEVEL_BlackboardSet")
    validateParam("value", value, "string", "LEVEL_BlackboardSet")
    validateParam("", nil, "", "LEVEL_BlackboardSet")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 获取黑板通过LEVEL_BlackboardSet设置的变量,只能用于跨代码通信。注意:返回值是string/nil类型，如果是number必须进行转换。
---@param key string 黑板变量键名，字符串类型, 只能使用通过LEVEL_BlackboardSet设置的key
---@return string value 返回字符串值，当键不存在时返回nil
function LEVEL_BlackboardGet(key)
    validateParam("key", key, "string", "LEVEL_BlackboardGet")
    validateParam("", nil, "", "LEVEL_BlackboardGet")
    -- TODO: Implement the function logic here
    return "UnitTestReturnString"
end
---@return number elapsed 返回stage已经进行的时间（单位：毫秒）
function LEVEL_GetElapsed()
    validateParam("", nil, "", "LEVEL_GetElapsed")
    -- TODO: Implement the function logic here
    return 0
end
---@return number elapsed 返回上一次心跳到现在的时间（单位：毫秒）
function LEVEL_GetLastTickElapsed()
    validateParam("", nil, "", "LEVEL_GetLastTickElapsed")
    -- TODO: Implement the function logic here
    return 0
end
---@description 作用: 获取定位器LocatorID标志的位置坐标Pos。
---@param LocatorID string 定位器名称,详细介绍参考@Terms.LocatorID
---@return table Pos 返回LocatorID的坐标@Terms.Pos
function LEVEL_GetPos(LocatorID)
    validateParam("LocatorID", LocatorID, "string", "LEVEL_GetPos")
    validateParam("", nil, "", "LEVEL_GetPos")
    -- TODO: Implement the function logic here
    return {x=0,y=0,z=0}
end
---@description 作用: 将玩家传送到定位器LocatorID标志的位置,快速传送，瞬间完成
---@param LocatorID string 定位器名称,详细介绍参考@Terms.LocatorID
function LEVEL_PlayerTeleportTo(LocatorID)
    validateParam("LocatorID", LocatorID, "string", "LEVEL_PlayerTeleportTo")
    validateParam("", nil, "", "LEVEL_PlayerTeleportTo")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 将NpcUUID的NPC传送到定位器LocatorID标志的位置，瞬间完成传送，可以认为没有时间消耗。
---@param NpcUUID string 需要传送的NPC的UUID，@Terms.NpcUUID
---@param LocatorID string 定位器名称，详细介绍参考@Terms.LocatorID
function LEVEL_TeleportTo(NpcUUID, LocatorID)
    validateParam("NpcUUID", NpcUUID, "string", "LEVEL_TeleportTo")
    validateParam("LocatorID", LocatorID, "string", "LEVEL_TeleportTo")
    validateParam("", nil, "", "LEVEL_TeleportTo")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 使NPC智能寻路移动，使NpcUUID的NPC移动到targetNpcUUID的NPC位置，同步执行直到目标地点到达.
---@param NpcUUID string 需要移动的NPC的UUID，@Terms.NpcUUID
---@param targetNpcUUID string 要移动到的目标NPC的UUID，@Terms.xxxNpcUUID
function LEVEL_NpcMoveToNpc(NpcUUID, targetNpcUUID)
    validateParam("NpcUUID", NpcUUID, "string", "LEVEL_NpcMoveToNpc")
    validateParam("targetNpcUUID", targetNpcUUID, "string", "LEVEL_NpcMoveToNpc")
    validateParam("", nil, "", "LEVEL_NpcMoveToNpc")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 使NPC智能寻路移动，使NpcUUID的NPC移动到Player当前的附近位置，同步执行直到目标地点到达.
---@param NpcUUID string 需要移动的NPC的UUID，@Terms.NpcUUID
function LEVEL_NpcMoveToPlayer(NpcUUID)
    validateParam("NpcUUID", NpcUUID, "string", "LEVEL_NpcMoveToPlayer")
    validateParam("", nil, "", "LEVEL_NpcMoveToPlayer")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 使NpcUUIDArray中的NPC移动到targetNpcUUID的NPC位置，同步执行直到目标地点到达.
---@param NpcUUIDArray string[] 需要移动的NPC的UUID数组，@Terms.NpcUUID
---@param targetNpcUUID string 要移动到的目标NPC的UUID，@Terms.xxxNpcUUID
function LEVEL_NpcsMoveToNpc(NpcUUIDArray, targetNpcUUID)
    validateParam("NpcUUIDArray", NpcUUIDArray, "table", "LEVEL_NpcsMoveToNpc")
    validateParam("targetNpcUUID", targetNpcUUID, "string", "LEVEL_NpcsMoveToNpc")
    validateParam("", nil, "", "LEVEL_NpcsMoveToNpc")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 使NpcUUID的NPC移动到定位器LocatorID标志的位置，距离目标点StopDistance米时停止移动，同步执行直到目标地点到达.
---@param NpcUUID string 需要移动的NPC的UUID，@Terms.NpcUUID
---@param LocatorID string 定位器名称，详细介绍参考@Terms.LocatorID
---@param StopDistance number 距离目标点StopDistance米时停止移动
---@param Timeout number 最多移动的时间（单位：毫秒）,一般根据时间控制移动速度，保证NPC在规定时间内到达目标地点
function LEVEL_NpcMoveToLocator(NpcUUID, LocatorID, StopDistance, Timeout)
    validateParam("NpcUUID", NpcUUID, "string", "LEVEL_NpcMoveToLocator")
    validateParam("LocatorID", LocatorID, "string", "LEVEL_NpcMoveToLocator")
    validateParam("StopDistance", StopDistance, "number", "LEVEL_NpcMoveToLocator")
    validateParam("Timeout", Timeout, "number", "LEVEL_NpcMoveToLocator")
    validateParam("", nil, "", "LEVEL_NpcMoveToLocator")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 使NpcUUIDArray中的NPC移动到定位器LocatorID标志的位置，距离目标点StopDistance米时停止移动，最多移动Timeout毫秒，同步执行直到目标地点到达.
---@param NpcUUIDArray string[] 需要移动的NPC的UUID数组，@Terms.NpcUUID
---@param LocatorID string 定位器名称，详细介绍参考@Terms.LocatorID
---@param StopDistance number 距离目标点StopDistance米时停止移动
---@param Timeout number 最多移动的时间（单位：毫秒）,一般根据时间控制移动速度，保证NPC在规定时间内到达目标地点
function LEVEL_NpcsMoveToLocator(NpcUUIDArray, LocatorID, StopDistance, Timeout)
    validateParam("NpcUUIDArray", NpcUUIDArray, "table", "LEVEL_NpcsMoveToLocator")
    validateParam("LocatorID", LocatorID, "string", "LEVEL_NpcsMoveToLocator")
    validateParam("StopDistance", StopDistance, "number", "LEVEL_NpcsMoveToLocator")
    validateParam("Timeout", Timeout, "number", "LEVEL_NpcsMoveToLocator")
    validateParam("", nil, "", "LEVEL_NpcsMoveToLocator")
    -- TODO: Implement the function logic here
    return 
end
---@param NpcUUID string 目标NPC的UUID，@Terms.NpcUUID
---@param LocatorID string 定位器名称，详细介绍参考@Terms.LocatorID
---@return boolean arrived 返回NpcUUID的NPC是否到达定位器LocatorID标志的位置
function LEVEL_NpcIsArrived(NpcUUID, LocatorID)
    validateParam("NpcUUID", NpcUUID, "string", "LEVEL_NpcIsArrived")
    validateParam("LocatorID", LocatorID, "string", "LEVEL_NpcIsArrived")
    validateParam("", nil, "", "LEVEL_NpcIsArrived")
    -- TODO: Implement the function logic here
    return true
end
---@description 作用: 生成指定类型的NPC实体，支持定点召唤或玩家周围随机位置生成(自动适配玩家周围)。
---@param NpcTID string NPC配置表中的NPC类型ID,参考@Terms.NpcTID
---@param LocatorID string 定位器名称（空字符串时在玩家周围随机生成）,详细介绍参考@Terms.LocatorID
---@return string NpcUUID 生成的NPC唯一UUID，用于后续操作标识,参考@Terms.NpcUUID
function LEVEL_SummonWithType(NpcTID, LocatorID)
    validateParam("NpcTID", NpcTID, "string", "LEVEL_SummonWithType")
    validateParam("LocatorID", LocatorID, "string", "LEVEL_SummonWithType")
    validateParam("", nil, "", "LEVEL_SummonWithType")
    -- TODO: Implement the function logic here
    return "UnitTestReturnString"
end
---@description 作用: 一次生成多个指定的NPC实体，其他参考@LEVEL_SummonWithType
---@param NpcTID string NPC配置表中的NPC类型ID,参考@Terms.NpcTID
---@param count number 生成的NPC数量
---@param LocatorID string 定位器名称（空字符串时在玩家周围随机生成）,详细介绍参考@Terms.LocatorID
---@return string[] NpcUUIDArray 生成的NpcUUID数组，用于后续操作标识,参考@Terms.NpcUUID
function LEVEL_SummonNPCsWithType(NpcTID, count, LocatorID)
    validateParam("NpcTID", NpcTID, "string", "LEVEL_SummonNPCsWithType")
    validateParam("count", count, "number", "LEVEL_SummonNPCsWithType")
    validateParam("LocatorID", LocatorID, "string", "LEVEL_SummonNPCsWithType")
    validateParam("", nil, "", "LEVEL_SummonNPCsWithType")
    -- TODO: Implement the function logic here
    return {}
end
---@description 作用: 在定位器LocatorID标志的位置掉落物品ItemTID，数量为count。
---@param ItemTID string 物品的模板ID，参考@Terms.ItemTID
---@param count number 掉落物品的数量
---@param LocatorID string 定位器名称，详细介绍参考@Terms.LocatorID
---@param notPosRand boolean true时在精确位置生成，false时在半径5米内随机位置
function LEVEL_DropItem(ItemTID, count, LocatorID, notPosRand)
    validateParam("ItemTID", ItemTID, "string", "LEVEL_DropItem")
    validateParam("count", count, "number", "LEVEL_DropItem")
    validateParam("LocatorID", LocatorID, "string", "LEVEL_DropItem")
    validateParam("notPosRand", notPosRand, "boolean", "LEVEL_DropItem")
    validateParam("", nil, "", "LEVEL_DropItem")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 比如检查stage目标是否完成，比如消灭所有怪物。
---@param NpcTID string NPC的模板ID，参考@Terms.NpcTID
---@return number count 返回指定NpcTID存活的NPC数量，如果NpcTID为空，则返回所有NPC数量
function LEVEL_GetAliveNpcCount(NpcTID)
    validateParam("NpcTID", NpcTID, "string", "LEVEL_GetAliveNpcCount")
    validateParam("", nil, "", "LEVEL_GetAliveNpcCount")
    -- TODO: Implement the function logic here
    return 0
end
---@description 作用: 获得NpcUUIDArray中的活着的npc数量
---@description 使用场景: 比如检查stage目标是否完成，消灭指定的怪物。
---@param NpcUUIDArray string[] 需要查询的NPC的UUID数组，@Terms.NpcUUID
---@return number count 返回NpcUUIDArray中存活的NPC数量
function LEVEL_GetArrayAliveNpcCount(NpcUUIDArray)
    validateParam("NpcUUIDArray", NpcUUIDArray, "table", "LEVEL_GetArrayAliveNpcCount")
    validateParam("", nil, "", "LEVEL_GetArrayAliveNpcCount")
    -- TODO: Implement the function logic here
    return 0
end
---@param NpcUUID string 需要查询的NPC的UUID，@Terms.NpcUUID
---@return boolean alive 返回UUID的NPC是否活着
function LEVEL_IsNpcAlive(NpcUUID)
    validateParam("NpcUUID", NpcUUID, "string", "LEVEL_IsNpcAlive")
    validateParam("", nil, "", "LEVEL_IsNpcAlive")
    -- TODO: Implement the function logic here
    return true
end
---@return boolean alive 返回玩家是否活着
function LEVEL_IsPlayerAlive()
    validateParam("", nil, "", "LEVEL_IsPlayerAlive")
    -- TODO: Implement the function logic here
    return true
end
---@description 作用: 获取NPC的当前HP数值。
---@param NpcUUID string 需要查询的NPC的UUID，@Terms.NpcUUID
---@return number value 当前HP数值
function LEVEL_GetHp(NpcUUID)
    validateParam("NpcUUID", NpcUUID, "string", "LEVEL_GetHp")
    validateParam("", nil, "", "LEVEL_GetHp")
    -- TODO: Implement the function logic here
    return 0
end
---@description 作用: 获取NpcUUID的指定属性的数值.可以获取的@Terms.propName属性值
---@param NpcUUID string 查询的NPC的UUID，@Terms.NpcUUID
---@param propName string 属性名@Terms.propName
---@return number value 当前属性的数值
function LEVEL_GetPropValue(NpcUUID, propName)
    validateParam("NpcUUID", NpcUUID, "string", "LEVEL_GetPropValue")
    validateParam("propName", propName, "string", "LEVEL_GetPropValue")
    validateParam("", nil, "", "LEVEL_GetPropValue")
    -- TODO: Implement the function logic here
    return 0
end
---@description 作用: 修改NpcUUID的指定属性@Terms.propName的数值(一般用于修改基础属性值,增加血量使用buf,减少使用DoDamage).
---@param NpcUUID string NPC的UUID，@Terms.NpcUUID
---@param propName string 属性名@Terms.propName
---@param value number 属性改变的数值
function LEVEL_AddPropValue(NpcUUID, propName, value)
    validateParam("NpcUUID", NpcUUID, "string", "LEVEL_AddPropValue")
    validateParam("propName", propName, "string", "LEVEL_AddPropValue")
    validateParam("value", value, "number", "LEVEL_AddPropValue")
    validateParam("", nil, "", "LEVEL_AddPropValue")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: NPC表演战斗情景使用！！使NpcUUID的NPC与targetNpcUUID的NPC互相战斗表演，但是NPC和目标NPC都不会死亡!!!!
---@param NpcUUID string NPC的UUID，@Terms.NpcUUID
---@param targetNpcUUID string 目标NPC的UUID(禁止使用Player/player), @Terms.NpcUUID
function LEVEL_NpcPerformBattle(NpcUUID, targetNpcUUID)
    validateParam("NpcUUID", NpcUUID, "string", "LEVEL_NpcPerformBattle")
    validateParam("targetNpcUUID", targetNpcUUID, "string", "LEVEL_NpcPerformBattle")
    validateParam("", nil, "", "LEVEL_NpcPerformBattle")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 使NpcUUID的NPC立即释放一次技能SkillTID,注意只释放一次,并且等到技能释放完毕。
---@param NpcUUID string NPC的UUID，@Terms.NpcUUID
---@param SkillTID string 技能系统的模板ID，参考@Terms.SkillTID,如果技能需要释放目标，API会自动帮助NPC选择合适的目标
function LEVEL_NpcCastSkill(NpcUUID, SkillTID)
    validateParam("NpcUUID", NpcUUID, "string", "LEVEL_NpcCastSkill")
    validateParam("SkillTID", SkillTID, "string", "LEVEL_NpcCastSkill")
    validateParam("", nil, "", "LEVEL_NpcCastSkill")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 批量控制NPC释放技能,注意只释放一次,并且等到技能释放完毕。
---@param NpcUUIDArray string[] 需要释放技能的NPC的UUID数组，@Terms.NpcUUID
---@param SkillTID string 技能的模板ID，参考@Terms.SkillTID
---@param randomTarget boolean 是否随机目标
---@param wait boolean 是否等待所有人技能释放完毕
function LEVEL_NpcsCastSkill(NpcUUIDArray, SkillTID, randomTarget, wait)
    validateParam("NpcUUIDArray", NpcUUIDArray, "table", "LEVEL_NpcsCastSkill")
    validateParam("SkillTID", SkillTID, "string", "LEVEL_NpcsCastSkill")
    validateParam("randomTarget", randomTarget, "boolean", "LEVEL_NpcsCastSkill")
    validateParam("wait", wait, "boolean", "LEVEL_NpcsCastSkill")
    validateParam("", nil, "", "LEVEL_NpcsCastSkill")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 强制NPC进入死亡状态
---@param NpcUUID string NPC的UUID，@Terms.NpcUUID
---@param dieMsg string 死亡喊话(可选),NPC死亡时的喊话,会显示在NPC的头顶
function LEVEL_NpcDie(NpcUUID, dieMsg)
    validateParam("NpcUUID", NpcUUID, "string", "LEVEL_NpcDie")
    validateParam("dieMsg", dieMsg, "string", "LEVEL_NpcDie")
    validateParam("", nil, "", "LEVEL_NpcDie")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 控制玩家攻击功能的开关。使用场景: 剧情过场时禁止玩家战斗操作
---@param enable boolean 控制玩家攻击功能的开关。enable为true则可以攻击，false则不可以攻击
function LEVEL_EnablePlayerAttack(enable)
    validateParam("enable", enable, "boolean", "LEVEL_EnablePlayerAttack")
    validateParam("", nil, "", "LEVEL_EnablePlayerAttack")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 控制NPC的主动攻击，一般NPC是被动NPC，使用此API可以使其主动攻击，对于主动NPC也可以使其忽略仇恨距离，直接追击过远的目标。使用场景: 使NpcUUID主动攻击指定目标targetNpcUUIDNPC/Player(注释受到阵营限制，友好阵营的两个Entity之间不会攻击)
---@param NpcUUID string 控制NpcUUID的实体主动攻击,@Terms.NpcUUID
---@param targetNpcUUID string 目标NPC/Player的UUID, @Terms.NpcUUID, 如果为nil则不指定目标,NpcUUID自动选择目标。
function LEVEL_NPCBattle(NpcUUID, targetNpcUUID)
    validateParam("NpcUUID", NpcUUID, "string", "LEVEL_NPCBattle")
    validateParam("targetNpcUUID", targetNpcUUID, "string", "LEVEL_NPCBattle")
    validateParam("", nil, "", "LEVEL_NPCBattle")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 控制NPC脱离战斗持续duration毫秒,清除所有仇恨值,之后AI系统接管这个NPC。
---@param NpcUUID string 控制NpcUUID的实体脱战,@Terms.NpcUUID
---@param duration number 持续时间，单位毫秒
function LEVEL_NPCLeaveBattle(NpcUUID, duration)
    validateParam("NpcUUID", NpcUUID, "string", "LEVEL_NPCLeaveBattle")
    validateParam("duration", duration, "number", "LEVEL_NPCLeaveBattle")
    validateParam("", nil, "", "LEVEL_NPCLeaveBattle")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 为选中的目标添加buffTID的buff，改变其状态和属性，概率为prob，持续时间为duration毫秒.
---@param NpcUUID string 目标@Terms.NpcUUID
---@param tempBuffName string Buff的临时名称,用于记录和删除
---@param buffTID string Buff的TID@Terms.TID
---@param prob number 概率，0到1之间
---@param duration number 持续时间，单位毫秒
---@param buffArg table 额外参数，根据不同的buff类型有不同的参数, 参考@Terms.buffTID中的参数说明
---@param context string 调用原因@Terms.context
function LEVEL_AddBuff(NpcUUID, tempBuffName, buffTID, prob, duration, buffArg, context)
    validateParam("NpcUUID", NpcUUID, "string", "LEVEL_AddBuff")
    validateParam("tempBuffName", tempBuffName, "string", "LEVEL_AddBuff")
    validateParam("buffTID", buffTID, "string", "LEVEL_AddBuff")
    validateParam("prob", prob, "number", "LEVEL_AddBuff")
    validateParam("duration", duration, "number", "LEVEL_AddBuff")
    validateParam("buffArg", buffArg, "table", "LEVEL_AddBuff")
    validateParam("context", context, "string", "LEVEL_AddBuff")
    validateParam("", nil, "", "LEVEL_AddBuff")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 移除目标身上的指定名称的buff,如果buff不存在则不执行任何操作
---@param NpcUUID string 目标@Terms.NpcUUID
---@param tempBuffName string Buff的临时名称,用于记录和删除
function LEVEL_RemoveBuff(NpcUUID, tempBuffName)
    validateParam("NpcUUID", NpcUUID, "string", "LEVEL_RemoveBuff")
    validateParam("tempBuffName", tempBuffName, "string", "LEVEL_RemoveBuff")
    validateParam("", nil, "", "LEVEL_RemoveBuff")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 修改NpcUUID的血量，修改值为value,正数为治疗，负数为伤害.
---@param NpcUUID string 目标@Terms.NpcUUID
---@param value number hp的变化值,正数为治疗，负数为伤害
---@param context string 调用原因@Terms.context
function LEVEL_ModHp(NpcUUID, value, context)
    validateParam("NpcUUID", NpcUUID, "string", "LEVEL_ModHp")
    validateParam("value", value, "number", "LEVEL_ModHp")
    validateParam("context", context, "string", "LEVEL_ModHp")
    validateParam("", nil, "", "LEVEL_ModHp")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 修改NpcUUID的MP，修改值为value.
---@param NpcUUID string 目标@Terms.NpcUUID
---@param value number mp的变化值,正数为增加，负数为减少
---@param context string 调用原因@Terms.context
function LEVEL_ModMp(NpcUUID, value, context)
    validateParam("NpcUUID", NpcUUID, "string", "LEVEL_ModMp")
    validateParam("value", value, "number", "LEVEL_ModMp")
    validateParam("context", context, "string", "LEVEL_ModMp")
    validateParam("", nil, "", "LEVEL_ModMp")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 以Pos位置为中心创建一个名为regionName的圆形buff区域。适用于实现光环、陷阱等基于位置的持续性效果。
---@param regionName string 事件区域的名称,用于标识和管理事件区域
---@param Pos table 位置信息，表示一个位置，@Terms.Pos
---@param radius number 圆形buff区域的半径，米
---@param duration number 持续时间，单位毫秒
---@param onEnterFunction function(string) 进入区域时触发的函数，参数为进入的NpcUUID
---@param onLeaveFunction function(string) 离开区域时触发的函数，参数为离开的NpcUUID
function LEVEL_AddCircleEventRegion(regionName, Pos, radius, duration, onEnterFunction, onLeaveFunction)
    validateParam("regionName", regionName, "string", "LEVEL_AddCircleEventRegion")
    validateParam("Pos", Pos, "table", "LEVEL_AddCircleEventRegion")
    validateParam("radius", radius, "number", "LEVEL_AddCircleEventRegion")
    validateParam("duration", duration, "number", "LEVEL_AddCircleEventRegion")
    validateParam("onEnterFunction", onEnterFunction, "function", "LEVEL_AddCircleEventRegion")
    validateParam("onLeaveFunction", onLeaveFunction, "function", "LEVEL_AddCircleEventRegion")
    validateParam("", nil, "", "LEVEL_AddCircleEventRegion")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 移除指定名称的事件区域,如果区域不存在则不执行任何操作
---@param regionName string 事件区域的名称,用于标识和管理事件区域
function LEVEL_RemoveEventRegion(regionName)
    validateParam("regionName", regionName, "string", "LEVEL_RemoveEventRegion")
    validateParam("", nil, "", "LEVEL_RemoveEventRegion")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 摄像机跟随xxxUUID的NPC，主要用于镜头控制，NPC表演，玩家观察等等
---@param xxxUUID string NPC的UUID或者Player，@Terms.xxxNpcUUID
function LEVEL_CameraFollow(xxxUUID)
    validateParam("xxxUUID", xxxUUID, "string", "LEVEL_CameraFollow")
    validateParam("", nil, "", "LEVEL_CameraFollow")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 给玩家发奖励，ItemTID为奖励物品的类型，count为数量。
---@param ItemTID string 奖励物品的类型，参考@Terms.ItemTID
---@param count number 发放的ItemTID数量
function LEVEL_Award(ItemTID, count)
    validateParam("ItemTID", ItemTID, "string", "LEVEL_Award")
    validateParam("count", count, "number", "LEVEL_Award")
    validateParam("", nil, "", "LEVEL_Award")
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 记录日志，用于调试和记录关键信息
---@param message string 日志内容
function LEVEL_Log(message)
    validateParam("message", message, "string", "LEVEL_Log")
    validateParam("", nil, "", "LEVEL_Log")
    -- TODO: Implement the function logic here
    return 
end
