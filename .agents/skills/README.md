# 视频制作技能入口

在连接此仓库的新 Codex 对话中，可以用下表的 `$` 名称和任务一起发送。需要跨编剧、导演、H3 或审片时，从制作统筹开始。在其他工作区对话中可以使用同名本机技能，或让对话读取此目录的入口和相邻资料。

| 想做什么 | 调用名称 | 入口 |
| --- | --- | --- |
| 从一句创意到模型定稿，或从样片定位问题 | `$short-video-supervisor` | [制作统筹](short-video-supervisor/SKILL.md) |
| 选题、编剧、漫剧与单元剧、平台复盘 | `$short-video-production` | [原创短视频制作](short-video-production/SKILL.md) |
| 运镜切镜、人物调度、真人表演、奇幻场面、声音 | `$video-scene-direction` | [动作与视听调度](video-scene-direction/SKILL.md) |
| H3 1160 提示词、角色三视图和资产包、参考绑定 | `$h3-visual-prompting` | [H3 视觉提示词](h3-visual-prompting/SKILL.md) |
| 白模工程、预演视频与 H3 视频参考接入 | `$directordesk-h3-previs` | [DirectorDesk 白模预演](directordesk-h3-previs/SKILL.md) |

可直接发送 `$short-video-supervisor 把下面的创意做成完整的 MiniMax H3／ComfyUI 1160 提示词。`

## H3 与预演如何交接

默认交付每段可粘贴的完整 1160 块。原定人物、画幅、时长、台词和已有参考素材照用。生成段内只有真正变化到另一镜头才写切点。同一镜头的推进、跟拍、动作先后和触发关系写进正文。

明确要求 DirectorDesk 清单或白模预演交接时，再附逐镜清单。白模尚未生成时在清单写明要控制的内容，有实际素材后再按槽位绑定。需要两项交付时，可在指令末尾加上「并附 DirectorDesk 分镜清单」。

进阶入口依问题选择。[导演技法选择与成稿审查](short-video-supervisor/references/review-loop.md#按场面选择技法) · [样稿拆解](video-scene-direction/references/visual-style-transfer.md#拆解结构化提示词与分镜样稿) · [对白估时](video-scene-direction/references/music-and-sound.md#对白时长与切镜) · [人物走位](video-scene-direction/references/performance-and-blocking.md) · [摄影和剪接](video-scene-direction/references/camera-and-cutting.md) · [角色资产](h3-visual-prompting/references/reference-assets.md#角色资产包) · [逐事件验证](short-video-supervisor/references/event-validation.md)

## 按导演任务查阅

| 任务 | 阅读位置 |
| --- | --- |
| 武打场面从剧本到攻守、强弱、分段 | [高速动作与场面升级](video-scene-direction/references/action-direction.md#高速动作与场面升级) |
| 角色身份、三视图、表情和服装资产 | [完整角色资产总览](h3-visual-prompting/references/reference-assets.md#完整角色资产总览) |
| 设计景别、焦点、镜头路径或特殊机位 | [摄影与切镜调度](video-scene-direction/references/camera-and-cutting.md) · [特殊机位、运动与时间效果](short-video-production/references/camera-and-editing.md#特殊机位运动与时间效果) |
| 人物站位、走位、接镜和首帧 | [人物调度与首帧交接](video-scene-direction/references/performance-and-blocking.md) |
| 真人表演、口型、朦胧写真和自拍 | [真人表演、口型与写真质感](video-scene-direction/references/live-action-performance.md) |
| 拆解参考运镜、判断样片偏差、替换镜头 | [从参考推导路径与修正样片](video-scene-direction/references/camera-and-cutting.md#从参考推导路径与修正样片) |

每个技能从自己的 `SKILL.md` 进入，按任务加载相邻 `references/`。维护时保持此目录与本机五个技能的相对位置一致。公开样稿用于提炼可复用的方法。实际模型字段、素材职责和时长依当前工作流核对。
