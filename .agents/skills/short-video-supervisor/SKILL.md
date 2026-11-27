---
name: short-video-supervisor
description: 视频提示词制作调度台。把创意、剧本或参考素材转成 MiniMax H3／ComfyUI 1160 提示词，按场面调度编剧、摄影、剪辑、动作、表演、灯光、特效、声音和资产并终审。也用于 Seedance 双版本、样片复盘和检索国内外案例更新视频技能。
---

# 视频提示词制作调度台

调度台负责分派、合并、终审与复盘。各岗位沿用同一份镜头安排：编剧确定意图和结果，导演编排视听过程，H3 将它转入实际字段与素材槽。局部修改只动目标和受它影响的接点。

1. **选岗位并设计。** 新写、续写与改镜按[两轮调度与终审](references/review-loop.md#两轮调度与终审)分派。用[岗位如何做判断](../short-video-production/references/roles-and-handoffs.md#岗位如何做判断)决定各自要解决的画面或声音问题。遇到新技法、未知版本或反复偏差时，按[主动学习](../short-video-production/references/research-and-update.md#创作过程中如何主动学习)先查同类研究记录，再查证能改变本轮设计的问题。
2. **按四阶段成稿并终审。** 新写或重写完整 H3 段时，按[H3 四阶段成稿](../video-scene-direction/references/prompt-enhancement.md#h3-四阶段成稿)实际写出创意稿、中文逐秒导演稿、中文模型执行稿和英文成稿，按[成稿倒查](references/review-loop.md#从成稿倒查镜头)核对每次转写。按[本机 1160 规则](../h3-visual-prompting/references/h3-formats.md#适配本机-1160)交付。需要 Seedance 或双版本时按[双版本交付](references/prompt-pair.md)，需要预演时按[DirectorDesk 交接](../directordesk-h3-previs/references/h3-handoff.md#给写剧本的对话)。
3. **根据样片复盘。** 有对应成片时，从[样片反馈](references/review-loop.md#拿到样片后)进入。对顺序、接触或运镜等难镜头，提前用[逐事件验收](references/event-validation.md)确定实拍证据。遇到已有候选写法，按该条验收条件比较，记录版本、时间码和复验结果，供下次调用。
4. **研究与维护。** 用户要求自主学习、研究资料或补全技能时，直接按[完成一轮学习](../short-video-production/references/research-and-update.md#完成一轮学习)执行，从最影响出片的问题取样。把候选、复验结果、采用或撤回理由落到[研究记录](../short-video-production/references/technique-findings.md)，达到采纳条件就更新负责该技法的技能。研究任务按证据和改动交付。
