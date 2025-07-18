-- LEVEL_AddTask的参数taskConfig的完整示例与参数要求

local taskConfig = {
    -- id为任务ID（TaskID），是任务的唯一标识
    id = "stage1_task2",
    -- desc是任务的描述，会显示在游戏屏幕的'任务信息'中,用于给玩家提供指引
    desc = "寻找古籍",
    -- stageId是任务所在的关卡阶段ID，不能为空
    stageId = 1,
    -- NpcUUID是任务的发布者的UUID(注意不是TID，是UUID,@Terms.NpcUUID), 如果为空的话，任务会直接接取，不需要对话，也不需要交任务，满足条件时直接完成。
    NpcUUID = "Stage1_Wolf1",
    -- type是任务的类型，目前有"TaskType.KillMonster"（击杀怪物）, "TaskType.None"（对话任务，对话即可完成任务), "TaskType.MoveTo" (移动到指定位置)
    type = "TaskType.KillMonster",
    -- param是任务的参数，根据任务类型不同，参数也不同
    -- TaskType.None: param是一个table, 为空即可。
    -- TaskType.KillMonster: param是一个table，table的第一个元素是NpcTID(@Terms.NpcTID)，第二个元素是怪物的数量
    -- TaskType.MoveTo: param是一个table。table的第一个参数是目标类型(可选为1、2),分别代表: 1是NPC类型目标，此时第二个参数是NpcUUID;2是坐标类型目标，第二个参数是LocatorID@Terms.LocatorID. 比如 param={2,"locator_wolf_dead"}
    -- 参数结构校验表:
    -- | 任务类型         | param结构                  | 示例                     |
    -- |------------------|---------------------------|--------------------------|
    -- | TaskType.None     | {}                        | {}                       |
    -- | TaskType.KillMonster | {NpcTID(string), count(int)} | {"狼", 5}               |
    -- | TaskType.MoveTo    | {type(int), target(string)} | {2, "locator_palace"}   |
    param = {"狼", 1},
    -- reward是任务的奖励。奖励是一个table，table的第一个元素是奖励的物品TID ItemTID，第二个元素是奖励的数量
    reward = {"回复水晶", 1},
    -- autoChat是对话是否自动播放，如果为true，对话会自动播放，如果为false，需要玩家点击按钮才能继续对话。如果需要在单句对话中设置不同的语速，可以在`preChat`, `finishChat`等对话条目中设置第四个参数。
    autoChat = false,
    -- preTask是任务的前置任务，是一个table，table的元素是前置任务的taskID。如果设置了前置任务taskID,如果没有完成前置任务,当前任务不会生效和显示；当前置任务完成时，当前任务才会生效并且显示。如果没有前置任务，preTask为空table。
    preTask = {"stage1_task1"},
    -- preChat是任务的前置对话，是一个table，table的元素是一个table。
    -- 其中第一个元素是说话的人TID(NpcTID/Player,不同于上面的NpcUUID)
    -- 第二个元素是说话内容
    -- 第三个元素是情绪ID @Terms.EmotionID
    -- 第四个元素是说话速度，取值越大，语速越快。 范围[0.5,2]，默认值为1.0。
    preChat = {
        { "Player", "你知道希望之星的事情吗？", "neutral", 1.0 },
        { "收藏家", "希望之星？我记得我这里有一本古籍记载了一些关于希望之星的事情。", "neutral", 1.0 },
        { "Player", "那能借我看看吗？", "neutral", 1.0 },
        { "收藏家", "当然可以，不过我最近有点事情要忙，你能帮我找一下我的另一本古籍吗？", "neutral", 1.0 },
        { "Player", "好的，你的另一本古籍在哪里？", "happy", 1.0 },
        { "收藏家", "我记得我把它放在了我的书房里，你去找找看吧", "neutral", 1.0 },
    },
    -- notFinishChat是任务未完成时的对话，是一个table，table的元素是一个table。
    -- 其中第一个元素是说话的人TID(NpcTID/Player)
    -- 第二个元素是说话内容
    -- 第三个元素是情绪ID @Terms.EmotionID
    -- 第四个元素是说话速度，取值越大，语速越快。 范围[0.5,2]，默认值为1.0
    notFinishChat = {
        { "收藏家", "再找找看吧", "neutral", 1.0 },
    },
    -- finishChat是任务完成时的对话，是一个table，table的元素是一个table。
    -- 其中第一个元素是说话的人TID(NpcTID/Player)
    -- 第二个元素是说话内容
    -- 第三个元素是情绪ID @Terms.EmotionID
    -- 第四个元素是说话速度，取值越大，语速越快。 范围[0.5,2]，默认值为1.0
    finishChat = {
        { "收藏家", "对，就是他。希望他可以帮到你", "happy", 1.0 },
    },
}