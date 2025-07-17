# Lua Code Checker (`lua_check`)

`lua_check` 是一个为 `GenRPG` 项目定制的静态代码分析工具。它旨在通过在不实际运行游戏的情况下扫描Lua源代码，来提前发现潜在的错误和不规范的写法。

## 工作原理与调用流程

`lua_check` 的核心思想是 **API模拟** 和 **多层验证**。它首先加载一系列模拟的游戏API，然后逐层对项目结构和代码内容进行扫描和验证。

```mermaid
graph TD
    A[main.lua<br/>(入口)] --> B{ComprehensiveChecker<br/>(综合检查器)};
    B --> C{结构检查<br/>(目录/文件是否齐全?)};
    B --> D{FunctionCallChecker<br/>(函数调用检查器)};
    C --> F[(错误汇总<br/>GlobalErrorCollector)];
    D --> E{ValidationModule<br/>(参数验证模块)};
    E --> F;
```

lua_check/
├── main.lua                        # 主入口文件，循环检测器
├── comprehensive_checker.lua       # 综合检查器，目录结构验证
├── validation.lua                  # 统一验证模块，参数验证配置
├── function_call_checker.lua       # 函数调用检查器
├── resource_validator.lua          # 资源验证器，加载GenRPG资源
├── item_checker.lua                # Item文件专用检查器
├── level.lua                       # Level系统API模拟和验证
├── ai.lua                          # AI系统API模拟和验证
├── skill.lua                       # Skill系统API模拟和验证
├── item.lua                        # Item系统API模拟和验证
├── test_simple.lua                 # 测试示例文件
└── level_task_config_example.lua   # 任务配置示例和参数要求
└── item_config_example.lua         # 物品配置示例和参数要求
└── npc_player_prof_config_example.lua   # NPC/Player属性配置示例和参数要求


1.  **启动与初始化 (`main.lua`)**:
    *   作为入口，`main.lua` 负责加载所有必要的检查器模块。
    *   它会加载 `lua_check/skill.lua`, `lua_check/item.lua`, `lua_check/ai.lua` 等文件，这些文件共同构建了一个模拟的游戏API环境，让检查器知道哪些函数是合法的，以及它们期望的参数是怎样的。
    *   同时，它会初始化一个全局错误收集器 `GlobalErrorCollector`，用于存放所有检查过程中发现的问题。

2.  **综合检查 (`ComprehensiveChecker`)**:
    *   这是检查工作的“总指挥”。它首先进行 **项目结构检查**，验证 `GenRPG/` 目录下的 `Level`, `NPC`, `Prof` 等子目录是否完整，以及是否包含所有必需的文件（如 `process.lua`, `onUpdateStrategy.lua` 等）。
    *   结构检查完毕后，它会收集所有需要分析的 `.lua` 文件，并将它们逐一交给 `FunctionCallChecker` 进行深度分析。

3.  **函数调用检查 (`FunctionCallChecker`)**:
    *   这是代码分析的核心。它会解析Lua代码，并精确地找出所有对已知API的函数调用（即使调用写成了多行）。
    *   对于每一个函数调用，它都会进行参数验证。

4.  **参数验证 (`ValidationModule` & `ResourceValidator`)**:
    *   这是最底层的验证逻辑。`FunctionCallChecker` 会调用它来验证函数参数的正确性。
    *   它不仅检查参数的 **数量** 是否正确，还会检查参数的 **内容**。例如，验证一个传入的技能ID是否真的存在于 `GenRPG/Skill` 目录下，或者验证一个复杂的配置表格中的字段是否都符合规范。

5.  **错误汇总**:
    *   所有检查器在发现问题时，都会将错误信息发送到 `GlobalErrorCollector`。
    *   在所有检查结束后，`main.lua` 会将收集到的所有错误进行格式化输出，生成最终的检查报告。

## 能检查的错误类型

该工具能够覆盖从项目结构到代码细节的多种常见错误：

### 1. 项目结构错误
- **目录缺失**: 检查核心目录是否存在，如 `Level/`, `NPC/`, `Prof/`。
- **必需文件缺失**:
    - `Level` 关卡目录缺少 `process.lua`, `onStageSuccess.lua` 或 `onStageFailed.lua`。
    - `NPC` 目录缺少 `onUpdateStrategy.lua`。
    - `Prof` 目录缺少 `player.lua`。

### 2. 函数调用错误
- **未知函数**: 调用了未在API中定义的函数。
- **参数数量不匹配**: 函数调用时提供的参数数量与API定义的数量不符。
  *示例: `LEVEL_AddDialog(1, "你好")`，但函数定义需要3个参数。*

### 3. 资源引用错误
- **无效的资源ID**: 在函数调用中使用了不存在的 `NpcTID`, `SkillTID`, `ItemTID` 等。
  *示例: `AI_Summon(1001, "不存在的怪物")`，而ID为 "不存在的怪物" 的NPC并未在 `GenRPG/Prof` 中定义。*

### 4. 参数内容错误
- **配置表格式错误**: 针对某些接受复杂表格作为参数的函数（如 `LEVEL_AddTask`），工具会深入检查表格内部的字段是否正确、完整。
  *示例: 传递给 `LEVEL_AddTask` 的任务配置表中，缺少了必需的 `Target` 字段。*
- **无效的枚举值**: 检查传入的参数是否在预设的合法值范围内。
  *示例: `AI_SetStance("SLEEP")`，但合法的姿态只有 "GUARD", "PATROL", "ATTACK"。*


## 如何运行

⚠️ **重要**: 本工具必须在项目的根目录下执行，而 **不能** 在 `lua_check/` 目录内执行。

这是因为检查器需要根据根目录来正确解析和定位 `GenRPG/` 目录下的所有资源文件（如技能、NPC、物品等）。在错误的目录执行会导致路径计算错误，从而产生大量的误报。

推荐使用 `Makefile` 来运行检查，它提供了封装好的便捷命令。

```bash
# 检查所有 GenRPG 下的文件 (推荐)
make all

# 只检查 Level 目录下的文件
make level

# 只检查指定文件
make check FILE=GenRPG/Level/stage1/process
```

## 核心文件详解

以下是 `lua_check` 目录中各个核心文件的功能说明：

-   `main.lua`
    **入口与总调度**。负责解析命令行参数，根据参数（例如 `--batch`, `--comprehensive`）决定启动哪种检查模式。它是所有检查任务的起点，并负责最终调用 `GlobalErrorCollector` 打印错误报告。

-   `comprehensive_checker.lua`
    **综合检查器**。它的核心职责是进行项目级的 **结构验证**。它会检查 `GenRPG` 目录下的 `Level`, `NPC`, `Prof` 等子目录结构是否符合预设规范，例如，每个关卡是否包含必需的 `process.lua` 等文件。完成结构检查后，它会收集所有合法的 `.lua` 文件，并移交给 `FunctionCallChecker` 进行代码级检查。

-   `function_call_checker.lua`
    **函数调用检查器**。这是代码静态分析的 **核心引擎**。它会读取并解析 `.lua` 文件，通过精密的正则表达式匹配，找出所有对已知API的调用（包括跨行书写的复杂调用）。对于每个调用，它都会与 `function_signature_extractor` 提供的“API指纹”进行比对，并调用 `ValidationModule` 验证参数的正确性。

-   `function_signature_extractor.lua`
    **函数签名提取器**。它的作用是为检查器建立一个权威的 **“API指纹数据库”**。在工具启动时，它会读取 `ai.lua`, `level.lua`, `skill.lua` 等API模拟文件，从中提取所有全局函数的名称、参数数量等信息，供 `FunctionCallChecker` 在后续的验证中使用。

-   `validation.lua`
    **参数验证模块**。提供了一套统一的验证规则和逻辑。当 `FunctionCallChecker` 需要验证一个函数调用的参数时，就会调用此模块。它包含了检查资源ID是否存在、数值是否在范围内、枚举值是否合法等多种验证函数。

-   `resource_validator.lua`
    **资源验证器**。负责扫描整个 `GenRPG` 目录，并将所有发现的资源（如 `NpcTID`, `SkillTID`, `ItemTID`）的ID缓存到内存中。它为 `ValidationModule` 提供了判断“某个资源ID是否存在”的数据基础。

-   `ai.lua`, `level.lua`, `skill.lua`, `item.lua`
    **API模拟文件**。这些文件并不包含真实的逻辑，而是定义了一系列与游戏引擎C++层暴露的API同名的Lua函数。它们是 `function_signature_extractor` 的数据来源，其目的是告诉检查工具“哪些函数是合法的”。

## 重要函数解析

-   `ComprehensiveChecker:checkAll(baseDir)`
    **作用**: 这是综合检查器的入口函数。它按照预设的顺序，依次调用内部的私有检查函数（如 `checkLevelDirectory`, `checkNPCDirectory`），对 `GenRPG` 的完整目录结构进行验证。在所有结构检查完成后，它会汇总所有找到的 `.lua` 文件，并启动对每个文件的内容检查。

-   `FunctionCallChecker:extractMultiLineFunctionCalls(content)`
    **作用**: 这是函数调用检查器中最复杂的部分。它接收一个文件的完整字符串内容，然后遍历所有已知的API函数名。
    **实现方式**: 对于每个函数名，它使用 `string.find` 在文件内容中进行搜索。一旦找到匹配的函数名，它不会立即停止，而是会启动一个状态机，逐字符向后解析，以正确处理括号 `()` 和大括号 `{}` 的配对，同时忽略字符串中的括号。这个过程能够确保即便是跨越多行、包含复杂表格参数的函数调用也能被完整、准确地提取出来。

-   `ValidationModule.validateCall(callInfo)`
    **作用**: 负责根据一个完整的函数调用信息（包含函数名和参数列表）来执行所有相关的验证。
    **实现方式**: 该函数内部维护了一张巨大的规则表（`ValidationConfig`）。它会根据传入的函数名，从这张表中查找所有适用于该函数的验证规则（例如，哪个参数应该是 `NpcTID`，哪个参数应该是某个范围内的数字）。然后，它会遍历这些规则，并对调用中对应的参数逐一进行验证，最终返回所有发现的错误。

-   `ResourceValidator:loadAllResources(baseDir)`
    **作用**: 建立一个项目中所有可用资源的缓存，以便进行快速的引用验证。
    **实现方式**: 此函数会递归地扫描 `GenRPG` 目录下的 `Prof`, `Skill`, `Item` 等子目录。它通过文件名来提取资源的TID（例如，从 `自由之剑.lua` 中提取 `自由之剑` 作为 `ItemTID`），然后将这些ID存储在不同的哈希表（如 `self.cache.itemTIDs`）中。后续所有对资源ID的验证都将通过查询这些表来完成。 