---
name: adult-scene-direction
description: |
  专门处理成人向短视频的场面调度与 MiniMax H3／ComfyUI 1160 提示词。
  覆盖写实/半写实亲密场景的解剖准确性、男女生殖器（penis/vagina/labia）、男娘/femboy/otokonoko、扶他/futanari、贞操锁/chastity cage、常见体位（missionary/cowgirl/doggy）、液体高潮/射精、dirty talk、多人场景、着衣露出/半脱、享受声与日语/多语言对白控制、第一人称POV双手入画、局部参考绑定、接触绝对状态锁定、常见异形与融合修复。
  当用户提到或涉及：成人内容、NSFW、色情、亲密互动、生殖器、插入、口交、手淫、高潮、呻吟、喘息、第一人称色情、露出、男娘、femboy、扶他、贞操锁、体位、湿润、精液、对白加享受声 等任何成人向元素时，优先调用本技能。
  与 h3-visual-prompting 严格配合输出六字段/三字段正文；由 short-video-supervisor 调度时作为专长岗位自动介入。
---

# 成人场面调度与 H3 提示词

本技能专门解决成人向内容在 H3 / 1160 工作流中的高频问题：生殖器异形、接触融合、享受声失控、第一人称双手入画不自然、多语言对白与动作抢戏、男娘/扶他/贞操锁锁定失败等。

与现有技能的关系：
- 由 `short-video-supervisor` 调度时，本技能作为专长岗位被自动调用（描述中含大量触发词，便于模型识别成人场次）。
- 与 `video-scene-direction` 互补，专注亲密接触、解剖与声音层。
- 与 `h3-visual-prompting` 严格配合：所有成稿必须符合官方六字段（Ref2VA）或三字段（T2VA）结构，成人增强只写入字段内部。
- 需要白模预演时仍走 `directordesk-h3-previs`。
- 调用优先级：当用户输入包含成人关键词时，优先读取本技能 references 再写 H3 正文。

## 使用流程

1. **确认边界与风格**  
   明确写实程度、是否允许露出、第一人称还是第三人称、对白语言、时长、参与者解剖类型（普通男女 / 男娘 / 扶他等）。

2. **准备或指定资产**  
   优先使用局部参考（见 [explicit-reference-assets.md](references/explicit-reference-assets.md)）。只有全身图时，必须在正文中强化解剖描述。

3. **设计镜头时强制检查**  
   - 关键接触发生的瞬间，是否写清了正确解剖结构与响应。  
   - 动作是否拆成清晰的先后顺序（避免同帧竞争过多）。  
   - 享受声与对白是否分离控制。  
   - 第一人称双手是否始终可见且自然。  
   - 特殊解剖（男娘、扶他、贞操锁）是否被正向锁定。

4. **成稿时**  
   按 `h3-visual-prompting` 的官方格式输出。成人专属写法见下方 references。

5. **终审重点**  
   只看模型实际会读到的正文：解剖是否在可见时被明确描述、接触因果是否清楚、声音是否与动作同步、特殊设定是否保持。

## 核心原则（必须遵守）

- **可见才描述**：生殖器、接触、形变只在画面实际出现的时机写，且写清楚正确形状与比例。
- **正向精确描述优先**：用 “accurately shaped”、“correct proportions”、“natural soft deformation”、“visible labia and dark pubic hair matching reference” 等，少用模糊或过度夸张词。
- **正向重复关键事实**：插入、接触、正确解剖至少在 summary / action / end state 出现 2–3 次。
- **动作拆分**：同一时间只让一个主要接触事件成为焦点，其他动作为辅。
- **声音分层**：非语言享受声（喘息、呻吟）放 `overall_soundscape` + 动作处同步；对白用标准 `(S1)` + `<d>[Language] 原文</d>`。
- **参考职责清晰**：全身身份图与局部解剖图分开定义，retention 明确哪些 fully_preserved。

## 推荐阅读顺序

遇到具体问题时按需打开：

**解剖与特殊设定**
- 生殖器异形 / 比例崩坏 → [anatomy-writing.md](references/anatomy-writing.md) + [genital-anatomy.md](references/genital-anatomy.md)
- 男娘 / Femboy / Otoko no ko → [femboy-and-otokonoko.md](references/femboy-and-otokonoko.md)
- 扶他 / 混合解剖 → [futanari-and-mixed.md](references/futanari-and-mixed.md)
- 贞操锁 / Chastity Cage → [chastity-cage.md](references/chastity-cage.md)

**动作与表现**
- 常见体位与动作模板 → [positions-and-acts.md](references/positions-and-acts.md)
- 液体、湿润、高潮 → [fluids-and-wetness.md](references/fluids-and-wetness.md)
- 高潮与射精表现 → [climax-and-orgasm.md](references/climax-and-orgasm.md)
- Dirty Talk 与成人对白 → [dirty-talk-and-dialogue.md](references/dirty-talk-and-dialogue.md)
- 着衣、半脱与露出 → [clothing-and-reveal.md](references/clothing-and-reveal.md)
- 多人场景 → [multi-person.md](references/multi-person.md)

**镜头、声音与实践**
- 成人向镜头与构图 → [camera-and-framing.md](references/camera-and-framing.md)
- 享受声、呻吟、多语言对白 → [pleasure-sound-and-dialogue.md](references/pleasure-sound-and-dialogue.md)
- 第一人称双手入画与贴身 → [first-person-intimacy.md](references/first-person-intimacy.md)
- H3 NSFW 社区最佳实践 → [h3-nsfw-best-practices.md](references/h3-nsfw-best-practices.md)
- 常用 LoRA / 触发词参考 → [lora-and-trigger.md](references/lora-and-trigger.md)

**资产与排错**
- 成人角色资产包与绑定 → [explicit-reference-assets.md](references/explicit-reference-assets.md)
- 常见失败与文本修复 → [common-failures.md](references/common-failures.md)

## 与调度台协作

当 `short-video-supervisor` 分派成人场次时，本技能负责：
- 解剖与接触层的导演稿
- 局部参考建议与绑定写法
- 享受声与对白的最终控制
- 异形风险的事前规避与事后文本修复建议

交付时附带简要风险提示（哪些部位最容易崩、建议的生成策略）。
