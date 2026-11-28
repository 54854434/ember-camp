---
name: h3-visual-prompting
description: 为 ComfyUI MiniMax H3 自动增强视频提示词，结合 MiniMax 官方正文与本机 1160 封装，排查运镜、站位、动作和道具连续性。适用于 1160 四步 Turbo、Ref2VA、原生首尾帧及白底人物三视图、半身和面部细节参考。
---

# MiniMax H3 视觉提示词

按实际模型、LoRA、时长、画幅与已绑定素材执行。走[官方正文与本机交付](references/h3-formats.md#从官方正文到本机交付)，按参考类型读取 MiniMax 官方指南，再按实际节点与用户用途决定交付正文或完整 1160 封装。已确认的角色、场景、对白和镜头意图作为改写约束。需要 DirectorDesk 时走 [预演交接](../directordesk-h3-previs/references/h3-handoff.md#给写剧本的对话)。

凡是要设计或修改镜头，包括用户只给一句话、只要提示词或直接调用本技能的情况，都走[两轮调度与终审](../short-video-supervisor/references/review-loop.md#两轮调度与终审)。先按实际场面打开需要的专长资料；完成后只看模型实际会读到的正文和已绑素材，逐项补齐关键要求的画面或声音证据。纯原样排版只核对原文和格式，局部改动另检查受影响的前后镜。

- 从一句话或开放想法开始时用[创意增强](../video-scene-direction/references/prompt-enhancement.md#一句话创意的自动增强)。新写或重写完整 H3 段直接进[四阶段成稿](../video-scene-direction/references/prompt-enhancement.md#h3-四阶段成稿)，先写逐秒导演稿和独立的中文模型执行稿，再转成目标语言封装。
- 交付 T2VA 或 Ref2VA 文件时，可用[格式检查器](scripts/check_h3_prompt.py)核对模型字段、镜头切点以及 1160 分段标记和素材槽。
- 做人物造型、白底三视图、系列人物资产包、面部或场景道具参考前，查阅[参考素材与连续性](references/reference-assets.md)。
- 有台词、需要保持静默、或样片出现额外人声时，用[对白与静默控制](references/h3-formats.md#对白与静默控制)核对原文、发声时点和声景。用[对白时长与切镜](../video-scene-direction/references/music-and-sound.md#对白时长与切镜)检查能否保住自然语速、换气与反应。
- 镜头中有必须可读的招牌、道具屏幕或标识时，用[画内文字与可读性](references/h3-formats.md#画内文字与可读性)处理原字、载体、取景和失败后的参考或后期。
- 场景跨镜漂移或损伤复原时，按[场景连续性与破坏](../video-scene-direction/references/action-direction.md#场景连续性与破坏)把地标、受影响部位和残留写进实际镜头。
- 用户反馈运镜没执行、方向跑偏、切镜错时，或要求全程移动机位时，查阅[运镜控制与分段验收](references/camera-control.md)。先交付可单独测试的镜头，再标明需要在时间线精确完成的切点。
- 连续时空换镜、换角度或分段时，按[易穿帮状态](../video-scene-direction/references/performance-and-blocking.md#逐项核对容易穿帮的状态)核对人物站位、实际朝向、承重、持物、佩戴或挂置位置以及布景状态。关键接点写入前镜落幅和后镜起幅。
- 排查成片或跟踪多轮调整时，直接读[样片反馈](../short-video-supervisor/references/review-loop.md#拿到样片后)记录时间码、证据和下轮变量。
- 动作先后、接触或运镜反复跑偏时，用[逐事件验收](../short-video-supervisor/references/event-validation.md)定义通过证据，再选择改正文、做关键帧预演或测试实际运动参考。
- 用户同时要 H3 和 Seedance 时，用[提示词双版本交付](../short-video-supervisor/references/prompt-pair.md)复用同一分镜，按实际模型分别交付可粘贴正文。验证 H3 的提示词增强时，使用同一 H3 工作流进行对照。
- 用户希望把 Seedance 的实拍、动漫、国风或其他画面表现用在 H3 时，用[样片拆解与风格迁移](../video-scene-direction/references/visual-style-transfer.md)提取视觉特征并安排短镜头对比。
- 做主体外观、运镜、切镜、表演或四步提示词增强时，查阅[镜头设计与提示词增强](references/shot-enhancement.md)。角色或动物缺少辨识度时，按[主体外形写法](references/shot-enhancement.md#让主体外形在画面里可辨认)挑选能在目标景别看见的特征。道具交互和背景响应按[场景交互写法](references/shot-enhancement.md#把场景交互写进镜头正文)明确触发、运动与结果。
- 用户只要修背景、动作或运镜时，优先改镜头正文，保持素材映射、说话人和不相关字段。新增内容同时影响声景或引用关系时，再同步相应字段。区分官方结构、工作流接线要求和经验性改写。
