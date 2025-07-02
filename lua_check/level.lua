---@description 作用:这个是一个会阻塞process.lua的API，实现「执行初始化操作 → 周期性检查条件」的流程控制
---@description 该API作为stage流程控制的核心API, 适用于需要等待异步操作完成的场景（如stage控制、资源加载、状态检测）。
---@description LEVEL_DoProcess的参数超时，不会影响整个Stage的逻辑，只会影响当前的逻辑单元的执行时间，即使任务没有完成，也会继续执行下一个逻辑单元
---@description 重要: 可以将异步执行的API，通过do --> check --> finish的方式串联起来，实现阻塞执行效果！！！
---@param doFunction function 无参数无返回值的初始化函数，此函数内部可以执行阻塞函数!!!也可以执行非阻塞函数, 立即执行且仅执行一次。比如触发需要等待的操作（如发起网络请求、启动动画）
---@param checkFunction function 无参数的检查函数，内部可以执行非阻塞函数!!!. 需返回 `boolean`，周期性调用（间隔约200ms），返回 `true` 终止等待，`false` 继续检查.
---@param timeout number 超时时间（单位：秒），默认值为 `0`（无限等待），正数值：超过该时间未成功则返回 `false`，`0`：永不超时，系统会确保 `checkFunction` 最终返回 `true`
---@return boolean Finished `checkFunction`在超时前返回 `true`则返回`true`; 否则将在超时时间到达时返回`false`
function LEVEL_DoProcess(doFunction, checkFunction, timeout)
    if type(doFunction) ~= "function" and doFunction ~= nil then
        error("Sig:LEVEL_DoProcess(doFunction, checkFunction, timeout), 参数错误: doFunction必须是function类型或nil")
    end
    if type(checkFunction) ~= "function" and checkFunction ~= nil then
        error("Sig:LEVEL_DoProcess(doFunction, checkFunction, timeout), 参数错误: checkFunction必须是function类型或nil")
    end
    if type(timeout) ~= "number" then
        error("Sig:LEVEL_DoProcess(doFunction, checkFunction, timeout), 参数错误: timeout必须是number类型")
    end
    -- TODO: Implement the function logic here
    return false
end
---@description 作用: 这个是一个非阻塞的API，实现「定时执行操作」的流程控制。
---@description 可以通过设置interval==lifetime,可以实现定时器的延时执行一次的效果
---@description 主要: 可以将同步阻塞的API，通过LEVEL_AddTimerAsyncProcess(function, 0, 0)转换成非阻塞执行效果！！！
---@param doFunction function() boolean 无参数有返回值的函数可以是阻塞或者非阻塞函数，为 `true` 表示执行成功，`false` 表示执行失败。
---@param interval number 定时器间隔时间（单位：秒），正数值：每隔该时间执行一次 `doFunction`，`0`：立即执行一次 `doFunction`不再执行
---@param lifetime number 定时器生命周期（单位：秒），正数值: 从当前算起，可以执行 `doFunction` 的总时长, 默认值为 `0`（无限执行，直到当前Stage结束）。
function LEVEL_AddTimerAsyncProcess(doFunction, interval, lifetime)
    if type(doFunction) ~= "function" and doFunction ~= nil then
        error("Sig:LEVEL_AddTimerAsyncProcess(doFunction, interval, lifetime), 参数错误: doFunction必须是function() boolean类型或nil")
    end
    if type(interval) ~= "number" then
        error("Sig:LEVEL_AddTimerAsyncProcess(doFunction, interval, lifetime), 参数错误: interval必须是number类型")
    end
    if type(lifetime) ~= "number" then
        error("Sig:LEVEL_AddTimerAsyncProcess(doFunction, interval, lifetime), 参数错误: lifetime必须是number类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 用于立即结束当前stage，标记stage失败。触发调用Stage[x]/onStageFailed.lua
---@param message string 失败原因描述
function LEVEL_AbortLevel(message)
    if type(message) ~= "string" then
        error("Sig:LEVEL_AbortLevel(message),参数错误: message必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 用于立即结束当前LevelStage，标记阶段成功。触发调用Stage[x]/onStageSuccess.lua
---@param message string 成功原因描述
function LEVEL_EndStage(message)
    if type(message) ~= "string" then
        error("Sig:LEVEL_EndStage(message),参数错误: message必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 设置当前阶段的持续时间，从超时时间会显示在玩家屏幕上
---@description 超过该时间后会触发调用LEVEL_AbortLevel("LEVEL TIMEOUT"),触发调用Stage[x]/onStageFailed.lua
---@description 可以多次调用，以最后一次调用为准
---@param timeout number 设置当前阶段持续时间（单位：秒）,从当前时刻开始计时
function LEVEL_SetStageTimeout(timeout)
    if type(timeout) ~= "number" then
        error("Sig:LEVEL_SetStageTimeout(timeout), 参数错误: timeout必须是number类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 注册当前Stage需要击败的NPC，并在process.lua的逻辑执行完成的时候，用于判断Stage是成功完成，还是失败了。
---@description 如果注册的NPC都被击败了，Stage会触发LEVEL_EndStage,stage成功。
---@description 如果注册的NPC没有被击败，Stage会触发LEVEL_AbortLevel,stage失败。
---@description 注意: 无需额外检测，只要注册之后，Level框架会自动判断NPC是否存活,
---@param NpcUUIDs string... 需要击败的NPC的NpcUUID列表, 可以传入多个NpcUUID
function LEVEL_RegisterStageNPCNeedBeat(NpcUUIDs)
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 注册当前Stage需要存活的NPC(比如需要被保护或者护送的NPC)，只要注册的npc死亡，Stage就会立即触发LEVEL_AbortLevel,stage失败。
---@description 如果在process.lua执行完成的时候，注册的NPC都存活，Stage会触发LEVEL_EndStage,stage成功。
---@description 如果任意时刻注册的NPC死亡，Stage会立即触发LEVEL_AbortLevel,stage失败。
---@param NpcUUIDs string... 需要存活的NPC的NpcUUID列表, 可以传入多个NpcUUID
function LEVEL_RegisterStageNPCNeedAlive(NpcUUIDs)
    -- TODO: Implement the function logic here
    return 
end
---@param NpcUUID string NPC的唯一标识符,@Terms.NpcUUID
---@param LocatorID string 坐标定位器的ID,@Terms.LocatorID
---@return number distance NPC与坐标定位器之间的距离,单位为米
function LEVEL_DistanceOfLocator(NpcUUID, LocatorID)
    if type(NpcUUID) ~= "string" then
        error("Sig:LEVEL_DistanceOfLocator(NpcUUID, LocatorID),参数错误: NpcUUID必须是string类型")
    end
    if type(LocatorID) ~= "string" then
        error("Sig:LEVEL_DistanceOfLocator(NpcUUID, LocatorID),参数错误: LocatorID必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 0
end
---@param NpcUUID string NPC的唯一标识符,@Terms.NpcUUID
---@param Pos table 位置信息，表示一个位置，@Terms.Pos
---@return number distance NPC与位置之间的距离,单位为米
function LEVEL_DistanceOfPos(NpcUUID, Pos)
    if type(NpcUUID) ~= "string" then
        error("Sig:LEVEL_DistanceOfPos(NpcUUID, Pos),参数错误: NpcUUID必须是string类型")
    end
    if type(Pos) ~= "table" and Pos ~= nil then
        error("Sig:LEVEL_DistanceOfPos(NpcUUID, Pos), 参数错误: Pos必须是table类型或nil")
    end
    -- TODO: Implement the function logic here
    return 0
end
---@param NpcUUID string NPC的唯一标识符,@Terms.NpcUUID
---@param TargetNpcUUID string 目标NPC的唯一标识符,@Terms.NpcUUID
---@return number distance NPC与目标NPC之间的距离,单位为米
function LEVEL_DistanceOfTarget(NpcUUID, TargetNpcUUID)
    if type(NpcUUID) ~= "string" then
        error("Sig:LEVEL_DistanceOfTarget(NpcUUID, TargetNpcUUID),参数错误: NpcUUID必须是string类型")
    end
    if type(TargetNpcUUID) ~= "string" then
        error("Sig:LEVEL_DistanceOfTarget(NpcUUID, TargetNpcUUID),参数错误: TargetNpcUUID必须是string类型")
    end
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
    if type(taskConfig) ~= "table" and taskConfig ~= nil then
        error("Sig:LEVEL_AddTask(taskConfig), 参数错误: taskConfig必须是table类型或nil")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 用于显示旁白，交代剧情上下文。不能控制其他任何表现，只能显示对话内容。
---@description 会在游戏界面显示对话，同时可以显示说话者的头像，主要用于旁白，剧情交代或者目标说明，比较简单。
---@description 表现是在游戏界面显示对话，会打断玩家的游戏体验,需要玩家点击确认才能继续游戏,一般用于剧情交代，目标说明等。
---@description 对话API选择参考@DialogAPISelection
---@param NpcTID string 说出喊话的人。NpcTID的参数说明@Terms.NpcTID
---@param message string 喊话的内容，阻塞时间由message的长度决定，每秒钟大概显示10个字
---@param emotionID string 说话时的情绪。emotionID的参数说明@Terms.EmotionID
---@param speed number 说话速度，取值越大，语速越快。 范围[0.5,2]，默认值为1.0
function LEVEL_ShowDialog(NpcTID, message, emotionID, speed)
    if type(NpcTID) ~= "string" then
        error("Sig:LEVEL_ShowDialog(NpcTID, message, emotionID, speed),参数错误: NpcTID必须是string类型")
    end
    if type(message) ~= "string" then
        error("Sig:LEVEL_ShowDialog(NpcTID, message, emotionID, speed),参数错误: message必须是string类型")
    end
    if type(emotionID) ~= "string" then
        error("Sig:LEVEL_ShowDialog(NpcTID, message, emotionID, speed),参数错误: emotionID必须是string类型")
    end
    if type(speed) ~= "number" then
        error("Sig:LEVEL_ShowDialog(NpcTID, message, emotionID, speed), 参数错误: speed必须是number类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 控制NpcUUID的NPC对TargetNpcUUID的NPC说message, 说话的NPC头顶显示对话内容，主要用于周边环境渲染，情景渲染等等。不能向Player对话!!!
---@description NPC对话过程中，NpcUUID和无法TargetNpcUUID执行其他AI逻辑。
---@description 目标NPC如果处于死亡状态则不会响应转向
---@description 对话API选择参考@DialogAPISelection
---@param NpcUUID string 说话NPC的唯一标识符 @Terms.NpcUUID
---@param TargetNpcUUID string 目标NPC的UUID @Terms.NpcUUID。当设置为有效值时,NpcUUID的NPC会自动面向目标TargetNpcUUID,TargetNpcUUID也会面向NpcUUID, 直到对话结束
---@param message string 对话内容文本，会显示到NPC的头顶，实际显示时会自动附加NPC名称前缀, 格式<NpcTID: 对话内容>
---@param emotionID string 说话时的情绪。emotionID的参数说明@Terms.EmotionID
---@param speed number 说话速度，取值越大，语速越快。 范围[0.5,2]，默认值为1.0
function LEVEL_ShowMsgBubble(NpcUUID, TargetNpcUUID, message, emotionID, speed)
    if type(NpcUUID) ~= "string" then
        error("Sig:LEVEL_ShowMsgBubble(NpcUUID, TargetNpcUUID, message, emotionID, speed),参数错误: NpcUUID必须是string类型")
    end
    if type(TargetNpcUUID) ~= "string" then
        error("Sig:LEVEL_ShowMsgBubble(NpcUUID, TargetNpcUUID, message, emotionID, speed),参数错误: TargetNpcUUID必须是string类型")
    end
    if type(message) ~= "string" then
        error("Sig:LEVEL_ShowMsgBubble(NpcUUID, TargetNpcUUID, message, emotionID, speed),参数错误: message必须是string类型")
    end
    if type(emotionID) ~= "string" then
        error("Sig:LEVEL_ShowMsgBubble(NpcUUID, TargetNpcUUID, message, emotionID, speed),参数错误: emotionID必须是string类型")
    end
    if type(speed) ~= "number" then
        error("Sig:LEVEL_ShowMsgBubble(NpcUUID, TargetNpcUUID, message, emotionID, speed), 参数错误: speed必须是number类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 检查任务是否完成
---@param taskId string 任务ID，即任务配置taskConfig中的id字段
---@return boolean finished 返回任务是否完成
function LEVEL_IsTaskFinished(taskId)
    if type(taskId) ~= "string" then
        error("Sig:LEVEL_IsTaskFinished(taskId),参数错误: taskId必须是string类型")
    end
    -- TODO: Implement the function logic here
    return false
end
---@description 作用: 设置全局共享的黑板变量，用于跨脚本数据存储与通信
---@description 最常用的情况是通过LEVEL_SummonWithType召唤NPC后，将返回的UUID存入黑板变量，以便后续操作标识
---@description stage结束时自动清除stage周期内的所有的黑板变量
---@param key string 黑板变量键名，字符串类型，推荐使用"stage[x]_key"格式区分LevelStage
---@param value string 需要存储的字符串类型值，非字符串数据需调用tostring()转换
function LEVEL_BlackboardSet(key, value)
    if type(key) ~= "string" then
        error("Sig:LEVEL_BlackboardSet(key, value),参数错误: key必须是string类型")
    end
    if type(value) ~= "string" then
        error("Sig:LEVEL_BlackboardSet(key, value),参数错误: value必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 获取黑板通过LEVEL_BlackboardSet设置的变量
---@param key string 黑板变量键名，字符串类型, 只能使用通过LEVEL_BlackboardSet设置的key
---@return string value 返回字符串值，当键不存在时返回nil
function LEVEL_BlackboardGet(key)
    if type(key) ~= "string" then
        error("Sig:LEVEL_BlackboardGet(key),参数错误: key必须是string类型")
    end
    -- TODO: Implement the function logic here
    return ""
end
---@return number elapsed 返回stage已经进行的时间（单位：秒）
function LEVEL_GetElapsed()
    -- TODO: Implement the function logic here
    return 0
end
---@return number elapsed 返回上一次心跳到现在的时间（单位：秒）
function LEVEL_GetLastTickElapsed()
    -- TODO: Implement the function logic here
    return 0
end
---@description 作用: 将玩家传送到定位器LocatorID标志的位置,快速传送，瞬间完成
---@param LocatorID string 定位器名称,详细介绍参考@Terms.LocatorID
function LEVEL_PlayerTeleportTo(LocatorID)
    if type(LocatorID) ~= "string" then
        error("Sig:LEVEL_PlayerTeleportTo(LocatorID),参数错误: LocatorID必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 将xxxUUID的NPC传送到定位器LocatorID标志的位置，瞬间完成传送，可以认为没有时间消耗。
---@param xxxUUID string 需要传送的NPC的UUID，@Terms.xxxNpcUUID
---@param LocatorID string 定位器名称，详细介绍参考@Terms.LocatorID
function LEVEL_TeleportTo(xxxUUID, LocatorID)
    if type(xxxUUID) ~= "string" then
        error("Sig:LEVEL_TeleportTo(xxxUUID, LocatorID),参数错误: xxxUUID必须是string类型")
    end
    if type(LocatorID) ~= "string" then
        error("Sig:LEVEL_TeleportTo(xxxUUID, LocatorID),参数错误: LocatorID必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 使NPC智能寻路移动，使NpcUUID的NPC移动到TargetUUID的NPC位置，同步执行直到目标地点到达.
---@param NpcUUID string 需要移动的NPC的UUID，@Terms.NpcUUID
---@param TargetNpcUUID string 要移动到的目标NPC的UUID，@Terms.xxxNpcUUID
function LEVEL_NpcMoveToNpc(NpcUUID, TargetNpcUUID)
    if type(NpcUUID) ~= "string" then
        error("Sig:LEVEL_NpcMoveToNpc(NpcUUID, TargetNpcUUID),参数错误: NpcUUID必须是string类型")
    end
    if type(TargetNpcUUID) ~= "string" then
        error("Sig:LEVEL_NpcMoveToNpc(NpcUUID, TargetNpcUUID),参数错误: TargetNpcUUID必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 使NPC智能寻路移动，使NpcUUID的NPC移动到Player当前的附近位置，同步执行直到目标地点到达.
---@param NpcUUID string 需要移动的NPC的UUID，@Terms.NpcUUID
function LEVEL_NpcMoveToPlayer(NpcUUID)
    if type(NpcUUID) ~= "string" then
        error("Sig:LEVEL_NpcMoveToPlayer(NpcUUID),参数错误: NpcUUID必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 使NpcUUIDArray中的NPC移动到TargetUUID的NPC位置，同步执行直到目标地点到达.
---@param NpcUUIDArray string[] 需要移动的NPC的UUID数组，@Terms.NpcUUID
---@param TargetNpcUUID string 要移动到的目标NPC的UUID，@Terms.xxxNpcUUID
function LEVEL_NpcsMoveToNpc(NpcUUIDArray, TargetNpcUUID)
    if type(NpcUUIDArray) ~= "table" and NpcUUIDArray ~= nil then
        error("Sig:LEVEL_NpcsMoveToNpc(NpcUUIDArray, TargetNpcUUID), 参数错误: NpcUUIDArray必须是table类型或nil")
    end
    if type(TargetNpcUUID) ~= "string" then
        error("Sig:LEVEL_NpcsMoveToNpc(NpcUUIDArray, TargetNpcUUID),参数错误: TargetNpcUUID必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 使NpcUUID的NPC移动到定位器LocatorID标志的位置，距离StopDistance停止移动，同步执行直到目标地点到达.
---@param NpcUUID string 需要移动的NPC的UUID，@Terms.NpcUUID
---@param LocatorID string 定位器名称，详细介绍参考@Terms.LocatorID
---@param StopDistance number 距离停止移动的距离
---@param Timeout number 最多移动的时间（单位：秒）,一般根据时间控制移动速度，保证NPC在规定时间内到达目标地点
function LEVEL_NpcMoveToLocator(NpcUUID, LocatorID, StopDistance, Timeout)
    if type(NpcUUID) ~= "string" then
        error("Sig:LEVEL_NpcMoveToLocator(NpcUUID, LocatorID, StopDistance, Timeout),参数错误: NpcUUID必须是string类型")
    end
    if type(LocatorID) ~= "string" then
        error("Sig:LEVEL_NpcMoveToLocator(NpcUUID, LocatorID, StopDistance, Timeout),参数错误: LocatorID必须是string类型")
    end
    if type(StopDistance) ~= "number" then
        error("Sig:LEVEL_NpcMoveToLocator(NpcUUID, LocatorID, StopDistance, Timeout), 参数错误: StopDistance必须是number类型")
    end
    if type(Timeout) ~= "number" then
        error("Sig:LEVEL_NpcMoveToLocator(NpcUUID, LocatorID, StopDistance, Timeout), 参数错误: Timeout必须是number类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 使NpcUUIDArray中的NPC移动到定位器LocatorID标志的位置，距离StopDistance停止移动，最多移动Timeout秒，同步执行直到目标地点到达.
---@param NpcUUIDArray string[] 需要移动的NPC的UUID数组，@Terms.NpcUUID
---@param LocatorID string 定位器名称，详细介绍参考@Terms.LocatorID
---@param StopDistance number 距离停止移动的距禽
---@param Timeout number 最多移动的时间（单位：秒）,一般根据时间控制移动速度，保证NPC在规定时间内到达目标地点
function LEVEL_NpcsMoveToLocator(NpcUUIDArray, LocatorID, StopDistance, Timeout)
    if type(NpcUUIDArray) ~= "table" and NpcUUIDArray ~= nil then
        error("Sig:LEVEL_NpcsMoveToLocator(NpcUUIDArray, LocatorID, StopDistance, Timeout), 参数错误: NpcUUIDArray必须是table类型或nil")
    end
    if type(LocatorID) ~= "string" then
        error("Sig:LEVEL_NpcsMoveToLocator(NpcUUIDArray, LocatorID, StopDistance, Timeout),参数错误: LocatorID必须是string类型")
    end
    if type(StopDistance) ~= "number" then
        error("Sig:LEVEL_NpcsMoveToLocator(NpcUUIDArray, LocatorID, StopDistance, Timeout), 参数错误: StopDistance必须是number类型")
    end
    if type(Timeout) ~= "number" then
        error("Sig:LEVEL_NpcsMoveToLocator(NpcUUIDArray, LocatorID, StopDistance, Timeout), 参数错误: Timeout必须是number类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@param NpcUUID string 需要移动的NPC的UUID，@Terms.NpcUUID
---@param LocatorID string 定位器名称，详细介绍参考@Terms.LocatorID
---@return boolean arrived 返回NpcUUID的NPC是否到达定位器LocatorID标志的位置
function LEVEL_NpcIsArrived(NpcUUID, LocatorID)
    if type(NpcUUID) ~= "string" then
        error("Sig:LEVEL_NpcIsArrived(NpcUUID, LocatorID),参数错误: NpcUUID必须是string类型")
    end
    if type(LocatorID) ~= "string" then
        error("Sig:LEVEL_NpcIsArrived(NpcUUID, LocatorID),参数错误: LocatorID必须是string类型")
    end
    -- TODO: Implement the function logic here
    return false
end
---@description 作用: 生成指定类型的NPC实体，支持定点召唤或玩家周围随机位置生成(自动适配玩家周围)。如果后面需要用到这个NPC的UUID，将返回的UUID通过LEVEL_BlackboardSet存入黑板变量
---@param NpcTID string NPC配置表中的NPC类型ID,参考@Terms.NpcTID
---@param LocatorID string 定位器名称（空字符串时在玩家周围随机生成）,详细介绍参考@Terms.LocatorID
---@return string NpcUUID 生成的NPC唯一UUID，用于后续操作标识,参考@Terms.NpcUUID
function LEVEL_SummonWithType(NpcTID, LocatorID)
    if type(NpcTID) ~= "string" then
        error("Sig:LEVEL_SummonWithType(NpcTID, LocatorID),参数错误: NpcTID必须是string类型")
    end
    if type(LocatorID) ~= "string" then
        error("Sig:LEVEL_SummonWithType(NpcTID, LocatorID),参数错误: LocatorID必须是string类型")
    end
    -- TODO: Implement the function logic here
    return ""
end
---@description 作用: 一次生成多个指定的NPC实体，其他参考@LEVEL_SummonWithType
---@param NpcTID string NPC配置表中的NPC类型ID,参考@Terms.NpcTID
---@param count number 生成的NPC数量
---@param LocatorID string 定位器名称（空字符串时在玩家周围随机生成）,详细介绍参考@Terms.LocatorID
---@return string[] NpcUUIDArray 生成的NPC唯一UUID数组，用于后续操作标识,参考@Terms.NpcUUID
function LEVEL_SummonNPCsWithType(NpcTID, count, LocatorID)
    if type(NpcTID) ~= "string" then
        error("Sig:LEVEL_SummonNPCsWithType(NpcTID, count, LocatorID),参数错误: NpcTID必须是string类型")
    end
    if type(count) ~= "number" then
        error("Sig:LEVEL_SummonNPCsWithType(NpcTID, count, LocatorID), 参数错误: count必须是number类型")
    end
    if type(LocatorID) ~= "string" then
        error("Sig:LEVEL_SummonNPCsWithType(NpcTID, count, LocatorID),参数错误: LocatorID必须是string类型")
    end
    -- TODO: Implement the function logic here
    return nil
end
---@description 作用: 在定位器LocatorID标志的位置掉落物品ItemTID，数量为count。
---@param ItemTID string 物品的模板ID，参考@Terms.ItemTID
---@param count number 掉落物品的数量
---@param LocatorID string 定位器名称，详细介绍参考@Terms.LocatorID
---@param notPosRand boolean true时在精确位置生成，false时在半径5米内随机位置
function LEVEL_DropItem(ItemTID, count, LocatorID, notPosRand)
    if type(ItemTID) ~= "string" then
        error("Sig:LEVEL_DropItem(ItemTID, count, LocatorID, notPosRand),参数错误: ItemTID必须是string类型")
    end
    if type(count) ~= "number" then
        error("Sig:LEVEL_DropItem(ItemTID, count, LocatorID, notPosRand), 参数错误: count必须是number类型")
    end
    if type(LocatorID) ~= "string" then
        error("Sig:LEVEL_DropItem(ItemTID, count, LocatorID, notPosRand),参数错误: LocatorID必须是string类型")
    end
    if type(notPosRand) ~= "boolean" then
        error("Sig:LEVEL_DropItem(ItemTID, count, LocatorID, notPosRand), 参数错误: notPosRand必须是boolean类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 比如检查stage目标是否完成，比如消灭所有怪物。
---@param NpcTID string NPC的模板ID，参考@Terms.NpcTID
---@return number count 返回指定NpcTID存活的NPC数量，如果NpcTID为空，则返回所有NPC数量
function LEVEL_GetAliveNpcCount(NpcTID)
    if type(NpcTID) ~= "string" then
        error("Sig:LEVEL_GetAliveNpcCount(NpcTID),参数错误: NpcTID必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 0
end
---@description 作用: 获得NpcUUIDArray中的活着的npc数量
---@description 使用场景: 比如检查stage目标是否完成，消灭指定的怪物。
---@param NpcUUIDArray string[] 需要查询的NPC的UUID数组，@Terms.NpcUUID
---@return number count 返回NpcUUIDArray中存活的NPC数量
function LEVEL_GetArrayAliveNpcCount(NpcUUIDArray)
    if type(NpcUUIDArray) ~= "table" and NpcUUIDArray ~= nil then
        error("Sig:LEVEL_GetArrayAliveNpcCount(NpcUUIDArray), 参数错误: NpcUUIDArray必须是table类型或nil")
    end
    -- TODO: Implement the function logic here
    return 0
end
---@param NpcUUID string 需要查询的NPC的UUID，@Terms.NpcUUID
---@return boolean alive 返回UUID的NPC是否活着
function LEVEL_IsNpcAlive(NpcUUID)
    if type(NpcUUID) ~= "string" then
        error("Sig:LEVEL_IsNpcAlive(NpcUUID),参数错误: NpcUUID必须是string类型")
    end
    -- TODO: Implement the function logic here
    return false
end
---@return boolean alive 返回玩家是否活着
function LEVEL_IsPlayerAlive()
    -- TODO: Implement the function logic here
    return false
end
---@description 作用: NPC表演战斗情景使用！！使NpcUUID的NPC与TargetNpcUUID的NPC互相战斗表演，但是NPC和目标NPC都不会死亡!!!!
---@param NpcUUID string NPC的UUID，@Terms.NpcUUID
---@param TargetNpcUUID string 目标NPC的UUID(禁止使用Player/player), @Terms.NpcUUID
function LEVEL_NpcPerformBattle(NpcUUID, TargetNpcUUID)
    if type(NpcUUID) ~= "string" then
        error("Sig:LEVEL_NpcPerformBattle(NpcUUID, TargetNpcUUID),参数错误: NpcUUID必须是string类型")
    end
    if type(TargetNpcUUID) ~= "string" then
        error("Sig:LEVEL_NpcPerformBattle(NpcUUID, TargetNpcUUID),参数错误: TargetNpcUUID必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 使NpcUUID的NPC立即释放一次技能SkillTID,注意只释放一次,并且等到技能释放完毕
---@param NpcUUID string NPC的UUID，@Terms.NpcUUID
---@param SkillTID string 技能系统的模板ID，参考@Terms.SkillTID,如果技能需要释放目标，API会自动帮助NPC选择合适的目标
function LEVEL_NpcCastSkill(NpcUUID, SkillTID)
    if type(NpcUUID) ~= "string" then
        error("Sig:LEVEL_NpcCastSkill(NpcUUID, SkillTID),参数错误: NpcUUID必须是string类型")
    end
    if type(SkillTID) ~= "string" then
        error("Sig:LEVEL_NpcCastSkill(NpcUUID, SkillTID),参数错误: SkillTID必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 批量控制NPC释放技能
---@param NpcUUIDArray string[] 需要释放技能的NPC的UUID数组，@Terms.NpcUUID
---@param SkillTID string 技能的模板ID，参考@Terms.SkillTID
---@param randomTarget boolean 是否随机目标
---@param wait boolean 是否等待所有人技能释放完毕
function LEVEL_NpcsCastSkill(NpcUUIDArray, SkillTID, randomTarget, wait)
    if type(NpcUUIDArray) ~= "table" and NpcUUIDArray ~= nil then
        error("Sig:LEVEL_NpcsCastSkill(NpcUUIDArray, SkillTID, randomTarget, wait), 参数错误: NpcUUIDArray必须是table类型或nil")
    end
    if type(SkillTID) ~= "string" then
        error("Sig:LEVEL_NpcsCastSkill(NpcUUIDArray, SkillTID, randomTarget, wait),参数错误: SkillTID必须是string类型")
    end
    if type(randomTarget) ~= "boolean" then
        error("Sig:LEVEL_NpcsCastSkill(NpcUUIDArray, SkillTID, randomTarget, wait), 参数错误: randomTarget必须是boolean类型")
    end
    if type(wait) ~= "boolean" then
        error("Sig:LEVEL_NpcsCastSkill(NpcUUIDArray, SkillTID, randomTarget, wait), 参数错误: wait必须是boolean类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 强制NPC进入死亡状态
---@param NpcUUID string NPC的UUID，@Terms.NpcUUID
---@param dieMsg string 死亡喊话(可选),NPC死亡时的喊话,会显示在NPC的头顶
function LEVEL_NpcDie(NpcUUID, dieMsg)
    if type(NpcUUID) ~= "string" then
        error("Sig:LEVEL_NpcDie(NpcUUID, dieMsg),参数错误: NpcUUID必须是string类型")
    end
    if type(dieMsg) ~= "string" then
        error("Sig:LEVEL_NpcDie(NpcUUID, dieMsg),参数错误: dieMsg必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 控制玩家攻击功能的开关。使用场景: 剧情过场时禁止玩家战斗操作
---@param enable boolean 控制玩家攻击功能的开关。enable为true则可以攻击，false则不可以攻击
function LEVEL_EnablePlayerAttack(enable)
    if type(enable) ~= "boolean" then
        error("Sig:LEVEL_EnablePlayerAttack(enable), 参数错误: enable必须是boolean类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 摄像机跟随xxxUUID的NPC，主要用于镜头控制，NPC表演，玩家观察等等
---@param xxxUUID string NPC的UUID或者Player，@Terms.xxxNpcUUID
function LEVEL_CameraFollow(xxxUUID)
    if type(xxxUUID) ~= "string" then
        error("Sig:LEVEL_CameraFollow(xxxUUID),参数错误: xxxUUID必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 给玩家发奖励，ItemTID为奖励物品的类型，count为数量。
---@param ItemTID string 奖励物品的类型，参考@Terms.ItemTID
function LEVEL_Award(ItemTID)
    if type(ItemTID) ~= "string" then
        error("Sig:LEVEL_Award(ItemTID, count),参数错误: ItemTID必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
---@description 作用: 记录日志，用于调试和记录关键信息
---@param message string 日志内容
function LEVEL_Log(message)
    if type(message) ~= "string" then
        error("Sig:LEVEL_Log(message),参数错误: message必须是string类型")
    end
    -- TODO: Implement the function logic here
    return 
end
