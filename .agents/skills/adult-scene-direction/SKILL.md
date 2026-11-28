---
name: adult-scene-direction
description: 专门处理成人向短视频的场面调度与 MiniMax H3／ComfyUI 1160 提示词。覆盖写实亲密场景的解剖准确性、男女生殖器、男娘/femboy、贞操锁、接触与形变描述、享受声与对白控制、第一人称视角、局部参考绑定及常见异形修复。当用户提到成人内容、亲密互动、生殖器、男娘、贞操锁、揉胸、口交、插入、呻吟、第一人称色情、露出等时使用。
---

# 成人场面调度与 H3 提示词

本技能专门解决成人向内容在 H3 / 1160 工作流中的高频问题：生殖器异形、接触融合、享受声失控、第一人称双手入画不自然、多语言对白与动作抢戏等。

与现有技能的关系：
- 由 `short-video-supervisor` 调度时，本技能作为专长岗位被调用。
- 与 `video-scene-direction` 互补，专注亲密接触与解剖层。
- 与 `h3-visual-prompting` 配合，输出符合六字段 / 三字段规范的正文。
- 需要白模预演时仍走 `directordesk-h3-previs`。

## 使用流程

1. **确认边界与风格**  
   明确写实程度、是否允许露出、第一人称还是第三人称、对白语言、时长、是否有男性身体出现。

2. **准备或指定资产**  
   优先使用局部参考（见 [explicit-reference-assets.md](references/explicit-reference-assets.md)）。只有全身图时，必须在正文中强化解剖描述。

3. **设计镜头时强制检查**  
   - 关键接触发生的瞬间，是否写清了正确解剖结构与响应。  
   - 动作是否拆成清晰的先后顺序（避免同帧竞争过多）。  
   - 享受声与对白是否分离控制。  
   - 第一人称双手是否始终可见且自然。

4. **成稿时**  
   按 `h3-visual-prompting` 的官方格式输出。成人专属写法见下方 references。

5. **终审重点**  
   只看模型实际会读到的正文：解剖是否在可见时被明确描述、接触因果是否清楚、声音是否与动作同步。

## 核心原则（必须遵守）

- **可见才描述**：生殖器、接触、形变只在画面实际出现的时机写，且写清楚正确形状与比例。
- **正向精确描述优先**：用 “accurately shaped”、“correct proportions”、“natural soft deformation”、“visible labia and dark pubic hair matching reference” 等，少用模糊或过度夸张词。
- **动作拆分**：同一时间只让一个主要接触事件成为焦点，其他动作为辅。
- **声音分层**：非语言享受声（喘息、呻吟）放 `overall_soundscape` + 动作处同步；对白用标准 `(S1)` + `<d>[Language] 原文</d>`。
- **参考职责清晰**：全身身份图与局部解剖图分开定义，retention 明确哪些 fully_preserved。

## 推荐阅读顺序

遇到具体问题时按需打开：

- 生殖器异形 / 比例崩坏 → [anatomy-writing.md](references/anatomy-writing.md) + [genital-anatomy.md](references/genital-anatomy.md)
- 男娘 / Femboy / Otoko no ko → [femboy-and-otokonoko.md](references/femboy-and-otokonoko.md)
- 贞操锁 / Chastity Cage → [chastity-cage.md](references/chastity-cage.md)
- H3 NSFW 社区最佳实践（正向重复、接触锁定、声音、词汇） → [h3-nsfw-best-practices.md](references/h3-nsfw-best-practices.md)
- 享受声、呻吟、多语言对白 → [pleasure-sound-and-dialogue.md](references/pleasure-sound-and-dialogue.md)
- 第一人称双手入画与贴身 → [first-person-intimacy.md](references/first-person-intimacy.md)
- 成人角色资产包与绑定 → [explicit-reference-assets.md](references/explicit-reference-assets.md)
- 常见失败与文本修复 → [common-failures.md](references/common-failures.md)

## 与调度台协作

当 `short-video-supervisor` 分派成人场次时，本技能负责：
- 解剖与接触层的导演稿
- 局部参考建议与绑定写法
- 享受声与对白的最终控制
- 异形风险的事前规避与事后文本修复建议

交付时附带简要风险提示（哪些部位最容易崩、建议的生成策略）。
