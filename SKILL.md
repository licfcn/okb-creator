---
name: okb-creator
description: 一键生成基于 Karpathy LLM Wiki 理念的 Obsidian 知识库脚手架，融合 Zettelkasten + MOC + Dataview + Tasks。当用户提到"创建知识库"、"新建知识库"、"帮我搭一个知识库"、"Obsidian vault"、"LLM Wiki"、"卡帕西知识库"，或者想要一个可以用 Claude Code 编译维护的 Markdown 知识库时，触发此 skill。也适用于用户想要生成 CLAUDE.md、设置 raw/wiki/daily/outputs 结构、或提到 Karpathy 知识库方法论的场景。即使用户只是模糊地说"帮我整理知识"或"我想建一个学习系统"，也应该考虑触发此 skill。
---

# 知识库脚手架生成器

基于 Karpathy LLM Wiki 理念，融合 Zettelkasten（卢曼卡片盒）、MOC（Map of Content）、Dataview + Tasks 插件，一键生成开箱即用的 Obsidian 知识库。用户只需回答几个问题，即可获得一个完整的 zip 包，解压后配合 Claude Code 直接使用。

## 核心理念

这套知识库遵循**知识闭环系统**，融合三种方法论：

```
收集 → 提炼 → 整理 → 内化 → 应用 → 复盘
 ↓      ↓      ↓      ↓      ↓      ↓
raw/  /compile /summarize /todo /write /health-check
       wiki/   _MOC/     daily/ outputs/  报告
              +总结      +review
                                    ↓
                                 反馈 → raw/
```

**三大方法论融合**：
- **Zettelkasten（卢曼卡片盒）**：原子笔记，一个概念一篇，密集双链
- **MOC（Map of Content）**：主题导航枢纽，多层级知识地图
- **Dataview + Tasks**：动态查询视图，任务管理闭环

**核心哲学**：
- raw/ 存放原始材料（只读）
- /compile 将 raw/ "编译"为原子笔记（文献笔记层）
- /summarize 组织原子笔记为 MOC + 主题总结（永久笔记层）
- /todo 整理日记和待办，形成学习闭环
- wiki 支持多层级文件夹结构
- 充分利用 Obsidian 双链功能，打造关系图谱
- 通过十个命令维护知识库质量和闭环流转

## 交互流程

### Step 1：收集信息

向用户提出以下问题（可以根据对话上下文跳过已知信息）：

**必问：**
1. 你想创建什么领域的知识库？（如：AI & Agent、商业投资、医学、烹饪、法律……）
2. vault 文件夹想叫什么名字？（英文或中文均可，如 `AI-Agent-KB`、`商业知识库`）

**可选（如果用户不确定，由你根据领域推断）：**
3. 你在这个领域常收集什么类型的材料？（文章、论文、视频笔记、财报、代码……）
4. 这个领域的知识大致可以分哪几种类型？（如商业领域有 company/concept/framework/industry 等，不知道的话我来推断）

### Step 2：生成 CLAUDE.md

这是整个 Skill 的核心步骤。根据用户的回答，参照 `references/claude-md-template.md` 中的模板生成 CLAUDE.md。

**生成规则：**

1. 阅读 `references/claude-md-template.md` 获取完整模板结构
2. 模板中标注为 `{{动态}}` 的部分需要根据用户的领域定制生成
3. 模板中没有标注的部分原样保留（这些是所有知识库通用的规则）
4. type 分类体系：根据领域特点设计 4-7 个 type，每个 type 都要有简短说明
5. 文章结构模板：为每种 type 设计合理的章节结构，包含"实践任务"章节（Tasks 语法）
6. 示例文章：选择该领域中一个具有代表性的中等复杂度概念，写一篇完整的示例文章。示例文章必须包含：完整 frontmatter、摘要段、多个 `[[]]` 链接、所有章节、实践任务章节（Tasks 语法）。示例文章的主题选择标准：
   - 选一个该领域的基础概念（不要太专业冷门，也不要太泛泛）
   - 确保能自然地展示多种 type 之间的链接关系
   - 确保能展示中文命名和英文专有名词保留的规则
7. 时效性规则：根据领域特点说明哪些内容 evergreen、哪些 volatile
8. outputs/ 描述：列出该领域常见的输出类型
9. raw/ 描述：列出该领域常见的原始材料类型
10. 文件命名规则中的示例：给出 3-4 个贴合该领域的 ✅ 和 ❌ 命名示例

### Step 3：组装固定文件

从 `commands/`、`templates/`、`script/` 目录复制以下固定文件（这些文件不随主题变化）：

**命令文件**（`commands/` → `.claude/commands/`）：
- `commands/compile.md` → `.claude/commands/compile.md`
- `commands/summarize.md` → `.claude/commands/summarize.md`（MOC + 主题总结）
- `commands/todo.md` → `.claude/commands/todo.md`（日记整理）
- `commands/lint.md` → `.claude/commands/lint.md`
- `commands/health-check.md` → `.claude/commands/health-check.md`
- `commands/write.md` → `.claude/commands/write.md`
- `commands/research.md` → `.claude/commands/research.md`
- `commands/base.md` → `.claude/commands/base.md`（Dataview 查询）
- `commands/review.md` → `.claude/commands/review.md`
- `commands/publish.md` → `.claude/commands/publish.md`

**模板文件**（`templates/` → vault 对应位置）：
- `templates/daily-template.md` → `daily/_template.md`（日记模板）

**脚本文件**（`script/` → vault 根目录）：
- `script/lock-raw.bat` → `lock-raw.bat`
- `script/unlock-raw.bat` → `unlock-raw.bat`
- `script/lock-raw.sh` → `lock-raw.sh`
- `script/unlock-raw.sh` → `unlock-raw.sh`

### Step 4：创建文件夹结构

确保 zip 中包含以下空文件夹（通过在每个空文件夹中放一个 `.gitkeep` 文件实现）：

- `raw/.gitkeep`
- `research/.gitkeep`
- `wiki/.gitkeep`
- `wiki/_MOC/.gitkeep`（MOC 导航层）
- `wiki/_changelog.md`（初始内容为 `# 变更日志\n\n暂无记录。`）
- `review/.gitkeep`
- `review/cards/.gitkeep`
- `review/schedule.md`（初始内容为 `# 复习计划\n\n## 今日复习\n\n暂无。\n\n## 本周复习\n\n暂无。`）
- `review/stats.md`（初始内容为 `# 复习统计\n\n## 总览\n\n- 总卡片数：0\n- 已复习：0\n- 待复习：0\n- 熟练度：0%`）
- `outputs/.gitkeep`
- `content/.gitkeep`
- `content/index.md`（数字花园首页）
- `content/about.md`（关于页面）
- `assets/.gitkeep`
- `daily/.gitkeep`（日记文件夹）

### Step 5：打包为 zip

将所有文件打包为一个 zip 文件，命名为 `{vault-name}.zip`。

最终 zip 内的结构：
```
{vault-name}/
├── CLAUDE.md
├── raw/
│   └── .gitkeep
├── research/
│   └── .gitkeep
├── wiki/
│   ├── .gitkeep
│   ├── _MOC/
│   │   └── .gitkeep
│   └── _changelog.md
├── daily/
│   ├── .gitkeep
│   └── _template.md
├── review/
│   ├── .gitkeep
│   ├── cards/
│   │   └── .gitkeep
│   ├── schedule.md
│   └── stats.md
├── outputs/
│   └── .gitkeep
├── content/
│   ├── .gitkeep
│   ├── index.md
│   └── about.md
├── assets/
│   └── .gitkeep
├── .claude/
│   └── commands/
│       ├── compile.md
│       ├── summarize.md
│       ├── todo.md
│       ├── lint.md
│       ├── health-check.md
│       ├── write.md
│       ├── research.md
│       ├── base.md
│       ├── review.md
│       └── publish.md
├── lock-raw.bat
├── unlock-raw.bat
├── lock-raw.sh
└── unlock-raw.sh
```

### Step 6：交付

使用 `present_files` 工具将 zip 文件交给用户，并附上简短的使用说明：

```
你的知识库已生成！这是一个融合 Zettelkasten + MOC + Dataview + Tasks 的完整知识闭环系统。

## 快速开始

1. 解压 zip 到你想要的位置
2. 用 Obsidian 打开解压后的文件夹作为 vault
3. 安装必需插件：Dataview、Tasks（推荐：Spaced Repetition、Claudian）
4. 往 raw/ 里丢你的原始材料（文章、笔记、截图等）
5. Windows 用户运行 lock-raw.bat 锁定 raw/，Mac 用户运行 chmod +x lock-raw.sh && ./lock-raw.sh
6. 在终端中 cd 到 vault 目录，运行 claude，然后输入 /compile 开始编译

## 知识闭环流程

收集 → 提炼 → 整理 → 内化 → 应用 → 复盘

## 十个命令速查

**提炼阶段**：
- /compile      → 从 raw/ 提取原子笔记到 wiki
- /lint         → 检查格式并自动修复

**整理阶段**：
- /summarize    → 创建 MOC + 主题总结，建立多层级结构
- /research     → AI 主动搜索补充知识空白

**内化阶段**：
- /todo         → 整理日记、待办、学习情况（支持多次合并去重）
- /review       → 生成间隔重复复习卡片

**应用阶段**：
- /write        → 基于 wiki 写文章，新洞察可回流 wiki
- /publish      → 发布到 content/ 用于构建数字花园

**复盘阶段**：
- /health-check → 全面体检，发现矛盾和空白
- /base         → 创建 Dataview 查询视图

## 推荐安装

# 必需插件（在 Obsidian 设置 → 第三方插件 中安装）
- Dataview
- Tasks

# 推荐插件
- Spaced Repetition（间隔重复复习）
- Claudian（将 Claude Code 嵌入 Obsidian 侧边栏）
```

## 注意事项

- 所有文件使用 UTF-8 编码
- CLAUDE.md 中的示例文章必须足够完整和规范，因为它是 LLM 编译时的唯一参照标准
- 示例文章必须包含"实践任务"章节，使用 Tasks 插件语法
- 文件命名规则中文优先，专有名词保留英文
- 不要在 zip 中包含任何二进制文件或大文件
- /compile 只负责提取原子笔记，/summarize 负责整理 MOC 和总结，两者分工明确
- /todo 命令支持多次执行合并去重，不会重复追加内容

## 项目结构

```
okb-creator/
├── SKILL.md                       # Skill 主文件
├── CLAUDE.md                      # 示例系统指令
├── LICENSE                        # MIT 许可证
├── README.md                      # 项目文档
├── commands/                      # 命令模板（复制到 vault 的 .claude/commands/）
│   ├── compile.md
│   ├── summarize.md
│   ├── todo.md
│   ├── lint.md
│   ├── write.md
│   ├── research.md
│   ├── health-check.md
│   ├── base.md
│   ├── review.md
│   └── publish.md
├── templates/                     # 文档模板
│   ├── daily-template.md          # 日记模板
│   └── review-card-template.md    # 复习卡片模板
├── script/                        # 脚本文件
│   ├── lock-raw.bat / .sh         # 锁定 raw/
│   └── unlock-raw.bat / .sh       # 解锁 raw/
└── references/                    # 参考文档
    └── claude-md-template.md      # CLAUDE.md 生成模板
```

## 致谢

本项目基于 [obsidian-kb-creator](https://github.com/XinYaoDev/obsidian-kb-creator) 优化改进，在此向原作者致以感谢。

同时感谢以下项目和人物提供的灵感：
- [Andrej Karpathy](https://x.com/karpathy) — LLM Knowledge Bases 方法论
- [Obsidian](https://obsidian.md/) — 知识管理工具
- [Dataview](https://github.com/blacksmithgu/obsidian-dataview) — 动态查询插件
- [Tasks](https://github.com/obsidian-tasks-group/obsidian-tasks) — 任务管理插件
- [Claudian](https://github.com/YishenTu/claudian) — Obsidian 侧边栏集成
- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) — AI 编程工具
- Niklas Luhmann — Zettelkasten 方法论提出者
