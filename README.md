# 短视频制作技能

这套 Codex 技能用于原创短片、单元剧和连载的剧本、角色与场景资产、分镜、MiniMax H3／ComfyUI 1160 提示词以及样片复盘。

在此仓库的 Codex 对话中发送 `$short-video-supervisor` 加上具体任务，就能从调度台开始。只做某项工作时，可以直接用对应技能。

## 在聊天模式或其他模型中调用

把这句和你的创意一起发给能读取 GitHub 的模型。

> 请先完整读取 54854434/short-video-skills 的 README「在聊天模式或其他模型中调用」及其中的必读文件，严格按仓库规则为下面的创意生成 MiniMax H3／ComfyUI 1160 提示词，并列出实际资产图的文件名与绑定关系。

按以下顺序读正文和链接。使用指定分支或 PR 时，所有文件从同一版本读取。链接打不开时说明缺失的文件，再用已读规则继续可完成的部分。

1. [视频调度入口](.agents/skills/short-video-supervisor/SKILL.md)用于定镜头、选相关专业参考和做终审。
2. [H3 格式与 1160](.agents/skills/h3-visual-prompting/references/h3-formats.md)用于选择生成模式、保留对应字段和装配 1160。使用实际参考的 Ref2VA 按六字段顺序输出，纯文生按 T2VA 三字段输出。每个生成段有 `[SHOT_START]`、`===H3_PROMPT===`、场景、视频、音频调度区、`[SHOT_END]`。镜头正文用英文，原对白、画内文字和匹配素材名保持原样。只有真实切镜写切点。
3. [资产图命名与绑定](.agents/skills/h3-visual-prompting/references/reference-assets.md#资产图命名与提示词绑定)用于逐张列出建议保存的完整文件名，并将已绑定的素材名称写入正文。核对素材名、槽位、实际图号和职责。只有实际启用的参考进入正文与调度。
   - 从剧本制作资产时，先按[场次与资产交接](.agents/skills/short-video-production/references/directing.md#先准备资产再完成分镜导演稿)锁定同一角色和地点的正式名称。需要双人画面时，按[双人和多人参考](.agents/skills/h3-visual-prompting/references/reference-assets.md#双人和多人参考)先核定单人身份图与场景主图，再派生同框构图。
4. [环境状态接镜](.agents/skills/h3-visual-prompting/references/shot-enhancement.md#把环境状态接到下一镜)和[环境连续性核对](.agents/skills/short-video-supervisor/references/event-validation.md#环境连续性核对)用于审查每个切点。上一镜写出接触与留下的结果，下一镜先接该状态再行动。导演清单留在审稿中，成稿用对应 Shot 的自然叙述。

明确要求成人向性内容或指定成人亲密场面专项时，额外读[成人场面调度](.agents/skills/adult-scene-direction/SKILL.md#适用范围与调用)。从同一版本按需打开相关参考，再交回 H3 格式与分段规则。混合剧本只在对应场次调用。

可参照[完整的两镜 Ref2VA 示例](.agents/skills/h3-visual-prompting/references/examples/courtyard-ring-1160.txt)。默认交付可复制的 1160 成稿和确有参考时的素材对应信息。DirectorDesk 清单按需提供。

| 技能 | 用途 |
| --- | --- |
| [short-video-supervisor](.agents/skills/short-video-supervisor/SKILL.md) | 从创意到提示词，调度编剧、摄影、表演和声音，按成片证据终审 |
| [short-video-production](.agents/skills/short-video-production/SKILL.md) | 选题、故事大纲、剧本压力测试、分场和运营 |
| [video-scene-direction](.agents/skills/video-scene-direction/SKILL.md) | 人物站位、动作、运镜、剪辑、表演与声画 |
| [h3-visual-prompting](.agents/skills/h3-visual-prompting/SKILL.md) | H3 格式、1160 素材绑定、参考图设计和提示词排查 |
| [adult-scene-direction](.agents/skills/adult-scene-direction/SKILL.md) | 按需处理成年角色的成人亲密场面及 H3 镜头、参考和声音交接 |
| [directordesk-h3-previs](.agents/skills/directordesk-h3-previs/SKILL.md) | DirectorDesk 白模预演与视频参考交接 |

具体调用示例和协作关系见[技能入口与使用说明](.agents/skills/README.md)。
