---
name: adult-scene-direction
description: 为明确指定的成年角色成人亲密场面设计镜头、动作、参考素材和声音，适用于 MiniMax H3／ComfyUI 1160 提示词、样片定位和局部修正。可由制作调度台或 H3 入口按场次调用。
---

# 成人场面调度与 H3 提示词

本技能专门解决成人向内容在 H3 / 1160 工作流中的高频问题：生殖器异形、接触融合、享受声失控、第一人称双手入画不自然、多语言对白与动作抢戏、男娘/扶他/贞操锁锁定失败等。

## 适用范围与调用

- 用户明确提出成人向性内容，或指定本专项来处理某一成年角色的亲密场面时，先读本页，再按具体镜头问题打开下方所需的参考。区分整部剧的分级和当前镜头真正要拍的内容。普通恋爱、写真、泳装、舞蹈、运动喘息或非性接触按原任务设计。服装、身体特征、身份表达和单个词本身不足以确定场景性质。
- 从 [制作调度台](../short-video-supervisor/SKILL.md) 或 [H3 入口](../h3-visual-prompting/SKILL.md) 进入时，只在相关场次应用专项。其他模型通过[仓库调用入口](../../../README.md#在聊天模式或其他模型中调用)读取同一版本文件。专项仅提供场面设计方法，执行以当前模型、工作流和工具的适用范围为准。
- 专项明确拍摄边界、参与者、动作与声音。成稿仍由 [H3 官方结构与 1160 输入](../h3-visual-prompting/references/h3-formats.md)决定 T2VA 三字段、Ref2VA 六字段或原生关键帧格式。只有用户要求预演且具备相应条件时，才接 [DirectorDesk](../directordesk-h3-previs/SKILL.md)。

## 使用流程

1. **确认边界与风格**  
   明确写实程度、是否允许露出、第一人称还是第三人称、对白语言、时长、参与者解剖类型（普通男女 / 男娘 / 扶他等）。

2. **准备或指定资产（按用户常见优先级）**  
   - **最常见**：只有一张穿衣服人物图 → 作为身份主图，下体与锁具全靠文本锁定（见 [clothing-and-reveal.md](references/clothing-and-reveal.md) 与 [explicit-reference-assets.md](references/explicit-reference-assets.md)）。  
   - **纯文生**：无任何参考图，必须加强三重正向锁定。  
   - **有局部参考时**：优先绑定下体 / 锁具特写，成功率最高。  
   只有全身穿着图时，保留分析仅说明图中可核对的身份、服装与实际保留范围。用户允许的新动作或后来可见的状态放进对应 Shot。

3. **设计镜头时强制检查**  
   - 关键接触 / 露出发生的瞬间，是否写清了正确解剖结构与响应。  
   - 动作是否拆成清晰的先后顺序（避免同帧竞争过多）。  
   - 享受声与对白是否分离控制。  
   - 需要第一人称手部入画时，参与动作的手能否在关键接触处保持可辨、自然。
   - 特殊解剖（男娘、扶他、贞操锁）是否被正向锁定（summary + 可见瞬间 + 结束状态）。

4. **成稿时**  
   在对应 Shot 写入可见起态、触发、变化与末态，跨镜承接人物方位、衣物与道具状态和可见反应。对白在实际发声处用原文，声景描述持续声音。导演清单和专项标题留在审稿，模型正文沿用该模式的字段。

5. **终审重点**  
   只看模型实际会读到的正文：解剖是否在可见时被明确描述、接触因果是否清楚、声音是否与动作同步、特殊设定是否保持。

## 核心原则（必须遵守）

- **可见才描述**：生殖器、接触、形变只在画面实际出现的时机写，且写清楚正确形状与比例。露出瞬间是锁定黄金窗口。
- **正向精确描述优先**：用 “accurately shaped”、“correct proportions”、“natural soft deformation”、“visible labia and dark pubic hair matching reference” 等，少用模糊或过度夸张词。
- **关键状态按镜头继承**：概述归纳目标，镜头正文明写动作和结果。只有状态影响后续镜头时，在下一镜起幅按可见内容接续。
- **动作拆分**：同一时间只让一个主要接触 / 露出事件成为焦点，其他动作为辅。
- **声音分层**：非语言享受声（喘息、呻吟）放 `overall_soundscape` + 动作处同步；对白用标准 `(S1)` + `<d>[Language] 原文</d>`。
- **参考职责清晰**：全身身份图与局部参考各自注明职责。已绑定的素材写准确名称和图号。未在素材中出现的、且用户允许新增的可见状态按镜头安排。
- **男娘 + 锁具优先策略**：外表女性化 + 男性下体 + 锁具正确锁住，三件事必须同时正向锁定。

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
- 成人向镜头与构图（xingheFF 景别/视角/光线表） → [camera-and-framing.md](references/camera-and-framing.md)
- 常见体位与动作模板（xingheFF 体位库强化） → [positions-and-acts.md](references/positions-and-acts.md)
- 享受声、呻吟、多语言对白 → [pleasure-sound-and-dialogue.md](references/pleasure-sound-and-dialogue.md)
- 第一人称双手入画与贴身 → [first-person-intimacy.md](references/first-person-intimacy.md)
- H3 NSFW 社区最佳实践（WeissGoat 接触锁定 + xingheFF） → [h3-nsfw-best-practices.md](references/h3-nsfw-best-practices.md)
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

交付范围沿用用户请求。需要审片或解释时，单列可观察的检查点及复拍条件。生成遵循度由实际样片判断。
