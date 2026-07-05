将 wiki 文章发布到 content/ 目录，生成 Quartz 数字花园格式。

## 功能说明

将 wiki/ 中的文章转换为 Quartz 格式，发布到 content/ 目录，用于构建公开的数字花园网站。

## Quartz Frontmatter 字段

```yaml
---
title: 页面标题
description: 用于链接预览的页面描述
aliases: [别名1, 别名2]
tags: [标签1, 标签2]
draft: false  # 是否私密（true = 不发布）
date: 2026-06-27  # 发布日期（YYYY-MM-DD）
---
```

## 执行步骤

### 1. 选择要发布的文章

根据用户输入确定要发布的文章：

**参数说明**：
- 文章名：发布指定文章
- `--status <status>`：发布特定状态的文章（如 stable）
- `--folder <folder>`：发布特定文件夹的文章
- `--tag <tag>`：发布特定标签的文章
- `--all`：发布所有符合条件的文章

**默认过滤**：
- `status: stable`（稳定状态）
- `draft: false`（非私密）
- 排除 `_` 开头的文件

### 2. 转换 Frontmatter

**从 wiki 格式转换为 Quartz 格式**：

**wiki frontmatter**：
```yaml
---
topic: 第一性原理
type: concept
status: stable
freshness: evergreen
updated: 2026-06-27
tags: [思维模型, 推理, 物理学]
sources:
  - "[[raw/第一性原理笔记.md]]"
---
```

**转换为 Quartz frontmatter**：
```yaml
---
title: 第一性原理
description: 一种从本质出发的思维方法，将问题分解到最基本的事实和假设，然后从头开始构建解决方案
aliases: [First Principles, 第一性原理思维]
tags: [思维模型, 推理, 物理学]
date: 2026-06-27
draft: false
---
```

**转换规则**：

| wiki 字段 | Quartz 字段 | 转换方式 |
|-----------|-------------|----------|
| `topic` | `title` | 直接使用 |
| 第一段摘要 | `description` | 提取前 150 字符 |
| `topic` | `aliases` | 生成常见别名 |
| `tags` | `tags` | 直接使用 |
| `updated` | `date` | 直接使用 |
| - | `draft` | 默认 false，可设置 |

### 3. 处理内部链接

**Obsidian 内部链接**：
```markdown
[[第一性原理]]
[[思维模型#核心要点]]
[[马斯克|埃隆·马斯克]]
```

**转换为相对路径**：
```markdown
[第一性原理](../notes/第一性原理)
[思维模型](../notes/思维模型#核心要点)
[埃隆·马斯克](../people/马斯克)
```

**链接映射规则**：

| wiki 路径 | content 路径 | 相对链接 |
|-----------|--------------|----------|
| `wiki/思维框架/第一性原理.md` | `content/notes/第一性原理.md` | `../notes/第一性原理` |
| `wiki/人物/马斯克.md` | `content/people/马斯克.md` | `../people/马斯克` |

### 4. 处理嵌入

**Obsidian 嵌入**：
```markdown
![[第一性原理]]
![[image.png]]
```

**转换为 Quartz 格式**：
```markdown
![](../notes/第一性原理)
![](../assets/image.png)
```

### 5. 处理 Callouts

**Obsidian Callouts**：
```markdown
> [!note] 标题
> 内容
```

**Quartz 支持 Callouts**，保持原格式即可。

### 6. 创建 content 目录结构

```
content/
├── index.md               # 首页
├── about.md               # 关于页面
├── notes/                 # 笔记（对应 wiki/思维框架、wiki/概念等）
│   ├── 第一性原理.md
│   ├── 思维模型.md
│   └── ...
├── concepts/              # 概念（对应 wiki/概念）
│   └── ...
├── frameworks/            # 框架（对应 wiki/框架）
│   └── ...
├── tools/                 # 工具（对应 wiki/工具）
│   └── ...
├── projects/              # 项目（对应 wiki/项目）
│   └── ...
├── people/                # 人物（对应 wiki/人物）
│   └── ...
└── resources/             # 资源（对应 wiki/资源）
    └── ...
```

### 7. 生成文章

**目标文件**：`content/{分类}/{文章名}.md`

**完整示例**：

**源文件**：`wiki/思维框架/第一性原理.md`

```markdown
---
topic: 第一性原理
type: concept
status: stable
freshness: evergreen
updated: 2026-06-27
tags: [思维模型, 推理, 物理学]
sources:
  - "[[raw/第一性原理笔记.md]]"
---

第一性原理（First Principles）是一种思维方法，要求将问题分解到最基本的事实和假设，然后从头开始构建解决方案。与类比思维相对，它强调从本质出发而非从既有经验出发。

## 定义

第一性原理源自物理学和哲学，指"最基本的、不能从其他命题推导出来的命题"。在思维模型中，它代表一种**从零开始推理**的方法论。

埃隆·马斯克（[[马斯克]]）是这一思维的著名实践者。

## 核心要点

### 1. 分解问题

将复杂问题拆解为最基本单元。

### 2. 重新构建

从基本单元出发，寻找新路径。

## 相关概念

- [[思维模型]]
- [[逆向思维]]
```

**生成的 content 文件**：`content/notes/第一性原理.md`

```markdown
---
title: 第一性原理
description: 一种从本质出发的思维方法，将问题分解到最基本的事实和假设，然后从头开始构建解决方案。与类比思维相对，它强调从本质出发而非从既有经验出发。
aliases: [First Principles, 第一性原理思维]
tags: [思维模型, 推理, 物理学]
date: 2026-06-27
draft: false
---

第一性原理（First Principles）是一种思维方法，要求将问题分解到最基本的事实和假设，然后从头开始构建解决方案。与类比思维相对，它强调从本质出发而非从既有经验出发。

## 定义

第一性原理源自物理学和哲学，指"最基本的、不能从其他命题推导出来的命题"。在思维模型中，它代表一种**从零开始推理**的方法论。

埃隆·马斯克（[马斯克](../people/马斯克)）是这一思维的著名实践者。

## 核心要点

### 1. 分解问题

将复杂问题拆解为最基本单元。

### 2. 重新构建

从基本单元出发，寻找新路径。

## 相关概念

- [思维模型](../notes/思维模型)
- [逆向思维](../notes/逆向思维)
```

### 8. 生成首页和导航

**生成 index.md**：

```markdown
---
title: 首页
description: 欢迎来到我的数字花园
---

# 欢迎来到我的数字花园 🌱

这里是我用 [[Quartz]] 构建的知识库公开部分。

## 最近更新

- [第一性原理](notes/第一性原理) - 2026-06-27
- [思维模型](notes/思维模型) - 2026-06-26

## 主题分类

- [[笔记]] - 所有笔记
- [[概念]] - 核心概念
- [[框架]] - 方法论框架
- [[工具]] - 工具和技术
- [[项目]] - 项目案例
- [[人物]] - 人物和组织

## 关于

这是一个基于 Obsidian + Quartz 的数字花园，记录我的学习和思考。

[了解更多](about)
```

**生成 about.md**：

```markdown
---
title: 关于
description: 关于这个数字花园
---

# 关于这个数字花园 🌿

## 这是什么？

这是我的**数字花园**（Digital Garden）——一个公开的知识库，记录我的学习、思考和探索。

## 为什么是数字花园？

不同于传统的博客（按时间顺序发布），数字花园更像是一个**生长中的知识网络**：

- 🌱 **种子**：刚萌发的想法，可能不完整
- 🌿 **幼苗**：正在发展的笔记，持续更新
- 🌳 **大树**：成熟的文章，相对稳定
- 🔗 **连接**：概念之间的关联

## 如何构建？

这个数字花园使用以下工具构建：

- **[Obsidian](https://obsidian.md/)** - 知识管理工具
- **[Quartz](https://quartz.jzhao.xyz/)** - 静态站点生成器
- **[Claude Code](https://docs.anthropic.com/en/docs/claude-code)** - AI 辅助

## 内容来源

这里的内容来自我的个人知识库，经过筛选后公开分享。

- ✅ **公开**：稳定状态、有价值的知识
- 🔒 **私密**：草稿、个人笔记、敏感信息

## 联系方式

- GitHub: [your-github]
- Twitter: [your-twitter]
- Email: [your-email]

---

最后更新：2026-06-27
```

### 9. 更新变更日志

在 `wiki/_changelog.md` 顶部追加：

```markdown
## YYYY-MM-DD HH:MM - 发布到数字花园

- 发布文章：{文章名}
- 源位置：wiki/{分类}/{文章名}.md
- 目标位置：content/{分类}/{文章名}.md
- 状态：公开/私密
```

## 使用示例

```bash
# 发布单篇文章
/publish 第一性原理

# 发布所有 stable 状态的文章
/publish --status stable

# 发布特定文件夹
/publish --folder 思维框架

# 发布特定标签
/publish --tag 思维模型

# 发布并设置为私密
/publish 第一性原理 --draft

# 发布所有（排除 draft）
/publish --all

# 重新生成首页
/publish --generate-index
```

## 参数说明

| 参数 | 说明 | 示例 |
|------|------|------|
| 文章名 | 发布指定文章 | `/publish 第一性原理` |
| `--status <status>` | 发布特定状态的文章 | `/publish --status stable` |
| `--folder <folder>` | 发布特定文件夹 | `/publish --folder 思维框架` |
| `--tag <tag>` | 发布特定标签 | `/publish --tag 思维模型` |
| `--all` | 发布所有符合条件的文章 | `/publish --all` |
| `--draft` | 设置为私密（不发布） | `/publish 第一性原理 --draft` |
| `--generate-index` | 重新生成首页 | `/publish --generate-index` |
| `--force` | 强制覆盖已存在的文件 | `/publish 第一性原理 --force` |

## 输出报告

发布完成后输出：

```
数字花园发布完成！

📄 源文章：wiki/思维框架/第一性原理.md
🌐 目标位置：content/notes/第一性原理.md

📊 转换统计：
- 内部链接：3 个（已转换为相对路径）
- 嵌入：0 个
- Callouts：0 个（保持原格式）

✅ Quartz Frontmatter：
- title: 第一性原理
- description: 一种从本质出发的思维方法...
- tags: [思维模型, 推理, 物理学]
- date: 2026-06-27
- draft: false

💡 下一步：
1. 检查 content/notes/第一性原理.md
2. 使用 Quartz 构建站点：npx quartz build
3. 预览站点：npx quartz preview
4. 部署到 GitHub Pages 或其他平台
```

## Quartz 部署流程

### 1. 安装 Quartz

```bash
git clone https://github.com/jackyzha0/quartz.git
cd quartz
npm i
```

### 2. 初始化并导入 content

```bash
npx quartz create
# 选择 "Symlink an existing folder" 或手动复制 content/ 到 Quartz 项目
```

### 3. 构建和预览

```bash
npx quartz build --serve
# 站点将在 http://localhost:8080 运行
```

### 4. 自定义配置

Quartz 的主题、插件、部署等自定义配置请参考 [Quartz 官方文档](https://quartz.jzhao.xyz/)。

## 发布策略建议

### 内容筛选

**应该发布**：
- ✅ `status: stable` - 稳定状态
- ✅ 有价值的知识 - 可帮助他人
- ✅ 完整的内容 - 不是草稿
- ✅ 适合公开 - 不含敏感信息

**不应该发布**：
- ❌ `status: draft` - 草稿状态
- ❌ 个人笔记 - 私密内容
- ❌ 未完成的内容 - 还在演化
- ❌ 敏感信息 - 不适合公开

### 更新策略

**定期发布**：
- 每周：发布新完成的 stable 文章
- 每月：更新已有文章
- 按需：重要内容及时发布

**版本管理**：
- 更新 `date` 字段记录发布时间
- 使用 `aliases` 支持旧名称跳转

## 注意事项

- 内部链接必须转换为相对路径
- 图片等资源需要复制到 content/assets/
- `draft: true` 的文章不会被 Quartz 发布
- 定期检查链接是否有效
- 保持 content/ 和 wiki/ 的同步