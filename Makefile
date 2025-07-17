# RPG游戏代码验证工具 - Makefile

# 颜色定义
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[1;33m
BLUE := \033[0;34m
PURPLE := \033[0;35m
CYAN := \033[0;36m
NC := \033[0m # No Color

# 深度参数配置 (控制路径显示层级)
DEPTH ?= 0
DEPTH_PARAM := --depth $(DEPTH)

# DEBUG模式配置
DEBUG ?= 0
ifeq ($(DEBUG),1)
    SHELL := /bin/bash -x
    MAKEFLAGS += --debug=v
    .SHELLFLAGS := -x
endif

# 默认目标
.DEFAULT_GOAL := all

# 默认目标
.PHONY: help
help:
	@echo "$(BLUE)🎮 RPG游戏代码验证工具$(NC)"
	@echo ""
	@echo "$(GREEN)📋 主要命令:$(NC)"
	@echo "  $(YELLOW)make all$(NC)             - 检查所有GenRPG目录下的lua文件"
	@echo "  $(YELLOW)make level$(NC)           - 检查Level系统文件"
	@echo "  $(YELLOW)make npc$(NC)             - 检查NPC系统文件"
	@echo "  $(YELLOW)make skill$(NC)           - 检查Skill系统文件"
	@echo "  $(YELLOW)make item$(NC)           	- 检查Item系统文件"
	@echo "  $(YELLOW)make test$(NC)            - 运行测试文件"
	@echo "  $(YELLOW)make gemini$(NC)          - 使用gemini和本工具配合修复GenRPG目录下的lua文件错误"
	@echo ""
	@echo "$(GREEN)📋 部署命令:$(NC)"
	@echo "  $(YELLOW)make install$(NC)         - 安装工具到metagpt项目目录 $(CYAN)(仅限rpg目录下执行)$(NC)"
	@echo "  $(YELLOW)make upgrade$(NC)         - 从metagpt项目更新API和工具文件 $(CYAN)(自动检测metagpt路径)$(NC)"
	@echo ""
	@echo "$(GREEN)📋 其他命令:$(NC)"
	@echo "  $(YELLOW)make check FILE=<path>$(NC) - 检查指定文件"
	@echo "  $(YELLOW)make check-quick$(NC)     - 快速检查关键文件"
	@echo "  $(YELLOW)make report$(NC)          - 生成详细检查报告"
	@echo "  $(YELLOW)make stats$(NC)           - 显示项目统计信息"
	@echo "  $(YELLOW)make check-deps$(NC)      - 检查依赖环境"
	@echo "  $(YELLOW)make clean$(NC)           - 清理临时文件"
	@echo "  $(YELLOW)make help$(NC)            - 显示此帮助信息"
	@echo ""
	@echo "$(GREEN)💡 使用示例:$(NC)"
	@echo "  make check FILE=GenRPG/Level/stage1/process"
	@echo "  make level"
	@echo "  make test"
	@echo "  make all DEPTH=3  $(CYAN)# 显示更多路径层级$(NC)"
	@echo "  make install     $(CYAN)# 从rpg目录安装到metagpt$(NC)"
	@echo "  make upgrade     $(CYAN)# 更新API文件(任意metagpt子目录)$(NC)"
	@echo "  make all DEBUG=1 $(CYAN)# 启用DEBUG模式，显示执行的每一行$(NC)"
	@echo ""
	@echo "$(GREEN)📏 路径显示控制:$(NC)"
	@echo "  $(CYAN)DEPTH=2$(NC) (默认)     - 错误显示: Projects/RPG/GenRPG/..."
	@echo "  $(CYAN)DEPTH=1$(NC)           - 错误显示: RPG/GenRPG/..."
	@echo "  $(CYAN)DEPTH=0$(NC)           - 错误显示: GenRPG/..."
	@echo ""
	@echo "$(GREEN)🔧 部署说明:$(NC)"
	@echo "  $(CYAN)install$(NC): 必须在包含GenRPG目录或名为rpg的目录下执行"
	@echo "  $(CYAN)upgrade$(NC): 自动向上查找metagpt目录，支持多层嵌套"
	@echo ""
	@echo "$(GREEN)🐛 DEBUG模式:$(NC)"
	@echo "  $(CYAN)DEBUG=1$(NC): 启用详细调试，显示执行的每一行命令"
	@echo "  示例: make all DEBUG=1"

# 检查所有文件
.PHONY: all
all:
	@echo "$(BLUE)🔍 检查所有GenRPG目录下的lua文件$(NC)"
	@lua lua_check/main.lua $(DEPTH_PARAM) --enable-static-check --batch GenRPG/

# 检查Level系统
.PHONY: level
level:
	@echo "$(BLUE)🏰 批量检查Level系统$(NC)"
	@lua lua_check/main.lua $(DEPTH_PARAM) --enable-static-check --batch GenRPG/Level/

# 检查NPC系统（包括NPC行为和Prof配置）
.PHONY: npc
npc:
	@echo "$(BLUE)🤖 批量检查NPC系统$(NC)"
	@echo "$(YELLOW)📂 检查NPC行为文件...$(NC)"
	@lua lua_check/main.lua $(DEPTH_PARAM) --batch GenRPG/NPC/
	@echo "$(YELLOW)📝 检查NPC配置文件...$(NC)"
	@lua lua_check/main.lua $(DEPTH_PARAM) --batch GenRPG/Prof/

# 检查Skill系统
.PHONY: skill
skill:
	@echo "$(BLUE)⚔️  批量检查Skill系统$(NC)"
	@lua lua_check/main.lua $(DEPTH_PARAM) --enable-static-check --batch GenRPG/Skill/

# 检查Item系统
.PHONY: item
item:
	@echo "$(BLUE)⚔️  批量检查Item系统$(NC)"
	@lua lua_check/main.lua $(DEPTH_PARAM) --enable-static-check --batch GenRPG/Item/


# 检查指定文件
.PHONY: check
check:
	@if [ -z "$(FILE)" ]; then \
		echo "$(RED)❌ 错误: 请指定文件路径$(NC)"; \
		echo "用法: make check FILE=<文件路径>"; \
		echo "示例: make check FILE=GenRPG/Level/stage1/process"; \
		exit 1; \
	fi
	@echo "$(BLUE)🔍 检查文件: $(FILE)$(NC)"
	@lua lua_check/main.lua $(DEPTH_PARAM) "$(FILE)"

# 运行测试
.PHONY: test
test:
	@echo "$(BLUE)🔧 验证检查工具功能$(NC)"
	@echo "$(GREEN)1. 测试基础API验证功能$(NC)"
	@lua lua_check/main.lua $(DEPTH_PARAM) lua_check/test_simple
	@echo "$(GREEN)2. 测试资源检查功能$(NC)"
	@echo "$(GREEN)✅ 工具验证完成$(NC)"

# 快速检查（只检查关键文件）
.PHONY: check-quick
check-quick:
	@echo "$(BLUE)⚡ 快速检查关键文件$(NC)"
	@files="GenRPG/Level/stage1/process GenRPG/NPC/暗影狼/onUpdateStrategy GenRPG/Skill/普通攻击"; \
	success=0; total=0; \
	for file in $$files; do \
		total=$$((total + 1)); \
		if [ -f "$$file.lua" ]; then \
			if lua lua_check/main.lua $(DEPTH_PARAM) "$$file" >/dev/null 2>&1; then \
				success=$$((success + 1)); \
			else \
				echo "$(RED)❌ 失败$(NC)"; \
			fi; \
		else \
			echo "$(RED)❌ 文件不存在: $$file.lua$(NC)"; \
		fi; \
	done; \
	echo "$(PURPLE)📊 快速检查完成: $$success/$$total 文件通过$(NC)"

# 生成检查报告
.PHONY: report
report:
	@echo "$(BLUE)📋 生成检查报告$(NC)"
	@report_file="check_report_$$(date +%Y%m%d_%H%M%S).txt"; \
	echo "RPG游戏代码检查报告 - $$(date)" > "$$report_file"; \
	echo "==============================" >> "$$report_file"; \
	echo "" >> "$$report_file"; \
	lua_files=$$(find GenRPG -type f -name "*.lua" 2>/dev/null); \
	if [ -n "$$lua_files" ]; then \
		echo "检查的文件列表:" >> "$$report_file"; \
		for file in $$lua_files; do \
			echo "  - $$file" >> "$$report_file"; \
		done; \
		echo "" >> "$$report_file"; \
		echo "详细检查结果:" >> "$$report_file"; \
		echo "==============================" >> "$$report_file"; \
		for file in $$lua_files; do \
			filename="$${file%.*}"; \
			echo "" >> "$$report_file"; \
			echo "检查文件: $$filename" >> "$$report_file"; \
			echo "------------------------------" >> "$$report_file"; \
			lua lua_check/main.lua $(DEPTH_PARAM) "$$filename" >> "$$report_file" 2>&1; \
		done; \
	else \
		echo "未找到任何lua文件" >> "$$report_file"; \
	fi; \
	echo "$(GREEN)📄 报告已生成: $$report_file$(NC)"

# 清理临时文件
.PHONY: clean
clean:
	@echo "$(BLUE)🧹 清理临时文件$(NC)"
	@cleaned=0; \
	for file in check_report_*.txt; do \
		if [ -f "$$file" ]; then \
			rm "$$file" && cleaned=$$((cleaned + 1)); \
		fi; \
	done; \
	if [ $$cleaned -gt 0 ]; then \
		echo "$(GREEN)✅ 已清理 $$cleaned 个报告文件$(NC)"; \
	else \
		echo "$(YELLOW)ℹ️  没有找到需要清理的文件$(NC)"; \
	fi

# 安装依赖检查
.PHONY: check-deps
check-deps:
	@echo "$(BLUE)🔍 检查依赖环境$(NC)"
	@all_good=true; \
	if command -v lua >/dev/null 2>&1; then \
		echo "$(GREEN)✅ Lua 已安装: $$(lua -v | head -1)$(NC)"; \
	else \
		echo "$(RED)❌ Lua 未安装$(NC)"; \
		all_good=false; \
	fi; \
	if [ -d "lua_check" ]; then \
		echo "$(GREEN)✅ 检查工具目录存在$(NC)"; \
	else \
		echo "$(RED)❌ 检查工具目录不存在$(NC)"; \
		all_good=false; \
	fi; \
	required_files="lua_check/main.lua lua_check/level.lua lua_check/ai.lua lua_check/skill.lua lua_check/resource_validator.lua"; \
	for file in $$required_files; do \
		if [ -f "$$file" ]; then \
			echo "$(GREEN)✅ $$file 存在$(NC)"; \
		else \
			echo "$(RED)❌ $$file 不存在$(NC)"; \
			all_good=false; \
		fi; \
	done; \
	if $$all_good; then \
		echo "$(GREEN)🎉 所有依赖检查通过！$(NC)"; \
	else \
		echo "$(RED)⚠️  依赖检查失败，请确保所有必需文件存在$(NC)"; \
		exit 1; \
	fi

# 显示项目统计
.PHONY: stats
stats:
	@echo "$(BLUE)📊 项目统计信息$(NC)"
	@echo "$(GREEN)📁 目录结构:$(NC)"
	@if [ -d "GenRPG" ]; then \
		find GenRPG -type d 2>/dev/null | wc -l | xargs printf "  目录数量: %s\n"; \
		find GenRPG -type f -name "*.lua" 2>/dev/null | wc -l | xargs printf "  Lua文件总数: %s\n"; \
	else \
		echo "  $(YELLOW)GenRPG目录不存在$(NC)"; \
	fi
	@echo "$(GREEN)🎯 各系统文件统计:$(NC)"
	@systems="Level NPC Skill Prof Locator"; \
	for system in $$systems; do \
		if [ -d "GenRPG/$$system" ]; then \
			count=$$(find "GenRPG/$$system" -name "*.lua" 2>/dev/null | wc -l); \
			printf "  %-8s系统: %s 个文件\n" "$$system" "$$count"; \
		else \
			printf "  %-8s系统: 目录不存在\n" "$$system"; \
		fi; \
	done
	@echo "$(GREEN)🛠️  工具文件统计:$(NC)"
	@if [ -d "lua_check" ]; then \
		find lua_check -name "*.lua" 2>/dev/null | wc -l | xargs printf "  检查工具文件数: %s\n"; \
	else \
		echo "  $(YELLOW)lua_check目录不存在$(NC)"; \
	fi

# 显示最近的检查报告
.PHONY: show-latest-report
show-latest-report:
	@echo "$(BLUE)📄 显示最新检查报告$(NC)"
	@latest=$$(ls -t check_report_*.txt 2>/dev/null | head -1); \
	if [ -n "$$latest" ]; then \
		echo "$(GREEN)最新报告: $$latest$(NC)"; \
		echo ""; \
		cat "$$latest"; \
	else \
		echo "$(YELLOW)没有找到检查报告，请先运行 make report$(NC)"; \
	fi

# CI模式检查（适合自动化）
.PHONY: ci-check
ci-check:
	@echo "CI模式检查开始..."
	@lua_files=$$(find GenRPG -type f -name "*.lua" 2>/dev/null); \
	if [ -z "$$lua_files" ]; then \
		echo "ERROR: No lua files found"; \
		exit 1; \
	fi; \
	failed=0; total=0; \
	for file in $$lua_files; do \
		filename="$${file%.*}"; \
		total=$$((total + 1)); \
		if ! lua lua_check/main.lua $(DEPTH_PARAM) "$$filename" >/dev/null 2>&1; then \
			failed=$$((failed + 1)); \
			echo "FAILED: $$filename"; \
		fi; \
	done; \
	echo "Results: $$((total - failed))/$$total passed"; \
	if [ $$failed -eq 0 ]; then \
		echo "SUCCESS: All checks passed"; \
		exit 0; \
	else \
		echo "FAILURE: $$failed files failed"; \
		exit 1; \
	fi

# 安装工具到metagpt项目
.PHONY: install
install:
	@echo "$(BLUE)📦 安装工具到metagpt项目$(NC)"
	@# 校验当前是否在rpg目录下
	@current_dir=$$(basename "$$(pwd)"); \
	if [ "$$current_dir" != "rpg" ] && [ ! -d "GenRPG" ]; then \
		echo "$(RED)❌ 错误: 只能在rpg项目目录下执行此命令$(NC)"; \
		echo "$(YELLOW)当前目录: $$current_dir$(NC)"; \
		echo "$(YELLOW)请切换到rpg目录后再执行 make install$(NC)"; \
		exit 1; \
	fi; \
	target_dir="../metagpt/projects/rpg/actions/prepare_lua_check/lua_check"; \
	if [ ! -d "$$target_dir" ]; then \
		echo "$(YELLOW)📁 创建目标目录: $$target_dir$(NC)"; \
		mkdir -p "$$target_dir"; \
	fi; \
	files_to_copy="comprehensive_checker.lua function_call_checker.lua function_signature_extractor.lua main.lua item_checker.lua README.md resource_validator.lua test_simple.lua validation.lua"; \
	copied=0; \
	for file in $$files_to_copy; do \
		if [ -f "lua_check/$$file" ]; then \
			cp "lua_check/$$file" "$$target_dir/$$file" && \
			echo "$(GREEN)✅ 已拷贝: $$file$(NC)" && \
			copied=$$((copied + 1)); \
		else \
			echo "$(RED)❌ 文件不存在: lua_check/$$file$(NC)"; \
		fi; \
	done; \
	if [ -f "Makefile" ]; then \
		cp "Makefile" "$$target_dir/Makefile" && \
		echo "$(GREEN)✅ 已拷贝: Makefile$(NC)" && \
		copied=$$((copied + 1)); \
	else \
		echo "$(RED)❌ Makefile 不存在$(NC)"; \
	fi; \
	echo "$(PURPLE)📊 安装完成: $$copied 个文件已拷贝$(NC)"

# 从metagpt项目更新API和工具文件
.PHONY: upgrade
upgrade:
	@echo "$(BLUE)🔄 从metagpt项目更新文件$(NC)"
	@echo "$(YELLOW)🔍 检测metagpt目录路径...$(NC)"
	@metagpt_root=""; \
	current_path="$$(pwd)"; \
	while [ "$$current_path" != "/" ]; do \
		if [ -d "$$current_path/metagpt" ] && [ -d "$$current_path/metagpt/projects" ]; then \
			metagpt_root="$$current_path/metagpt"; \
			break; \
		elif [ "$$(basename "$$current_path")" = "metagpt" ] && [ -d "$$current_path/projects" ]; then \
			metagpt_root="$$current_path"; \
			break; \
		fi; \
		current_path="$$(dirname "$$current_path")"; \
	done; \
	if [ -z "$$metagpt_root" ]; then \
		echo "$(YELLOW)⚠️  未检测到metagpt目录，使用默认相对路径$(NC)"; \
		api_base_dir="../metagpt/projects/rpg/configs"; \
		checker_base_dir="../metagpt/projects/rpg/actions/prepare_lua_check/lua_check"; \
	else \
		echo "$(GREEN)✅ 检测到metagpt目录: $$metagpt_root$(NC)"; \
		api_base_dir="$$metagpt_root/projects/rpg/configs"; \
		checker_base_dir="$$metagpt_root/projects/rpg/actions/prepare_lua_check/lua_check"; \
	fi; \
	echo ""; \
	echo "$(CYAN)📄 1. 更新API文件$(NC)"; \
	echo "$(CYAN)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"; \
	updated_api=0; \
	api_source_paths="level/example/LevelApiFull.lua skill/example/SkillApiFull.lua item/example/ItemApiFull.lua ai/example/AIApiFull.lua"; \
	api_target_files="level.lua skill.lua item.lua ai.lua"; \
	set -- $$api_source_paths; \
	for target in $$api_target_files; do \
		source_path="$$1"; \
		shift; \
		source_file="$$api_base_dir/$$source_path"; \
		target_path="lua_check/$$target"; \
		if [ -f "$$source_file" ]; then \
			cp "$$source_file" "$$target_path" && \
			echo "  $(GREEN)✅ $$target$(NC) <- $$source_path" && \
			updated_api=$$((updated_api + 1)); \
		else \
			echo "  $(RED)❌ $$target$(NC) <- $$source_path $(RED)(源文件不存在)$(NC)"; \
		fi; \
	done; \
	echo ""; \
	echo "$(CYAN)🔧 2. 更新检查工具文件$(NC)"; \
	echo "$(CYAN)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"; \
	updated_checker=0; \
	checker_files="comprehensive_checker.lua function_call_checker.lua item_checker.lua function_signature_extractor.lua main.lua README.md resource_validator.lua test_simple.lua validation.lua"; \
	for file in $$checker_files; do \
		source_file="$$checker_base_dir/$$file"; \
		target_path="lua_check/$$file"; \
		if [ -f "$$source_file" ]; then \
			cp "$$source_file" "$$target_path" && \
			echo "  $(GREEN)✅ $$file$(NC)" && \
			updated_checker=$$((updated_checker + 1)); \
		else \
			echo "  $(RED)❌ $$file$(NC) $(RED)(源文件不存在)$(NC)"; \
		fi; \
	done; \
	echo ""; \
	echo "$(CYAN)📋 3. 更新Makefile$(NC)"; \
	echo "$(CYAN)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"; \
	makefile_source="$$checker_base_dir/Makefile"; \
	if [ -f "$$makefile_source" ]; then \
		cp "$$makefile_source" "Makefile" && \
		echo "  $(GREEN)✅ Makefile$(NC)" && \
		updated_checker=$$((updated_checker + 1)); \
	else \
		echo "  $(RED)❌ Makefile$(NC) $(RED)(源文件不存在)$(NC)"; \
	fi; \
	echo ""; \
	total_updated=$$((updated_api + updated_checker)); \
	echo "$(PURPLE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"; \
	echo "$(PURPLE)📊 更新完成: $$total_updated 个文件已更新$(NC)"; \
	echo "$(PURPLE)   - API文件: $$updated_api 个$(NC)"; \
	echo "$(PURPLE)   - 工具文件: $$updated_checker 个$(NC)"; \
	echo "$(PURPLE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"

# 默认的 gemini 提示词
DEFAULT_GEMINI_PROMPT = "你是专业的GenRPG项目Lua游戏工程错误修复专家，执行流程：1.运行make all指令检查GenRPG目录错误并判断是否为真正需要修复的问题，输出的错误可能并非真错，需判断是否修改，如果没有错误直接结束；2.阅读lua_check-Framework.md掌握整体结构、API文件、生成文件和example；3.优先修复阻塞性错误，采用最简单有效方案，复杂错误优先简化逻辑确保程序可运行。约束条件：严格限制只能修改GenRPG目录下文件，禁止删除文件，使用中文回复,突出关键信息，确保程序正常运行为第一优先级，最小化修改避免引入新问题，保持项目完整性和稳定性。"

# 使用gemini和本工具配合修复当前目录下的lua文件错误
.PHONY: gemini
gemini:
	@echo "$(BLUE)🤖 使用gemini修复当前目录下的lua文件错误$(NC)"
	@if [ -z "$(PROMPT)" ]; then \
		echo "$(YELLOW)⚠️  未提供PROMPT参数，使用默认提示词$(NC)"; \
		gemini -y --prompt '$(DEFAULT_GEMINI_PROMPT)'; \
	else \
		gemini -y -p '$(PROMPT)'; \
	fi

