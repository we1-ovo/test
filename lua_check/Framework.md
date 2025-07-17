## RPG游戏项目结构

### 扩展性设计

该项目结构设计具有高度的模块化和可扩展性:

1. **文档驱动开发**: 设计文档定义游戏内容，代码实现游戏逻辑，支持迭代开发
2. **分层架构**: Framework层提供基础API，业务逻辑与数据分离
3. **模块化设计**: 
   - 新增关卡: 在docs/中添加设计，在Level/中添加实现
   - 新增技能: 在docs/skills/中使用SkillTID添加设计，在Skill/中实现
   - 新增NPC: 在docs/npcs/中使用NpcTID命名添加设计，在NPC/和Prof/中实现

此结构设计支持多个Agent协同工作，通过明确的接口和依赖关系，确保各部分可独立开发并顺利集成。同时，基于文档驱动的方法使得项目更容易维护和扩展，新功能可以遵循已有模式快速集成。

### 模块依赖关系

1. **文档依赖链**:
   - requirement.md → WriteGamePrd.md  → WriteNumericalPrd.md → WriteLevelPrd.md
   - WriteLevelPrd.md → 
     - WriteMapPrd.md → WriteMapData.md
     - WriteLevelTasks.md
     - docs/npcs/[NpcTID].md, player.md → docs/skills/[SkillTID].md
   - docs/npcs/[NpcTID].md → GenRPG/NPC/[NpcTID]/onUpdateStrategy.lua, GenRPG/Prof/[NpcTID].lua
   - docs/skills/[SkillTID].md → GenRPG/Skill/[SkillTID].lua
   - docs/WriteLevelTask.md → GenRPG/Level/stage[1-9]/*.lua
   - player.md → GenRPG/Prof/player.lua

2. **代码依赖链**:
   - Framework/ (核心API层)
     - LevelApiFull.lua ← GenRPG/Level/ (关卡系统)
     - AIApiFull.lua ← GenRPG/NPC/ (AI系统)
     - SkillApiFull.lua ← GenRPG/Skill/ (技能系统)
   - GenRPG/Level/ (关卡实现)
     - ← GenRPG/NPC/ (NPC行为)
     - ← GenRPG/Skill/ (技能系统)
     - ← GenRPG/Prof/ (角色定义)
     - ← GenRPG/Locator/ (位置系统)
   - GenRPG/NPC/ (NPC实现)
     - ← GenRPG/Skill/ (技能系统)
     - ← GenRPG/Prof/ (角色定义)
     - ← GenRPG/Locator/ (位置系统)

3. **资源依赖链**:
   - WriteMapData.md → map_output/ (地图资源生成)
   - map_output/ → GenRPG/Level/ (关卡地图使用)
   - user_asset/ → map_output/ (用户自定义资源)

4. **每个系统只能调用自己的API**:
   - Level系统只能调用lua_check/level.lua
   - AI系统只能调用lua_check/ai.lua
   - Skill系统只能调用lua_check/skill.lua
   - Item系统只能调用lua_check/item.lua

5. **具体参数需求查看API文件和examples**:
   - 每个API文件中都有详细的参数需求说明
   - 例如，lua_check/level.lua中定义了Level系统的API和参数要求
   - 具体的配置示例可以在lua_check/item_config_example.lua、lua_check/level_task_config_example.lua等文件中找到

## 完整目录结构

```
工程根目录/
├── docs/                                        - 设计文档集合 (~250+ KB，共15-20个文件)
│   ├── requirement.md                           - 原始用户需求规格文档 (~20KB)
│   ├── WriteGamePrd.md                        - 游戏产品需求文档 (~12KB)
│   ├── WriteLevelPrd.md                       - 关卡整体的设计文档 (~30KB)
│   ├── WriteMapPrd.md                         - 地图设计文档 (~32KB)
│   ├── player.md                              - 玩家角色设计文档 (~6KB)
│   ├── WriteNumericalPrd.md                   - 数值系统设计数据 (~3.5KB)
│   ├── WriteLevelTasks.md                     - 关卡Level模块程序设计任务分解文档 (~11KB)
│   ├── WriteMapData.md                        - 地图数据详细定义 (~31KB)
│   ├── skills/                                  - 技能设计目录,文件名使用SkillTID构成，*.md
│   └── npcs/                                    - NPC详细设计目录,文件名使用NpcTID构成，*.md
├── GenRPG/                                      - 游戏代码核心 (~150+ 文件，约60-80KB代码)
│   ├── Framework/                               - 框架代码API
│   │   ├── LevelApiFull.lua                     - 关卡Level系统接口 (~19KB, 311行)
│   │   ├── AIApiFull.lua                        - AI行为控制接口 (~11KB, 243行)
│   │   ├── SkillApiFull.lua                     - 技能Skill系统接口 (~16KB, 381行)
│   ├── Skill/                                   - 技能实现 (~60个文件),文件名使用SkillTID构成，*.lua
│   ├── NPC/                                     - NPC AI行为 (~7-10个子目录),每个目录名为NpcTID组成，每个目录为一个对应的NPC的lua代码实现，如'暗影狼/onUpdateStrategy.lua'
│   ├── Level/                                   - 关卡实现 (有几个关卡就有几子目录)
│   │   ├── stage1/                              - 第一关卡
│   │   │   ├── process.lua                      - 关卡主流程 (~10KB)
│   │   │   ├── onStageSuccess.lua               - 关卡成功处理 (~1KB)
│   │   │   └── onStageFailed.lua                - 关卡失败处理 (~1KB)
│   │   ├── stageN/                              - 第N关卡
│   │   │   ├── process.lua                      - 关卡主流程 (~10KB)
│   │   │   ├── onStageSuccess.lua               - 关卡成功处理 (~1KB)
│   │   │   └── onStageFailed.lua                - 关卡失败处理 (~1KB)
│   ├── Prof/                                    - 职业和角色定义 (~8-10个文件),文件名使用NpcTID构成，*.lua,另外有一个player.lua
│   └── Locator/                                 - 
|       |── Locator.Lua                          - 所有的Level,NPC使用的locator的定义(~2KB)
├── map_output/                                  - 地图资源文件 (~500+ MB)
│   ├── scene1/                                  - 场景1资源
│   │   └── map.zip                              - 场景1地图包
│   ├── scene2/                                  - 场景2资源
│   │   └── map.zip                              - 场景2地图包
│   └── scene3/                                  - 场景3资源
│       └── map.zip                              - 场景3地图包
├── user_asset/                                  - 用户资源文件 (变量大小)
├── lua_check/
│   ├── main.lua                        # 主入口文件，循环检测器
│   ├── comprehensive_checker.lua       # 综合检查器，目录结构验证
│   ├── validation.lua                  # 统一验证模块，参数验证配置
│   ├── function_call_checker.lua       # 函数调用检查器
│   ├── resource_validator.lua          # 资源验证器，加载GenRPG资源
│   ├── item_checker.lua                # Item文件专用检查器
│   ├── level.lua                       # Level系统API模拟和验证
│   ├── ai.lua                          # AI系统API模拟和验证
│   ├── skill.lua                       # Skill系统API模拟和验证
│   ├── item.lua                        # Item系统API模拟和验证
│   ├── test_simple.lua                 # 测试示例文件
│   └── level_task_config_example.lua   # 任务配置示例和参数要求
│   └── item_config_example.lua         # 物品配置示例和参数要求
│   └── npc_player_prof_config_example.lua   # NPC/Player属性配置示例和参数要求
```

## 代码与文档详解

### docs/ 目录 (设计文档)

总容量约250+KB，包含15-20个设计文档文件，为开发团队提供指导。

#### 核心设计文档

##### requirement.md (~20KB):
- 原始用户需求规格文档
- 定义游戏基础设定和机制
- 作为整个项目的起点，直接驱动WriteGamePrd.md的创建

##### WriteGamePrd.md (~12KB):
- 游戏产品需求文档
- 详细描述游戏主题、风格、情感板、表现风格和游戏机制
- 定义游戏世界背景、场景描述和NPC系统
- 基于requirement.md创建，并驱动WriteNumericalPrd.md的设计

##### WriteNumericalPrd.md (~3.5KB):
- 数值系统设计数据
- 定义不同实体类型的数值参数和公式
- 为整个游戏系统提供数值平衡基础
- 是WriteLevelPrd.md的前置设计文档

##### WriteLevelPrd.md (~30KB):
- 关卡整体设计文档
- 基于WriteNumericalPrd.md的数值设计
- 规划整体关卡结构、流程和体验
- 驱动WriteMapPrd.md和WriteLevelTasks.md的创建

##### WriteMapPrd.md (~32KB):
- 地图设计文档
- 基于WriteLevelPrd.md的关卡需求
- 详细描述游戏地图的布局、环境和交互元素
- 直接驱动WriteMapData.md的生成

##### WriteLevelTasks.md (~11KB):
- 关卡任务描述文档
- 基于WriteLevelPrd.md设计
- 完成关卡Level的代码工程结构设计 GenRPG/Level
- 完成Level的每个Stage的每个文件的实现细节的设计，具体使用的API，以及需要Skill和AI系统如何配合的说明

##### WriteMapData.md (~31KB):
- 地图数据详细定义
- 由WriteMapPrd.md直接驱动生成
- 包含地图元素的精确坐标和属性
- 直接用于生成map_output/目录下的地图资源

##### player.md (~6KB):
- 玩家角色设计文档
- 基于WriteLevelPrd.md的设计需求
- 定义玩家角色的属性、技能和初始装备
- 与docs/skills/目录协同，定义玩家可用技能
- 直接对应GenRPG/Prof/player.lua实现

#### docs子目录

##### docs/npcs/ (若干文件):
- NPC详细设计目录,文件名使用NpcTID构成，*.md
- 基于WriteLevelTasks.md的NPC需求
- 每个[NpcTID].md定义具体NPC的属性、行为和技能
- 直接对应GenRPG/NPC/[NpcTID]/onUpdateStrategy.lua和GenRPG/Prof/[NpcTID].lua实现

##### docs/skills/ (若干文件):
- 技能设计目录,文件名使用SkillTID构成，*.md
- 依赖于player.md和docs/npcs/[NpcTID].md
- 包含每个技能的详细设计和数值平衡
- 每个[SkillTID].md文件直接对应GenRPG/Skill/[SkillTID].lua实现

### GenRPG/ 目录 (核心游戏代码)

总代码量约60-80KB，包含约150+个Lua脚本文件，是游戏引擎的核心部分。

#### Framework/ 子目录

- **作用**: 提供游戏的基础框架和核心API接口
- **文件数量**: 3个主要接口文件，各约10-20KB
- **主要文件**:
  - LevelApiFull.lua (~19KB): 提供关卡系统接口，被Level/目录中的脚本使用
  - AIApiFull.lua (~11KB): 提供NPC行为控制和AI决策的接口，被NPC/目录中的脚本调用
  - SkillApiFull.lua (~16KB): 定义技能系统接口，被Skill/目录中的脚本引用
- **相互关系**: 框架API文件各自独立，被对应功能模块直接调用

#### Skill/ 子目录

- **作用**: 实现游戏中所有技能的逻辑和效果
- **文件数量**: 约60个文件，文件名使用SkillTID构成，*.lua
- **代码特点**: 每个技能文件约0.5-4KB，总计约40-50KB
- **主要组成**: 每个技能文件包含init()和cb()函数，定义技能参数和效果
- **相互关系**: 技能实现依赖SkillApiFull.lua提供的接口

#### NPC/ 子目录

- **作用**: 定义游戏中各类NPC的行为AI和决策逻辑
- **文件结构**: 约7-10个目录，每个目录名为NpcTID组成，包含该NPC的AI实现代码
- **核心文件**: 每个NPC目录包含onUpdateStrategy.lua等AI行为脚本
- **代码特点**: AI脚本实现基于AIApiFull.lua，使用Skill系统和Prof定义
- **相互关系**: 依赖AIApiFull.lua、Skill/、Prof/和Locator/目录

#### Prof/ 子目录

- **作用**: 定义游戏中所有职业和角色的基础属性和能力
- **文件数量**: 约8-10个角色定义文件，文件名使用NpcTID构成，*.lua，另有player.lua
- **代码特点**: 每个文件约0.8-2KB，定义基础属性和技能集
- **相互关系**: 被NPC/和Level/目录中的代码引用

#### Level/ 子目录

- **作用**: 实现游戏的关卡流程、事件触发和任务系统
- **结构特点**: 有几个关卡就有几个子目录，每个关卡对应一个子目录
- **核心文件**:
  - process.lua (~10KB): 关卡主流程控制
  - onStageSuccess.lua (~1KB): 关卡成功处理逻辑
  - onStageFailed.lua (~1KB): 关卡失败处理逻辑
- **相互关系**: 依赖LevelApiFull.lua接口，调用NPC/、Skill/、Prof/和Locator/模块

#### Locator/ 子目录

- **作用**: 提供位置定位系统
- **核心文件**: Locator.lua (~2KB) - 所有Level和NPC使用的位置定义
- **相互关系**: 被NPC/和Level/目录的代码引用

### 资源与辅助目录

#### map_output/ 目录 (地图资源)

- **作用**: 存储生成的游戏地图资源
- **容量**: 约500+ MB，主要是3D模型和纹理数据
- **组织结构**: 按场景名称划分为多个子目录，每个包含一个map.zip
- **生成过程**: 基于docs/map_data_pcg/和WriteMapData.md自动生成
- **相互关系**: 被Level/目录引用，提供游戏的视觉和交互环境

#### user_asset/ 目录 (用户资源)

- **作用**: 存储用户提供的额外资源
- **容量**: 变量大小，通常为几十到几百MB
- **内容类型**: 可能包含自定义模型、贴图、音效等
- **相互关系**: 与map_output/结合用于游戏场景构建