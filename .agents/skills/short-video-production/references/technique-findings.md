# 视频技法研究记录

按问题和适用的工作流查找。记录使用「公开证据」「待本机复验」「已采用」「已撤回」。公开证据可来自官方规范、作者公开实验或成片观察，具体注明来源和看过的范围。方法在本机得到一次可比结果时，把依赖条件和结果补入原条目。转成默认写法时按[采纳条件](research-and-update.md#把发现更新进技能)补复验和实际更新位置。

新增记录写下日期、问题、适用入口和设置、来源及定位、看见或听见了什么、本机试法和通过条件、当前状态。能对照时记样片标识、时间码、原本通过的项目及新结果。看不到关键画面或听不到音轨的项目记「无法判断」。模型或本机工作流更新时，优先复查依赖该版本的结论。

## 甩镜停在原对象或运动太小

- **待本机复验，2026-11-28。** 适用本机 H3 Ref2VA 的视觉揭晓镜头。国外作者在双主体 Ref2VA 案例中报告，给甩镜指定清晰的第二主体落点后，测到的画面位移明显增加。本轮读到了作者公开的写法、测量与局限，样片与本机结果待核对。其测试设置及位移数值仅用于定位原实验。[作者的甩镜实验与提示词](https://github.com/loopforge0/minimaxh3-shots-skills/blob/main/.claude/skills/h3-camera-shots/shots/whip-pan.md)
- **本机试法。** A、B 保持相同起幅、第二主体、两张身份图、运镜方向和其他设置，B 只增加「落在第二主体及具体动作，并保持足够辨认的时长」。判断摇摄是否到达第二主体、落幅能否读出动作和是否回摆。比较近景边缘变化，避免把人物横向移动算成摄影机运动。试法归[运镜控制](../../h3-visual-prompting/references/camera-control.md)。

## 环绕只转了小半圈，或演员原地转身

- **待本机复验，2026-11-28。** YouTube 原作者在简介里报告两个种子只产生了部分弧线，并在章节标记 1:21 处指向失败样例。本轮仅核实了简介和章节。另有社区公开实验报告，额外场景底图可能减小位移，背景参考是否是原因需要独立测试。[YouTube 作者原帖](https://www.youtube.com/watch?v=iVJ484g9yrw) · [作者的参考条件实验说明](https://github.com/loopforge0/minimaxh3-shots-skills/blob/main/.claude/skills/h3-camera-shots/SKILL.md)
- **本机试法。** 首轮固定演员朝向和近远地标，只改环绕句，把方向与终点改成能看到的侧面和背景建筑。若仍不足，下一轮固定已选的正文，测试可选的场景参考图对幅度、布景稳定和主体身份的影响。用同一组配对种子检查起幅、中途和落幅。用户明确要求保留的素材继续按实际职责使用。

## 从参考作品提炼写法时，提示词长度与输入变化混在一起

- **公开证据，2026-11-28。** B 站创作者文章公开了多种简版、长版提示词的结果标签，其中一些同时更换了模型、首尾帧或提示词内容。本轮阅读了原文、配图说明与作者复盘。对照可用于找叙事及动作问题，单凭这些组别无法确认 H3 的最适合长度。[B 站作者的跨模型创作记录](https://www.bilibili.com/opus/1133522494599200769)
- **本机试法。** 先固定同一批可验收事件、素材和入口，A 用简洁时序，B 只把动作或环境因果逐拍写开。检查哪条必要事件在何时清楚出现，原有镜头变化、角色辨识和声画是否保住。组别共用同一配对种子，合并更换提示词和素材的成片另列新版基线。方法见[一句话增强对照](../../short-video-supervisor/references/review-loop.md#比较一句话增强的收益)。

## 微表情的锚定词和部位顺序

- **待本机复验，2026-11-28。** 用户提供了 B 站视频 BV1GbyxzsENz 的直链和笔记。其技巧是把 `micro expressions` 接在英文情绪词后，再按眼神、口唇、低头、擦泪、抬眼和发声的实际顺序描述。直链未能加载原片，本条依据用户笔记整理。另一份创作者公开教程也建议从触发词和首个可见部位入手安排听者的反应。确切短语对本机 H3 的增益仍待测。[用户提供的 B 站教程](https://www.bilibili.com/video/BV1GbyxzsENz/) · [创作者的文戏示例](https://github.com/AICoderTudou/tudou-single-h3)
- **本机试法。** 选一条脸部和视线可辨认的原创近景，固定工作流、参考素材、景别、时长、对白和配对种子。第一轮保留同样的动作正文与情绪词，B 只在情绪词后加 `micro expressions`，比较表情幅度和可读性。第二轮固定选定的措辞，只比较并列描述与明确触发顺序，核对是否先发生视线或唇部变化、需要时手是否先落下、台词是否随后起音。两轮各自检查身份、台词原文和口型是否保住。实际写法见[H3 微表情](../../video-scene-direction/references/live-action-performance.md#h3-微表情的英文写法)。

## 走位图到底能控制什么

- **待本机复验，2026-11-28。** 用户提供的《走位》包中，Higgsfield 3.40.0 的 `staging-reference.md` 记录了机位视角站位图的测试。作者在镜像布置对照中报告 12 个结果里 6 个跟随图示朝向。测试的模型、入口和日期未完整记载。外观污染与位置遵循使用不同样本计数。记录支持分别验收两项，不能据此推定 H3 的站位准确率。
- **已采用的制作方法。** 用俯视图排路线、机位视角稿核对占位，需准确起幅时再制作干净的实际首帧。是否接入额外示意图由当前入口和本机样片决定。见[从平面走位到可生成首帧](../../video-scene-direction/references/performance-and-blocking.md#从平面走位到可生成首帧)。
- **本机试法。** 在支持多图参考的同一入口中，用同一组可识别角色、布景和配对种子，对照有无机位示意图。另用左右相反的布置抵消常见的构图倾向。核对人物实际落脚点、位置保持到触发时的表现，以及图示颜色或线条是否进入服装和场景。记录实际图片编号与参考职责。

## 分段生成后的剪接与首帧延续

- **已核实格式与接入方式，2026-11-28。** MiniMax 官方区分原生首帧、首尾帧和普通参考。以本机实际入口决定图像是否锚在指定帧。原生引导有画面帧索引，是否可用按 ComfyUI 版本与接线查证。 [MiniMax 官方提示词 Skill](https://github.com/MiniMax-AI/MiniMax-H3/blob/main/skills/h3-prompt-writing/SKILL.md) · [ComfyUI 原生工作流](https://docs.comfy.org/tutorials/video/minimax/minimax-h3-native)
- **已采用制作方法，本机出片待复验。** ComfyTV 的作者把段间连续性审查和单变量修复纳入导演流程。Comfy-H3-Director 给出轴线、持物状态与动作阶段共同对齐的写法，其指定的固定秒数、动作百分比与多镜生成效果依案例判断。comfy-h3-mcp 的作者报告了独立切分与连续底声的本机实践，适用其测试环境。吸收可复用的流程，按本机工作流容量和样片验证决定每次生成镜数。 [ComfyTV 制作审查](https://github.com/jtydhr88/ComfyTV/blob/main/skills/h3-cinematic-director/SKILL.md#8-audit-before-delivery) · [Comfy-H3-Director 连续性](https://github.com/MIKA6941/Comfy-H3-Director/blob/main/.agents/skills/ai-video-continuity-director/SKILL.md) · [comfy-h3-mcp 剪接实践](https://github.com/jonpojonpo/comfy-h3-mcp/blob/main/skills/minimax-h3-prompting/SKILL.md#6-assembling-clips-into-a-cut)
- **本机试法。** 对相邻段保留同一故事事件和资产，分别核对硬切与实际首帧续接这两种交付路径。模式与输入不同的结果各按自身目的验收。对硬切按关键帧检查方向、持物手、接触和现场变化。对同机位续接看实际接点两侧的构图、光比、地标、运动方向和是否有重复帧。两组都试听底声和一次性声响是否接得上。方法归[段间剪接](../../video-scene-direction/references/camera-and-cutting.md#让独立生成的片段能接起来)。

## 镜头可生成性与重剪后的接点复查

- **已采用审查方法，2026-11-28。** Director Agent 分别评估镜头叙事价值和单次生成负荷。Diffusers MiniMax H3 项目报告了 15 次提示词生成对照，时间分配是此样本中可检测的主要错误，其中一部分来自原台词本来就超出给定镜头时长。实验评估的是提示词助手，视频质量需另验。把并发动作和台词可用窗口写进[生成前审查](../../short-video-supervisor/references/event-validation.md#生成前检查提示词)。 [Director Agent 可生成性](https://github.com/SHIFT-R/director-agent/blob/main/references/generation-feasibility.md) · [Diffusers MiniMax H3 技术报告](https://github.com/animede/Diffusers_minimax-h3/blob/main/docs/internal/TECHNICAL_REPORT.en.md#10-llm-prompt-enhancement-and-its-quality-assurance)
- **已采用接点版本核对，2026-11-28。** InkToFilm 的公开成片案例展示了从上一个已选片段截帧续拍，以及把审查结论指到具体画面。Film Production Skills 将选用片段与实际素材和源区间对应。把可复用的做法缩成[换片后的接点复查](../../short-video-supervisor/references/review-loop.md#拿到样片后)。公开样片采用 H3 Max，作为审片与素材追踪方法的参考。 [InkToFilm 提示词](https://github.com/yingwang/inktofilm/blob/main/examples/great-havoc-in-heaven/prompts.md) · [InkToFilm 审片报告](https://github.com/yingwang/inktofilm/blob/main/examples/great-havoc-in-heaven/report/index.html) · [Film Production Skills](https://github.com/zhangzhangco/film-production-skills/blob/main/README.md#7-review-and-assemble)

## 对照提示词增强规则与保留可复验版本

- **已采用对照与记录方法，2026-11-28。** Prompt Optimizer 仓库的对照 Skill 用已配置的模型测试文本候选，固定共用输入并保存原始结果和个别失败。产品的收藏还能保留变量、示例与来源。迁移到[增强对照](../../short-video-supervisor/references/review-loop.md#比较一句话增强的收益)时，分别检查写词结果和实际 H3 样片，保留能复跑的正文、素材和版本。仓库页面另列视频工作区，具体视频入口及模型接入能力按对应工作流验证。 [对照 Skill](https://github.com/linshenkx/prompt-optimizer/blob/develop/.agents/skills/prompt-optimizer-compare/SKILL.md) · [新版 MCP 操作与请求字段](https://github.com/linshenkx/prompt-optimizer/blob/develop/docs/user/desktop-mcp.md#优化测试评估与比较) · [变量与示例保存](https://github.com/linshenkx/prompt-optimizer/blob/develop/releases/v2.9.6.en.md)
