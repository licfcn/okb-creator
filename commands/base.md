创建 Dataview 查询视图，用于数据库式的知识管理和任务追踪。

## 功能说明

根据用户需求生成 Dataview 查询块（```dataview 代码块），保存为 .md 文件。配合 Obsidian Dataview 插件和 Tasks 插件使用。

## 前置条件

用户需安装以下 Obsidian 插件：
- **Dataview**：提供查询能力
- **Tasks**：提供任务管理能力（可选，增强任务查询）

## Dataview 查询基础

### DQL 查询语法

```
TABLE | LIST | TASK | CALENDAR
FROM <source>
WHERE <condition>
GROUP BY <expression>
SORT <expression> ASC|DESC
LIMIT <n>
```

### 常用属性

| 属性 | 说明 | 示例 |
|------|------|------|
| `file.name` | 文件名 | `第一性原理` |
| `file.path` | 完整路径 | `wiki/思维框架/第一性原理.md` |
| `file.folder` | 文件夹路径 | `wiki/思维框架` |
| `file.ctime` | 创建时间 | `2026-06-27` |
| `file.mtime` | 修改时间 | `2026-06-27` |
| `file.tags` | 所有标签 | `[思维模型, 推理]` |
| `file.links` | 出链 | `[[思维模型]], [[马斯克]]` |
| `file.outlinks` | 出链列表 | 同上 |
| `file.inlinks` | 入链列表（反向链接） | `[[决策框架]]` |
| `type` | frontmatter 的 type | `concept` |
| `status` | frontmatter 的 status | `stable` |
| `updated` | frontmatter 的 updated | `2026-06-27` |
| `tags` | frontmatter 的 tags | `[思维模型]` |

### 常用函数

| 函数 | 说明 |
|------|------|
| `contains(field, value)` | 字段包含值 |
| `containsword(field, word)` | 字段包含单词 |
| `startsWith(str, prefix)` | 字符串前缀匹配 |
| `date(text)` | 解析为日期 |
| `dur(text)` | 解析为时长 |
| `today()` | 今天 |
| `now()` | 当前时间 |
| `length(list)` | 列表长度 |

## 预设模板

### 1. 任务追踪（tasks）

```markdown
---
type: view
title: 任务追踪
tags: [view, dataview]
---

# 📋 任务追踪

## 🔴 今日到期

```dataview
TASK
WHERE !completed AND due = date(today)
GROUP BY file.link
```

## 🟡 逾期任务

```dataview
TASK
WHERE !completed AND due < date(today)
SORT due ASC
```

## 🟢 本周任务

```dataview
TASK
WHERE !completed AND due >= date(today) AND due <= date(today) + dur(7 days)
GROUP BY file.link
SORT due ASC
```

## ✅ 近期完成

```dataview
TASK
WHERE completed AND completion >= date(today) - dur(7 days)
GROUP BY file.link
```

## 📊 任务统计

```dataview
TABLE 
  length(filter(file.tasks, (t) => !t.completed)) AS 待完成,
  length(filter(file.tasks, (t) => t.completed)) AS 已完成,
  length(file.tasks) AS 总计
FROM ""
WHERE length(file.tasks) > 0
SORT length(filter(file.tasks, (t) => !t.completed)) DESC
LIMIT 20
```
```

### 2. 阅读列表（reading）

```markdown
---
type: view
title: 阅读列表
tags: [view, dataview]
---

# 📚 阅读列表

## 📖 阅读中

```dataview
TABLE author, progress, updated
FROM "wiki"
WHERE contains(tags, "reading") AND status = "reading"
SORT updated DESC
```

## 📋 待读

```dataview
TABLE author, pages
FROM "wiki"
WHERE contains(tags, "reading") AND status = "to-read"
SORT file.name ASC
```

## ✅ 已读

```dataview
TABLE author, finished_date
FROM "wiki"
WHERE contains(tags, "reading") AND status = "done"
SORT finished_date DESC
```
```

### 3. 时间线（timeline）

```markdown
---
type: view
title: 时间线
tags: [view, dataview]
---

# 📅 时间线

## 最近更新

```dataview
TABLE type, updated, file.folder
FROM "wiki"
WHERE type != "moc" AND type != "summary" AND !startsWith(file.name, "_")
SORT updated DESC
LIMIT 30
```

## 按月分组

```dataview
TABLE type, file.folder
FROM "wiki"
WHERE type != "moc" AND type != "summary" AND !startsWith(file.name, "_")
GROUP BY dateformat(updated, "yyyy-MM") AS 月份
SORT 月份 DESC
```

## 今日日记

```dataview
LIST
FROM "daily"
WHERE date = date(today)
```
```

### 4. 概念索引（concepts）

```markdown
---
type: view
title: 概念索引
tags: [view, dataview]
---

# 🧠 概念索引

## 按类型

```dataview
TABLE type, file.folder, updated
FROM "wiki"
WHERE type != "moc" AND type != "summary" AND !startsWith(file.name, "_")
GROUP BY type
SORT updated DESC
```

## 高连接度笔记

```dataview
TABLE type, length(file.inlinks) AS 入链, length(file.outlinks) AS 出链
FROM "wiki"
WHERE type != "moc" AND type != "summary" AND !startsWith(file.name, "_")
SORT length(file.inlinks) + length(file.outlinks) DESC
LIMIT 20
```

## 孤立笔记（需补充链接）

```dataview
LIST
FROM "wiki"
WHERE type != "moc" AND type != "summary" AND !startsWith(file.name, "_") AND length(file.inlinks) = 0
```
```

### 5. 项目管理（projects）

```markdown
---
type: view
title: 项目管理
tags: [view, dataview]
---

# 🚀 项目管理

## 进行中项目

```dataview
TABLE status, start_date, updated
FROM "wiki"
WHERE type = "project" AND status = "active"
SORT updated DESC
```

## 项目任务

```dataview
TASK
FROM "wiki"
WHERE type = "project" AND !startsWith(file.name, "_")
GROUP BY file.link
```

## 所有项目

```dataview
TABLE status, start_date, end_date, file.folder
FROM "wiki"
WHERE type = "project"
GROUP BY status
SORT file.folder ASC
```
```

### 6. 文件夹视图（folders）

```markdown
---
type: view
title: 文件夹视图
tags: [view, dataview]
---

# 📁 文件夹视图

## 多层级结构

```dataview
TABLE type, status, updated
FROM "wiki"
WHERE !startsWith(file.name, "_")
GROUP BY file.folder
SORT file.folder ASC
```

## 按层级深度

```dataview
TABLE length(split(file.folder, "/")) AS 层级, file.name, type
FROM "wiki"
WHERE !startsWith(file.name, "_") AND file.folder != "wiki"
SORT length(split(file.folder, "/")) ASC, file.folder ASC
```

## 各文件夹文章数

```dataview
TABLE length(rows) AS 文章数
FROM "wiki"
WHERE !startsWith(file.name, "_")
GROUP BY file.folder
SORT length(rows) DESC
```
```

### 7. 最近修改（recent）

```markdown
---
type: view
title: 最近修改
tags: [view, dataview]
---

# 🕒 最近修改

## 今日更新

```dataview
TABLE type, updated
FROM "wiki"
WHERE updated = date(today) AND !startsWith(file.name, "_")
SORT updated DESC
```

## 本周更新

```dataview
TABLE type, file.folder
FROM "wiki"
WHERE updated >= date(today) - dur(7 days) AND !startsWith(file.name, "_")
SORT updated DESC
LIMIT 50
```

## 最近创建

```dataview
TABLE type, dateformat(file.ctime, "yyyy-MM-dd") AS 创建时间
FROM "wiki"
WHERE !startsWith(file.name, "_")
SORT file.ctime DESC
LIMIT 20
```
```

### 8. 日记总览（daily）

```markdown
---
type: view
title: 日记总览
tags: [view, dataview]
---

# 📔 日记总览

## 近期日记

```dataview
TABLE date AS 日期, length(file.tasks) AS 任务数
FROM "daily"
WHERE type = "daily"
SORT date DESC
LIMIT 14
```

## 未完成任务（跨日记）

```dataview
TASK
FROM "daily"
WHERE !completed
GROUP BY file.link
SORT file.link DESC
```

## 本周日记

```dataview
LIST
FROM "daily"
WHERE date >= date(today) - dur(7 days)
SORT date DESC
```
```

## 执行步骤

### 1. 理解用户需求

根据用户输入关键词推断视图类型：

| 关键词 | 模板 |
|--------|------|
| `tasks`、`任务` | 任务追踪 |
| `reading`、`阅读` | 阅读列表 |
| `timeline`、`时间线` | 时间线 |
| `concepts`、`概念` | 概念索引 |
| `projects`、`项目` | 项目管理 |
| `folders`、`文件夹` | 文件夹视图 |
| `recent`、`最近` | 最近修改 |
| `daily`、`日记` | 日记总览 |

无匹配时根据知识库 type 分类自动生成通用视图。

### 2. 生成视图文件

将对应模板内容保存到 `wiki/{名称}.md`（或用户指定路径）。

### 3. 更新变更日志

```markdown
## YYYY-MM-DD HH:MM - 创建 Dataview 视图

- 视图名称：XX
- 视图类型：XX
- 保存位置：wiki/XX.md
```

## 使用示例

```bash
# 任务追踪
/base tasks

# 阅读列表
/base reading

# 自定义：按标签查询
/base my-view --query 'TABLE type, updated FROM #思维模型 SORT updated DESC'

# 自定义：特定文件夹
/base my-folder --query 'LIST FROM "wiki/思维框架"'
```

## 嵌入到其他笔记

Dataview 视图可以嵌入到任意笔记中：

```markdown
# 我的仪表盘

## 今日任务
![[tasks#今日到期]]

## 最近更新
![[recent#今日更新]]
```

## 注意事项

- Dataview 查询使用 ```dataview 代码块
- TASK 查询需要 Tasks 插件配合才能识别 `📅` 等emoji 标记
- 日期比较使用 `date()` 函数包装
- 文件夹路径用双引号：`FROM "wiki/思维框架"`
- 标签查询用 `#标签名`：`FROM #思维模型`
- `file.inlinks` 和 `file.outlinks` 可用于分析连接度
- 视图文件本身也有 frontmatter，type 设为 `view`
