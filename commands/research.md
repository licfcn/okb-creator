基于 wiki/ 中发现的知识空白或矛盾，主动搜索外部信息进行补充研究。

## 触发方式

### 手动触发
用户直接输入 `/research 具体主题`，如 `/research 第一性原理的学术起源`。

### 其他命令建议触发
当 /write、/health-check、/compile 发现知识不足时，会建议用户执行 /research。
用户确认后才执行，AI 不会自动研究。

## 流程

### 1. 明确研究目标

如果用户没有指定具体主题，向用户确认：
- 要研究什么？
- 研究的背景是什么？（哪篇 wiki 文章信息不足？哪些内容互相矛盾？）
- 需要多深入？（快速查证一个事实 / 全面了解一个概念）

### 2. 搜索与整理

使用 web_search 工具搜索相关信息：
- 根据主题制定 2-5 个搜索关键词，逐个搜索
- 优先信任权威来源：学术论文、官方文档、权威媒体、行业报告
- 跳过低质量来源：营销内容、无来源博客、SEO 文章
- 如果需要深入了解某个搜索结果，使用 web_fetch 获取完整内容
- 综合多个来源，用自己的语言整理（不复制原文）

### 3. 保存到 research/

将研究结果保存为 Markdown 文件，格式如下：

文件命名：`research/YYYY-MM-DD-研究主题.md`

文件内容：
```markdown
---
query: "实际使用的搜索关键词"
searched_at: YYYY-MM-DD
trigger: 触发研究的原因（如：/health-check 发现矛盾 / /write 发现知识空白 / 用户手动请求）
related_wiki: [相关的 wiki 文章路径列表]
sources_url:
  - https://来源1的URL
  - https://来源2的URL
status: pending_review
---

## 研究背景

（简要说明为什么需要研究这个主题，来自哪个 wiki 文章的需求）

## 研究发现

（用自己的语言整理搜索结果，按要点组织。每个关键发现标注来源 URL。）

### 发现 1：xxx
（内容...）
来源：[文章标题](URL)

### 发现 2：xxx
（内容...）
来源：[文章标题](URL)

## 对 wiki 的建议

（基于研究发现，建议如何更新 wiki：）
- 哪些 wiki 文章需要更新什么内容
- 是否需要创建新的 wiki 文章
- 是否能解决之前发现的矛盾
```

### 4. 研究报告

完成后向用户报告：

```
🔍 研究完成：
- 📄 保存到：research/YYYY-MM-DD-xxx.md
- 🔗 搜索了 X 个来源，整理了 X 条发现
- 📝 建议更新 wiki 文章：（列出文章名）
- 🆕 建议新建 wiki 文章：（列出建议的新文章，如果有）

状态为 pending_review，你可以：
- 查看 research/ 中的文件，确认内容没问题
- 然后运行 /compile，研究结果会被编译进 wiki
- 或者告诉我"直接编译"，我现在就把研究发现更新到 wiki
```

### 5. 快速编译（可选）

如果用户说"直接编译"或"更新到 wiki"：
- 将 research 文件的 status 改为 `compiled`
- 根据"对 wiki 的建议"章节，直接增量更新相关 wiki 文章或创建新文章
- wiki 文章的 sources 中标注来源为 research/ 文件
- 更新 wiki/_compile-log.md 和 wiki/_changelog.md

### 6. 记录变更

在 `wiki/_changelog.md` 顶部追加本次研究记录。

## 注意

- 搜索结果用自己的语言整理，不要大段复制原文
- 每条关键发现都要标注来源 URL，确保可追溯
- research/ 中的文件不受 raw/ 的只读保护限制，AI 可以自由写入
- research/ 中的文件 status 为 pending_review 时，/compile 也会编译它，但会在编译报告中特别标注"来自 AI 研究，尚未人工审核"
- 如果搜索结果和 wiki 现有内容矛盾，保留两种说法并标注各自来源，不要武断取舍
ENDOFFILE