# OKB Creator — Obsidian 知识库生成器

一键生成完整的 Obsidian 知识闭环系统，融合 Zettelkasten（卢曼卡片盒）、MOC（Map of Content）、Dataview + Tasks 插件，让 AI 帮你把散乱的收藏编译成结构化的知识。

> 灵感来源：[Andrej Karpathy 的 LLM Knowledge Bases](https://x.com/karpathy/status/2039805659525644595)

---

## 目录

- [为什么需要这个](#为什么需要这个)
- [架构概览](#架构概览)
- [安装](#安装)
- [创建知识库](#创建知识库)
- [使用知识库](#使用知识库)
- [十个命令](#十个命令)
- [知识闭环工作流](#知识闭环工作流)
- [Zettelkasten + MOC 方法论](#zettelkasten--moc-方法论)
- [Dataview + Tasks 集成](#dataview--tasks-集成)
- [常用技巧](#常用技巧)
- [Quartz 数字花园](#quartz-数字花园)
- [常见问题](#常见问题)
- [项目结构](#项目结构)
- [致谢](#致谢)

---

## 为什么需要这个

大多数人的知识管理长这样：

```
收藏文章 → 放进收藏夹 → 再也不看 → 知识腐烂
```

即使用了 AI，也是每次对话从零开始，没有积累。

**本项目的解决方案**：构建融合 Zettelkasten + MOC + Dataview + Tasks 的完整知识闭环。

```
收集 → 提炼 → 整理 → 内化 → 应用 → 复盘
 ↓      ↓      ↓      ↓      ↓      ↓
raw/  /compile /summarize /todo /write /health-check
       wiki/   _MOC/     daily/ outputs/  报告
              +总结      +review
                                    ↓
                                 反馈 → raw/
```

---

## 架构概览

生成的知识库 vault 结构：

```
your-knowledge-base/
├── CLAUDE.md              # 知识库的"大脑"（系统指令）
├── raw/                   # 收集：原始材料（只读）
├── research/              # 收集：AI 补充研究
├── wiki/                  # 知识库（多层级 + MOC）
│   ├── INDEX.md           # 总索引
│   ├── _MOC/              # MOC 导航层
│   │   ├── 知识总览.md     # 顶层 MOC
│   │   └── {主题}MOC.md    # 主题 MOC
│   ├── _compile-log.md    # 编译日志
│   ├── _changelog.md      # 变更日志
│   └── {主题}/{子主题}/    # 多层级分类
├── daily/                 # 日记与待办
│   ├── _template.md       # 日记模板
│   └── YYYY-MM-DD.md      # 每日日记
├── review/                # 内化：复习卡片
├── outputs/               # 应用：写作产出
├── content/               # 数字花园
├── assets/                # 附件
└── .claude/commands/      # 十个命令
```

### 文件夹各司其职

| 文件夹 | 阶段 | 谁写入 | 作用 |
|--------|------|--------|------|
| `raw/` | 收集 | 你 | 原始材料仓库，只读 |
| `research/` | 收集 | AI | AI 补充研究 |
| `wiki/` | 提炼+整理 | AI | 原子笔记 + MOC + 主题总结 |
| `daily/` | 内化 | AI+你 | 日记、待办、学习记录 |
| `review/` | 内化 | AI | 复习卡片 |
| `outputs/` | 应用 | AI | 写作产出 |
| `content/` | 应用 | AI | 数字花园 |
| `assets/` | - | 你 | 附件 |

---

## 安装

### 前置条件

- [Obsidian](https://obsidian.md/)
- [Claude Code](https://docs.anthropic.com/en/docs/claude-code)
- Obsidian 插件：**Dataview**（必需）、**Tasks**（必需）

### 方式一：在 Claude Code 中作为 Skill 安装（推荐）

```bash
git clone https://github.com/你的用户名/okb-creator.git ~/.claude/skills/okb-creator

# 在任意目录使用
cd your-project
claude
> 帮我创建一个知识库
```

### 方式二：在 Claude.ai 对话中直接使用

1. 复制 `SKILL.md` 和 `references/claude-md-template.md` 的内容到对话中
2. 说：**"帮我创建一个知识库"**
3. 按提示回答问题，获取 zip 包

### 方式三：手动复制到已有 vault

```bash
# 克隆仓库
git clone https://github.com/你的用户名/okb-creator.git

# 复制命令文件
mkdir -p your-vault/.claude/commands
cp okb-creator/commands/*.md your-vault/.claude/commands/

# 复制日记模板
cp okb-creator/templates/daily-template.md your-vault/daily/_template.md

# 复制锁定脚本
cp okb-creator/script/lock-raw.* your-vault/
cp okb-creator/script/unlock-raw.* your-vault/

# 创建文件夹
mkdir -p your-vault/{raw,research,wiki/_MOC,daily,outputs,assets}
```

### 安装 Obsidian 插件

1. **Dataview** — 设置 → 第三方插件 → 关闭安全模式 → 浏览 → 搜索 "Dataview" → 安装 → 启用
   - 建议在 Dataview 设置中开启 "Enable JavaScript Queries"
2. **Tasks** — 搜索 "Tasks" → 安装 → 启用
3. **（推荐）Spaced Repetition** — 间隔重复复习，配合 /review 命令
4. **（推荐）Claudian** — 将 Claude Code 嵌入 Obsidian 侧边栏

---

## 创建知识库

### Step 1：触发创建流程

在 Claude Code 或 Claude.ai 中说：

```
帮我创建一个知识库
```

### Step 2：回答问题

Claude 会问你：

1. **你想创建什么领域的知识库？**（如：AI & Agent、商业投资、医学、烹饪、法律……）
2. **vault 文件夹想叫什么名字？**（英文或中文均可）
3. **（可选）你在这个领域常收集什么类型的材料？**
4. **（可选）这个领域的知识大致可以分哪几种类型？**

### Step 3：获取 zip 包

解压后用 Obsidian 打开即可。

---

## 使用知识库

### Step 1：丢材料到 raw/

把你的原始材料丢进 `raw/` 文件夹：文章、论文、笔记、截图、PDF、想法、随手记录，任何格式都可以。

### Step 2：锁定 raw/

防止 AI 误改你的原始材料：

**Windows**：双击 `lock-raw.bat`

**Mac/Linux**：
```bash
chmod +x lock-raw.sh
./lock-raw.sh
```

### Step 3：编译知识库

```bash
cd your-knowledge-base
claude
> /compile
```

Claude 会：
- 扫描 raw/ 中的所有材料
- 提取核心洞察、概念、模型（原子笔记）
- 拆分多主题材料为独立笔记
- 建立笔记间的双向链接
- 生成多层级文件夹结构

### Step 4：整理知识结构

当原子笔记积累到 10+ 篇后：

```bash
> /summarize
```

Claude 会：
- 分析主题聚类
- 创建 MOC（Map of Content）导航笔记
- 创建主题总结笔记
- 补充双向链接
- 更新 INDEX.md

### Step 5：日常使用

```bash
> /compile      # 丢了新材料后，提取原子笔记
> /summarize    # 积累后，整理 MOC + 总结
> /todo         # 每天，整理日记和待办
> /write 帮我写一篇关于 xxx 的分析
> /health-check # 每月，全面体检
```

---

## 十个命令

### 提炼阶段

| 命令 | 作用 | 使用场景 |
|------|------|----------|
| `/compile` | 从 raw/ 提取原子笔记到 wiki | 丢了新材料后 |
| `/lint` | 检查格式并自动修复 | 编译后 |

### 整理阶段

| 命令 | 作用 | 使用场景 |
|------|------|----------|
| `/summarize` | 创建 MOC + 主题总结，建立多层级结构 | 积累一定笔记后 |
| `/research` | AI 主动搜索补充知识空白 | wiki 信息不足时 |

### 内化阶段

| 命令 | 作用 | 使用场景 |
|------|------|----------|
| `/todo` | 整理日记、待办、学习情况（合并去重） | 每天结束时 |
| `/review` | 生成间隔重复复习卡片 | 想深度内化时 |

### 应用阶段

| 命令 | 作用 | 使用场景 |
|------|------|----------|
| `/write` | 基于 wiki 写文章，新洞察可回流 | 想产出内容时 |
| `/publish` | 发布到数字花园 | 想公开分享时 |

### 复盘阶段

| 命令 | 作用 | 使用场景 |
|------|------|----------|
| `/health-check` | 全面体检，发现矛盾和空白 | 每月一次 |
| `/base` | 创建 Dataview 查询视图 | 想创建任务追踪等 |

---

## 知识闭环工作流

```
收集 → 提炼 → 整理 → 内化 → 应用 → 复盘
raw/  /compile /summarize /todo /write /health-check
      wiki/   _MOC/     daily/ outputs/  报告
             +总结      +review
                                   ↓
                                反馈 → raw/
```

### 场景一：日常知识积累

```bash
# 1. 丢材料
把看到的文章、笔记丢到 raw/

# 2. 编译（提取原子笔记）
> /compile

# 3. 整理结构（积累后）
> /summarize

# 4. 整理日记
> /todo

# 5. 产出
> /write 帮我写一篇关于 xxx 的深度分析
```

### 场景二：每日学习闭环

```bash
# 早上：查看今日任务
> /todo

# 学习中：丢材料、编译
> /compile

# 晚上：整理今日学习（自动合并去重）
> /todo

# 定期：健康检查
> /health-check
```

### 场景三：深度研究

```bash
# 1. 发现知识空白
> /health-check

# 2. 补充研究
> /research xxx 的最新进展

# 3. 重新编译
> /compile

# 4. 更新结构
> /summarize

# 5. 写深度文章
> /write 帮我写一篇 xxx 的完整综述
```

### 场景四：任务管理

```bash
# 创建任务追踪视图
> /base tasks

# 每日整理待办
> /todo

# 在笔记中标记任务
- [ ] 实践第一性原理分析 #todo 📅 2026-07-05
```

---

## Zettelkasten + MOC 方法论

### 三层笔记体系

1. **闪念笔记（Fleeting）** → `raw/` 中的随手记录
2. **文献笔记（Literature）** → `wiki/` 中的原子笔记（`/compile` 产出）
3. **永久笔记（Permanent）** → `wiki/_MOC/` 中的 MOC 和总结（`/summarize` 产出）

### 原子笔记原则

- 一个概念/洞察/模型 = 一篇笔记
- 一份 raw/ 材料涉及多个概念 → 拆分为多篇
- 多份材料讨论同一概念 → 合并到同一篇
- 每篇笔记末尾有"相关概念"章节，3+ 个 `[[]]` 链接

### MOC 导航

- `_MOC/知识总览.md` — 顶层导航，链接所有主题 MOC
- `_MOC/{主题}MOC.md` — 主题导航，链接该主题下所有笔记
- MOC 提供学习路径建议
- 每篇原子笔记应链接到对应的 MOC

### 多层级文件夹

```
wiki/
├── _MOC/
│   ├── 知识总览.md
│   └── 思维框架MOC.md
├── 思维框架/
│   ├── 思维框架-总结.md
│   ├── 基础概念/
│   │   ├── 第一性原理.md
│   │   └── 逆向思维.md
│   └── 决策模型/
│       └── OODA循环.md
```

---

## Dataview + Tasks 集成

### Tasks 插件语法

在笔记中标记任务：

```markdown
- [ ] 任务描述 #todo 📅 2026-07-05
- [x] 已完成任务 ✅ 2026-07-03
- [ ] 循环任务 🔁 every week 📅 2026-07-05
```

| 标记 | 含义 |
|------|------|
| `📅` | 截止日期 |
| `🔼` | 计划日期 |
| `🔁` | 循环规则 |
| `✅` | 完成日期 |
| `#todo` | 过滤标签 |

### Dataview 查询

在笔记中嵌入动态视图：

```
TABLE type, updated
FROM "wiki"
WHERE type = "concept"
SORT updated DESC
```

### /todo 命令

`/todo` 会自动：
- 扫描 vault 中所有任务
- 整理今日到期、逾期、本周任务
- 汇总今日学习情况（新增/更新的笔记）
- 生成个性化建议
- 写入 `daily/YYYY-MM-DD.md`

**多次执行 /todo 不会重复追加**，而是智能合并：
- 任务去重：相同任务不重复添加
- 学习更新：学习情况刷新为最新
- 建议更新：建议替换为最新

---

## 常用技巧

### /compile 与 /summarize 分工

```bash
# /compile 只负责提取原子笔记
> /compile

# 积累 10+ 篇后，/summarize 整理结构
> /summarize

# 继续丢材料、编译
> /compile

# 再次整理（更新 MOC 和总结）
> /summarize
```

### 知识回流

```bash
# 写文章时，新洞察会自动回流到 wiki
> /write 帮我写一篇 xxx 的分析

# Claude 会：
# 1. 基于 wiki 写文章
# 2. 保存到 outputs/
# 3. 提取新洞察、新概念、新关联
# 4. 回流到 wiki 相关文章
```

### 嵌入 Dataview 视图

```markdown
# 在任意笔记中嵌入 Dataview 视图
![[tasks#今日到期]]

# 嵌入 Dataview 查询
```dataview
TABLE type, updated
FROM "wiki"
WHERE updated >= date(today) - dur(7 days)
SORT updated DESC
```
```

---

## Quartz 数字花园

`/publish` 命令会将 wiki 文章转换到 `content/` 目录，配合 [Quartz](https://quartz.jzhao.xyz/) 可构建公开网站。

### 快速构建

```bash
# 1. 克隆 Quartz
git clone https://github.com/jackyzha0/quartz.git
cd quartz
npm i

# 2. 初始化（选择 Symlink an existing folder，粘贴 content 目录路径）
npx quartz create

# 3. 构建并预览
npx quartz build --serve
# 站点将在 http://localhost:8080 运行
```

### 自定义配置

主题、插件、部署等配置请参考 [Quartz 官方文档](https://quartz.jzhao.xyz/)。

---

## 常见问题

### Q1：/compile 和 /summarize 有什么区别？

- `/compile`：从 raw/ **提取**原子洞察、概念、模型，生成散落的原子笔记
- `/summarize`：**整理**原子笔记，创建 MOC 导航、主题总结、多层级结构、补充链接

### Q2：/todo 多次执行会重复吗？

不会。`/todo` 支持合并去重：
- 任务：相同任务不重复添加
- 学习情况：刷新为最新快照
- 建议：替换为最新建议
- 用户手动内容：保留不删除

### Q3：如何更新已有知识？

```bash
# 丢新材料到 raw/，运行 /compile，自动增量更新
> /compile

# 更新结构
> /summarize
```

### Q4：如何查看知识图谱？

Obsidian 自带图谱视图（左侧栏图谱图标）。通过 `[[]]` 双链自动生成关系图谱，无需额外命令。

### Q5：raw/ 中的材料格式很乱怎么办？

没关系！raw/ 就是用来丢原始材料的，不需要整理。`/compile` 会自动提取核心内容，生成结构化的原子笔记。

### Q6：sources 属性是什么格式？

使用 YAML 块列表 + 双链格式：

```yaml
sources:
  - "[[raw/第一性原理笔记.md]]"
  - "[[research/第一性原理-学术起源.md]]"
```

这样 Obsidian 能建立反向链接，原始材料也能看到被哪些笔记引用。

---

## 项目结构

```
okb-creator/
├── SKILL.md                       # Skill 主文件
├── CLAUDE.md                      # 示例系统指令
├── LICENSE                        # MIT 许可证
├── README.md                      # 项目文档（本文件）
├── commands/                      # 命令模板（复制到 vault 的 .claude/commands/）
│   ├── compile.md                 # /compile 编译命令
│   ├── summarize.md               # /summarize 整理命令
│   ├── todo.md                    # /todo 日记整理命令
│   ├── lint.md                    # /lint 格式检查命令
│   ├── write.md                   # /write 写作命令
│   ├── research.md                # /research 研究命令
│   ├── health-check.md            # /health-check 健康检查命令
│   ├── base.md                    # /base Dataview 视图命令
│   ├── review.md                  # /review 复习命令
│   └── publish.md                 # /publish 发布命令
├── templates/                     # 文档模板
│   ├── daily-template.md          # 日记模板
│   └── review-card-template.md    # 复习卡片模板
├── script/                        # 脚本文件
│   ├── lock-raw.bat               # Windows 锁定 raw/
│   ├── unlock-raw.bat             # Windows 解锁 raw/
│   ├── lock-raw.sh                # Mac/Linux 锁定 raw/
│   └── unlock-raw.sh              # Mac/Linux 解锁 raw/
└── references/                    # 参考文档
    └── claude-md-template.md      # CLAUDE.md 生成模板
```

---

## 致谢

本项目基于 [obsidian-kb-creator](https://github.com/XinYaoDev/obsidian-kb-creator) 优化改进，在此向原作者 [XinYaoDev](https://github.com/XinYaoDev) 致以感谢。

同时感谢以下项目和人物提供的灵感：

- [Andrej Karpathy](https://x.com/karpathy) — LLM Knowledge Bases 方法论
- [Obsidian](https://obsidian.md/) — 知识管理工具
- [Dataview](https://github.com/blacksmithgu/obsidian-dataview) — 动态查询插件
- [Tasks](https://github.com/obsidian-tasks-group/obsidian-tasks) — 任务管理插件
- [Claudian](https://github.com/YishenTu/claudian) — Obsidian 侧边栏集成
- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) — AI 编程工具
- Niklas Luhmann — Zettelkasten 方法论提出者

---

## License

MIT — 详见 [LICENSE](LICENSE)
