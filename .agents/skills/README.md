# 视频制作技能入口

在连接此仓库的新 Codex 对话中，可以用下表的 `$` 名称和任务一起发送。需要跨编剧、导演、H3 或审片时，从制作统筹开始。在其他工作区对话中可以使用同名本机技能，或让对话读取此目录的入口和相邻资料。

| 想做什么 | 调用名称 | 入口 |
| --- | --- | --- |
| 从一句创意到模型定稿、跨岗位终审，或从样片定位问题 | `$short-video-supervisor` | [视频提示词制作调度台](short-video-supervisor/SKILL.md) |
| 选题、编剧、漫剧与单元剧、平台复盘 | `$short-video-production` | [原创短视频制作](short-video-production/SKILL.md) |
| 运镜切镜、人物调度、真人表演、奇幻场面、声音 | `$video-scene-direction` | [动作与视听调度](video-scene-direction/SKILL.md) |
| H3 1160 提示词、角色三视图和资产包、参考绑定 | `$h3-visual-prompting` | [H3 视觉提示词](h3-visual-prompting/SKILL.md) |
| 白模工程、预演视频与 H3 视频参考接入 | `$directordesk-h3-previs` | [DirectorDesk 白模预演](directordesk-h3-previs/SKILL.md) |

可直接发送 `$short-video-supervisor 把下面的创意做成完整的 MiniMax H3／ComfyUI 1160 提示词。`

制作调度台会先看题材、要求和素材，再从摄影、剪辑、动作、表演、美术、特效、声音与 H3 格式逐项检查需要用到的技法。终审只依据模型实际收到的文字和引用。若需要看到采用情况，可加「附终审摘要」，查看哪一镜采用了什么、修了什么。见[两轮调度与终审](short-video-supervisor/references/review-loop.md#两轮调度与终审)。

## 五个技能如何协作

同一条片共用一份镜头安排，按段与镜号记录必保留内容、可见变化、交付条件和待核对处。各入口沿用已有决定，按本次任务补需要的内容。

| 环节 | 交接中要带什么 | 下一环节 |
| --- | --- | --- |
| [短视频制作](short-video-production/SKILL.md) | 原意、世界观、人物目的、锁定对白、开场和结果 | [导演增强](video-scene-direction/references/prompt-enhancement.md#一句话创意的自动增强)选最贴合的具体拍法 |
| [场面导演](video-scene-direction/SKILL.md) | 地标和站位、表演触发、镜头路径、背景变化、声场与切点 | [H3](h3-visual-prompting/SKILL.md)转成实际输入，需白模时同稿交预演 |
| [DirectorDesk](directordesk-h3-previs/SKILL.md) | 按请求制作的机位、走位、动作时序或实播参考；标出有效段和承担的控制 | [H3 参考接入](directordesk-h3-previs/references/h3-handoff.md)，用真实素材和支持的入口绑定 |
| [H3 视觉提示词](h3-visual-prompting/SKILL.md) | 对应模式的正文、实际调度槽、原文与可检验的镜头证据 | [调度台终审](short-video-supervisor/references/review-loop.md#两轮调度与终审)检查正片需要能看见或听见什么 |
| [制作调度台](short-video-supervisor/SKILL.md) | 统一设计与终审，发现偏差时给对应专长、镜号、修订和复验条件 | 按用户所需交付 1160、双版本或预演，样片比对回到对应环节 |

参考即梦效果时，用[同条件样片方法](short-video-supervisor/references/review-loop.md#比较一句话增强的收益)比较具体看点、节奏、运镜、表演与声画。新构思按场面补叙事和视听细节，已有样片按出现时间做局部校正。

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
| 舞蹈、齐舞、带音乐的动作和滑冰 | [舞蹈与冰上动作设计](video-scene-direction/references/dance-and-skating.md) |
| 半写实 3DCG、三渲二、真人电影、光色与衣发 | [画面美术与角色渲染](video-scene-direction/references/look-design.md) |
| 气流、水浪、光效、材质破坏与连续余波 | [特效、材质与环境响应](video-scene-direction/references/vfx-design.md) |
| 官方三字段、参考六字段、对白与素材标签 | [H3 官方结构和本机 1160](h3-visual-prompting/references/h3-formats.md) |
| 多余人声、说完后的口型、招牌与屏幕原字 | [对白与静默控制](h3-visual-prompting/references/h3-formats.md#对白与静默控制) · [画内文字与可读性](h3-visual-prompting/references/h3-formats.md#画内文字与可读性) |
| 拆解参考运镜、判断样片偏差、替换镜头 | [从参考推导路径与修正样片](video-scene-direction/references/camera-and-cutting.md#从参考推导路径与修正样片) |

每个技能从自己的 `SKILL.md` 进入，按任务加载相邻 `references/`。维护时保持此目录与本机五个技能的相对位置一致。公开样稿用于提炼可复用的方法。实际模型字段、素材职责和时长依当前工作流核对。
