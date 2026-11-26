---
name: h3-visual-prompting
description: 为 ComfyUI MiniMax H3 将一句话创意自动增强为视频提示词，并排查运镜、背景运动与场景道具一致性。适用于 1160 四步 Turbo、Ref2VA、原生首尾帧及白底人物三视图、半身和面部细节参考。
---

# MiniMax H3 视觉提示词

先确定用户在做素材、分镜还是修某个镜头。核对实际模型、LoRA、模式、已绑定参考素材、每段时长和画幅。已明确的角色、场景、对白、画风及镜头意图作为改写约束。用户只是准备制作基础时，交付模板和检查项。

根据用户创意编写 MiniMax H3／ComfyUI 1160 时，默认按 [DirectorDesk 交接格式](../directordesk-h3-previs/references/h3-handoff.md#给写剧本的对话)交付两部分，先给完整 1160 提示词，再给逐镜 DirectorDesk 分镜清单。两部分共用一套人物、画幅、时长、对白、场景地标与镜头顺序。白模尚未生成时，在分镜清单里说明它要控制的站位、走位、动作、机位或切镜。提示词按实际已有素材选择模式、填对应调度槽和引用。用户本轮指定只要某一部分时，按本轮要求交付。

- 使用 [H3 官方结构与 1160 输入](references/h3-formats.md) 选模式并审查交付。此项目默认交付完整的 1160 中文分段块，字段名和调度键保留原样，保留原语言对白和画内文字。用户要官方正文或切换到原生节点时，按官方模板给英文正文。
- 只有一句话、主题或开放想法时，按[一句话创意的自动增强](../video-scene-direction/references/prompt-enhancement.md#一句话创意的自动增强)设计画面与关键动作，再转换为 H3 正文。留给模型发挥的细节可省略。用户要求原样、只排版或局部改动时，沿用指定范围。
- 交付 T2VA 或 Ref2VA 文件时，可用[格式检查器](scripts/check_h3_prompt.py)核对模型字段、镜头切点以及 1160 分段标记和素材槽。
- 做人物造型、白底三视图、面部或场景道具参考前，查阅[参考素材与连续性](references/reference-assets.md)。
- 场景跨镜漂移，或需要断裂、坍塌、烧蚀等持续变化时，先按[场景连续性与破坏](../video-scene-direction/references/action-direction.md#场景连续性与破坏)定地标、受击部位和残留状态，再把它们写进模型正文的首镜、接镜和尾帧。纯文字用 T2VA 三字段。将场景图绑定到 Ref2VA 时，用六字段写明参考职责和素材槽位。
- 用户反馈运镜没执行、方向跑偏、切镜错时，或要求全程移动机位时，查阅[运镜控制与分段验收](references/camera-control.md)。先交付可单独测试的镜头，再标明需要在时间线精确完成的切点。
- 需要跨导演和模型排查成片、用户反馈缺少具体依据，或要跟踪多轮调整时，用[短视频制作统筹](../short-video-supervisor/SKILL.md)记录版本、时间码证据和下一轮单变量试验。
- 动作先后、接触或运镜反复跑偏时，用[逐事件验收](../short-video-supervisor/references/event-validation.md)定义通过证据，再选择改正文、做关键帧预演或测试实际运动参考。
- 已有分镜需要重做动作编排、机位或声音，或需要精确接镜时，用[视频动作与视听调度](../video-scene-direction/SKILL.md)核对时间表与接点，再转换为当前 H3 正文。
- 用户同时要 H3 和 Seedance 时，用[提示词双版本交付](../short-video-supervisor/references/prompt-pair.md)复用同一分镜，按实际模型分别交付可粘贴正文。验证 H3 的提示词增强时，使用同一 H3 工作流进行对照。
- 用户希望把 Seedance 的实拍、动漫、国风或其他画面表现用在 H3 时，用[样片拆解与风格迁移](../video-scene-direction/references/visual-style-transfer.md)提取视觉特征并安排短镜头对比。
- 做主体外观、运镜、切镜、表演或四步提示词增强时，查阅[镜头设计与提示词增强](references/shot-enhancement.md)。角色或动物缺少辨识度时，按[主体外形写法](references/shot-enhancement.md#让主体外形在画面里可辨认)挑选能在目标景别看见的特征。道具交互和背景响应按[场景交互写法](references/shot-enhancement.md#把场景交互写进镜头正文)明确触发、运动与结果。
- 用户要求截图里的电影化详写、连续跟拍或多场景调度时，用[电影镜头设计与提示词交付](../video-scene-direction/references/cinematic-shot-plan.md)先对齐首帧、空间和动作接点，再把因果、机位轨迹和声音写进现有 H3 字段及分镜清单。
- 多主体、多场景或多层动态同时影响结果时，按[场面复杂度增加细节](../video-scene-direction/references/prompt-enhancement.md#根据场面复杂度增加细节)写足依赖关系、逐镜动作、环境反馈和状态衔接。一句话输入也可自动展开成复杂分镜。
- 用户只要修背景、动作或运镜时，优先改镜头正文，保持素材映射、说话人和不相关字段。新增内容同时影响声景或引用关系时，再同步相应字段。区分官方结构、工作流接线要求和经验性改写。
