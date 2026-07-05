---
date: {{date}}
type: daily
week: {{week}}
tags: [daily]
---

# {{date}} {{weekday}}

## 📋 今日待办

> 执行 /todo 自动整理，也可手动添加

- [ ] 

## 📖 今日学习

### 新增/更新笔记

> 由 /todo 自动填充

### 待复习

> 由 /todo 自动填充

## 📅 本周计划

> 周一由 /todo 生成本周计划框架，其余天数增量更新

- [ ] 

## 💡 学习建议

> 由 /todo 基于知识库状态生成

## 📊 任务总览

### 今日到期任务

```dataview
TASK
WHERE !completed AND due = date(this.date)
GROUP BY file.link
```

### 逾期任务

```dataview
TASK
WHERE !completed AND due < date(this.date)
SORT due ASC
```

### 本周任务

```dataview
TASK
WHERE !completed AND due >= date(this.date) AND due <= date(this.date) + dur(7 days)
GROUP BY file.link
```

## 📈 知识库动态

### 今日更新笔记

```dataview
TABLE type, updated
FROM "wiki"
WHERE updated = date(this.date) AND type != "moc" AND type != "summary"
SORT updated DESC
```

### 最近一周新增

```dataview
TABLE type, updated
FROM "wiki"
WHERE updated >= date(this.date) - dur(7 days) AND type != "moc" AND type != "summary"
SORT updated DESC
LIMIT 20
```

## ✏️ 随手记录

> 自由记录区域，想法、灵感、反思

---

🔗 [[昨日日记]] | [[明日日记]] | [[本周回顾]]
