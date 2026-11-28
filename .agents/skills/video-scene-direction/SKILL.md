---
name: video-scene-direction
description: 将一句话创意增强为视频分镜，设计人物站位与走位、真人表演、摄影机运动、正反打与动作接切、奇幻场面、对白时长、音乐与音效。适用于 AI 短剧、漫剧、舞蹈、多人互动，以及借鉴 Seedance 为 MiniMax H3 改写提示词。
---

# 视频动作与视听调度

先确定这一段观众要看懂的动作、产生的感受和看到的结果。用户已锁定的人物、服装、对白、画风和画幅照常使用。出现执行问题时，先找动作、机位、切点、声音或素材的哪一项出了问题。用户只改其中一项时，保留其余设计。

- 动作含糊、双人接不上或奇幻交锋缺少因果时，读[动作指导与编排](references/action-direction.md)。舞步、队形、冰上动作或音乐跨段时，读[舞蹈与冰上动作设计](references/dance-and-skating.md)；Twerk 与 K-pop 舞蹈读其 [Twerk 与高能编舞](references/dance-and-skating.md#twerk-与高能-k-pop-舞蹈)小节。
- K-pop 女团 MV、舞蹈跟拍或用户明确要求摄影机持续运动时，读[摄影与切镜调度](references/camera-and-cutting.md#舞蹈-mv-动态跟拍)，逐镜设计可见的摄影机路径、景别和动作接点，不能只写“动感运镜”。
- 破坏效果只剩粒子、布景跨镜重建或损伤复原时，按[场景连续性与破坏](references/action-direction.md#场景连续性与破坏)限定受击位置和残留状态。
- 运镜、构图和换机位干扰动作，或需要做对话、舞蹈、战斗分镜时，读[摄影与切镜调度](references/camera-and-cutting.md)。
- 人物串位、目光偏移或道具交接失败时，读[人物走位与真人表演](references/performance-and-blocking.md)。真人短剧、宅家或街头自拍、情绪和口型僵硬时，读[真人表演、口型与写真质感](references/live-action-performance.md)。
- 用户给了详细样稿，或需要从首帧到收尾的长镜头设计、多空间动作、复杂转场时，读[电影镜头设计与提示词交付](references/cinematic-shot-plan.md)。用其画面、空间、轨迹和声音六部分组织导演稿，并按实际工作流输出。
- 高速交锋、攻守换位和多段接镜用[高速动作与场面升级](references/action-direction.md#高速动作与场面升级)。需要冲击分级、分层特效或遮挡接剪时，读[高密度动作与特效分镜](references/cinematic-shot-plan.md#高密度动作与特效分镜)。
- 半写实 3DCG、三渲二或真人的质感与表演方式出现混用时，读[画面美术与角色渲染](references/look-design.md)。画面有可见冲击、水浪、气流、崩落或光效时，按[特效、材质与环境响应](references/vfx-design.md)落实主形、受力、声响和残留。
- 对白原文需要排进固定时长时，读[对白时长与切镜](references/music-and-sound.md#对白时长与切镜)。卡拍、动作拟音和跨镜声场也在同一文档。
- 想把 Seedance 或其他样片的画面表现用到 H3，读[样片拆解与风格迁移](references/visual-style-transfer.md)，提取可观察的光影、构图、材质、表演节奏和摄影手法。
- 用户只给一句话或让模型发挥时，按[一句话创意的自动增强](references/prompt-enhancement.md#一句话创意的自动增强)设计。要精确分镜或动作控制时按同页的详细流程。

多镜头或精确卡点任务共用一张时间表，记录关键动作、机位、切点与声音。复杂场面或用户要求全程紧凑时，按[逐秒检查画面进程](references/prompt-enhancement.md#逐秒检查画面进程)把持续动作、留白、触发与结果贯穿到片尾。交付前按任务核对时长、连续性、左右关系、素材职责和声音触发。

接到编剧稿时沿用人物动机、台词和结果，补观众实际看到的表演、机位、环境和声音。交给 H3 时附上在具体镜头生效的动作、可见细节及素材职责。需要工程预演时，从同一份镜头安排提取走位、朝向、运动和切点，见 [DirectorDesk 白模预演](../directordesk-h3-previs/SKILL.md)。

直接从本入口交付模型提示词时，按[两轮调度与终审](../short-video-supervisor/references/review-loop.md#两轮调度与终审)核对成稿。同一任务由调度台统筹时，把设计证据交回它终审。用户提供样稿用于学习时，按[结构化样稿拆解](references/visual-style-transfer.md#拆解结构化提示词与分镜样稿)提炼方法与适用条件。
