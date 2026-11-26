# H3 官方结构与 1160 输入

## 选择提示词模式

| 模式 | 使用条件 | 写法 |
| --- | --- | --- |
| Ref2VA / R2V | 用实际加载的图片、视频或音频传递人物、场景、构图、动作或音色 | 六字段；说明每份参考负责什么，在实际生效的镜头再次引用 |
| T2VA | 纯文字生成音视频，未使用参考图片、视频或音频 | 三字段，模型正文第一行采用 `integrated_multimodal_description: [Shot 1] ...` |
| I2VA | 原生首帧工作流，输入的是实际开场构图 | 官方首帧对齐句、空行、三字段；从图中可见状态接到后续动作 |
| FL2VA | 原生首尾帧工作流，确切掌握开场和最后画面 | 官方首尾帧对齐句、空行、三字段；写初态、中间动作和如何自然到达末态 |
| L2VA | 原生尾帧工作流，用尾图约束结果 | 官方尾帧对齐句、空行、三字段；推导合理初态，逐步收束到尾图 |

原生三字段是 `integrated_multimodal_description`、`overall_soundscape`、`non_diegetic_music`。I2VA、FL2VA、L2VA 的首行从官方原文取对应固定句，替换末镜编号和有效时长（如适用）。有效时长依实际帧数及节点行为确定，首尾图先按目标画幅准备。本机亦可在 `ComfyUI/custom_nodes/ComfyUI-JZL-MiniMax-H3/support_llama/presets/` 查阅对应的 `minimax_i2va.py`、`minimax_fl2va.py`、`minimax_l2va.py`。 [MiniMax 原生基础模式指南](https://huggingface.co/MiniMaxAI/MiniMax-H3/blob/main/docs/VIDEO_PROMPT_WRITING_GUIDE_base_en.md)

原生固定句之后留一个空行，再进入三字段。I2VA 的首帧落在 `[Shot 1]` 的 0.00 秒。FL2VA 先设计首帧到尾帧的连续可行路径，默认单镜；指定多镜时，由实际末镜抵达尾帧。FL2VA 与 L2VA 用实际末镜编号和两位小数的有效时长。两种句子的 `Picture` 和 `Shot` 括号写法不同，按各自官方模板原样取用。

## Ref2VA 六字段分别负责什么

导演六段式用于把实际参考素材和成片意图落进 Ref2VA 正文。动笔时先定观众会看见的过程和结果，再核对参考素材能承担哪些职责。输出严格按下表顺序。纯文生用 T2VA 三字段，同样做导演设计。

| 字段 | 放入的内容 |
| --- | --- |
| `subject_definitions` | 每个需要追踪的内容各占一行，写清来源、可辨认特征和职责。同一角色的脸、衣服或动作来自不同素材时，合进一个 `<Subject N>`，逐份限定其作用 |
| `summary` | 用一个短段概括目标、主要参考关系和镜头最终结果。开头用实际任务类型标记。参考视频只提供走位、机位或节奏时用 `[reference generation]`；实际帧锚点用 `[keyframe completion]`。存在多种任务关系时可用 `+` 组合 |
| `retention_analysis` | 每个已定义标签对应一行，写清在哪一镜或哪一段生效、继承什么、允许改变什么。保留程度只针对已定义的职责。参考只负责身份时，新动作和新背景可以与身份的 `fully_preserved` 共存 |
| `detailed_description` | 全片共用的画风与光线先写在 `[Shot 1]` 前。逐镜写当前构图、主体位置和姿势、场景地标、主动作及结果、跟随或揭示的机位、背景响应和当下的声音。在素材真正提供身份、构图、动作或声音的位置写回对应标签 |
| `overall_soundscape` | 整段可听的环境底声、动作音效和非语言人声。安静环境也可有轻微底噪 |
| `non_diegetic_music` | 观众听到的配乐。现场收音机、唱歌或角色听得到的音乐放到镜头正文。无配乐写 `N/A` |

有参考才绑定对应来源。普通身份参考可写进 `<Subject N>` 的定义；图本身承担首帧、构图或多格分镜时，再单列 `<Picture N>` 并标出用到的镜头或面板。视觉关联可用 `fully_preserved`、`partially_preserved`、`attribute_transfer`、`weak_reference`。音频标记根据需求选 `fully_copy`、`partially_copy`、`reference` 或 `weak_reference`。参考音色时把本镜实际台词写清楚。 [MiniMax 官方全参考指南](https://huggingface.co/MiniMaxAI/MiniMax-H3/blob/main/docs/VIDEO_PROMPT_WRITING_GUIDE_ref_en.md)

视频的运镜、切镜与时间结构可以由独立的 `<Video N>` 描述。只借视频中某个主体的表演或动作时，写在对应主体的定义与动作里。视频和音频各自编号，只有实际启用的音轨才能引用 `<Audio N>`。只借音色就为目标角色写实际台词。复用录音时注明复用范围和生效时机。

Ref2VA 的任务标记依据实际使用关系。`[video editing]` 适用于直接修改原视频，`[video continuation]` 适用于从它继续生成；只取拍法仍属 `[reference generation]`。直接复用已启用的声音信号用 `[audio reuse]`，只借音色、音质、节奏或延续感用 `[audio reference]`。多个目的组合时各写一次。视频文件内含声音但未实际接入音轨时，照实际输入写引用。

检查正文是否可以从画面和声音验收。关键现场变化写明触发者、受影响的物件、可见过程与残留，并在下一镜接续。机位写明从何处出发、为何移动、最终露出什么。环境通篇持续的声音放进声景，接触音、对白及场内音乐在发生的镜头标出。英文官方指南给出的常规长度用于判断描述是否充分，镜头数量、对白和关键事件决定本机提示词实际写多细。 [MiniMax 官方提示词技能](https://github.com/MiniMax-AI/MiniMax-H3/blob/main/skills/h3-prompt-writing/SKILL.md)

按官方格式交付时，描述正文写英文，对白和可见文字保留原语言。Ref2VA 的风格开场放在 `[Shot 1]` 前；基础模式写入 `[Shot 1]`。第一镜从片头开始；后续镜头才加递增的切点，如 `[Shot 2] At 00:04.250, cut to an insert of the loose hinge.`。对白使用稳定的 `(S1)`、`(S2)`，台词写成 `<d>[Chinese] 你准备好了吗?</d>`，说话人和语气写在标签外。画外音说明嘴唇保持闭合；跨镜台词按官方 `<scenetrans>` 处理。 [ComfyUI 提示词与镜头规则](https://docs.comfy.org/tutorials/video/minimax/minimax-h3-prompt-guide)

说话、唱歌和独立旁白的编号按成片中首次发声顺序分配，同一个人跨镜复用，合说可写 `(S1,S2)`。Ref2VA 若在主体定义绑定目标角色音色，沿用成片的说话人编号。只有已复用的音轨里出现歌词、现场角色并未演唱时，用 `<Audio N>` 指明声源。跨镜延续同一句时，两段的连接处标 `<scenetrans>` 并说明声音连续。确因片尾截断的发声用 `<cutoff>`。官方英文画外音用 `says in an off-screen voiceover`，画面有对应角色时紧接对白写嘴唇闭合。实际要出现在画内的文字用英文双引号括起，保留原词和标点。

## 交付前审查官方正文

- **T2VA** 按官方示例排版，三个字段在各自的行内开始填写。第一行把 `[Shot 1]` 紧接在 `integrated_multimodal_description:` 后，先写画风和起始构图，再按动作顺序叙述。1160 的单镜内用动作顺序和明确触发安排节奏。实际切镜另起递增的 `[Shot N]`，用单一的 `At MM:SS.mmm` 写切点。Seedance 的时间段可作为导演稿，转成 H3 正文时依真实镜头数量组织。
- **Ref2VA** 按上表的顺序保留六字段。最后核对素材槽位、编号、引用作用和保留标记，明确素材在哪一镜起效。
- **语言** 官方示例使用英文模型正文，说明可用中文。对白和画内文字保留原文。本机交付按下面的 1160 中文方案。
- **声音** 将事件声和对白写到发生的镜头内，`overall_soundscape` 概括整段环境和拟音，完整静音时使用 `N/A`。无画外配乐时写 `non_diegetic_music: N/A`。

官方英文正文示例见[门缝里的钥匙](examples/door-key-t2va.txt)。[格式检查器](../scripts/check_h3_prompt.py)可从该技能目录运行，输入可以是正文或 1160 完整分段块。例如 `python scripts/check_h3_prompt.py references/examples/biscuit-1160.txt --mode t2va --duration 10`。它检查字段、镜号和切点，以及完整封装使用的分段标记和素材槽 JSON。语言与实际素材关系由交付审查核对。 [MiniMax 官方基础模式指南](https://huggingface.co/MiniMaxAI/MiniMax-H3/blob/main/docs/VIDEO_PROMPT_WRITING_GUIDE_base_en.md)

## 适配本机 1160

此项目默认给可直接粘贴的完整中文分段块，从 `[SHOT_START]` 到 `[SHOT_END]`。标题、元数据值和描述正文写中文，英文键和标记照原样保留。纯文生视频用三字段，三组 `slots` 留空；使用参考素材时用六字段并填实际槽位。见[最后一块饼干 · 1160 中文文生示例](examples/biscuit-1160.txt)。

本地检查时，现用 1160 为 **Ref2VA INT8 主模型 + Ref2V Turbo v0.1 4 步 LoRA**，穿透生成模式，4 步、CFG 1，默认 10 秒。INT8 表示主模型量化，4 步来自所用的加速方案。参考图通过实际素材调度绑定；1160 中的身份参考图仍按 Ref2VA 输入。需要原生首帧或首尾帧的精确接线时，选相应的原生节点和模型路径。 [ComfyUI 原生 R2V 与 Turbo 说明](https://docs.comfy.org/tutorials/video/minimax/minimax-h3-native)

- 原生节点粘贴模型正文。下面的 `[SHOT_START]`、`[SHOT_END]`、`===H3_PROMPT===` 与调度行是 1160 管理器读的外层。用户贴出的片段末尾有结束标记；整理成完整分段时补齐开头，使用真实换行。
- 1160 穿透模式成功提取 `===H3_PROMPT===` 时，用提取出的正文生成。外层的标题、动作描述和画面说明可用来标记分镜，关键动作先后和接触条件应写进模型正文。
- 穿透模式的单段正文可直接贴入中央提示词框。需要明确调度时，用下面的完整块。每个外层块是独立生成的一个视频段，正文内的 `[Shot N]` 是这段视频内部的镜头。当前本机管理器的「每段视频时长」支持 4–15 秒、整秒步进。多段先确认运行时如何分配各段时长，排期与文字标题以真实节点设置为准。对白装不下时先试读再按可用时长安排分段。参考视频的有效输入时长另见 [DirectorDesk 参考时长](../../directordesk-h3-previs/references/h3-handoff.md#有效参考时长)。
- 图片、视频、音频分别放在相应槽位。图片槽位的实际绑定顺序决定 `<Picture 1>` 等编号。每段重算，早一个素材绑定失败会改变后续顺序；通过日志和实际素材核对。无参考时留空槽位并去掉虚构的 `<Picture N>` 等引用。带参考视频或音频的模板要核对该管理器的音轨配对；原生节点的音轨接线按其独立输入。
- 使用本机 1160 的「参考元素切换」时，素材管理的名称写实际人物、道具和场景名称。正文的主体定义保留这些名称及 `<Subject N>`、`<Picture N>`，首次入镜或重入画时沿用完整名称。显示引用按名称转为缩略图，编辑器序列化时保留名称。优先用完整分段和实际槽位固定引用顺序。当前本机穿透模式在未获得参考图时，可按启用素材名称在正文中首次出现的顺序补绑定。采用这条路径时核对名称唯一、文件已启用以及正文的编号与顺序一致。运行时用节点日志核对实际加载的图片数量。
- 下例假设已有角色A的兔子参考图和道具A的胡萝卜参考图。对首次只想测原来纯文字版本的人，可沿用原来的无图输入和中文正文，仅把待测背景动作加到原有镜头中。

### 可粘贴的六字段样例与调度

```text
[SHOT_START]
### Video_001
**标题**: 白兔和胡萝卜
**时长**: 10 秒
**景别**: 中近景
**运镜**: 固定
**角色**: 小白兔
**场景**: 木桌窗边
**道具**: 胡萝卜
**动作描述**: 小白兔拿起胡萝卜，咬一口后抬眼。
**氛围光影**: 午后自然侧光，背景窗帘在可辨认的焦外。

===H3_PROMPT===
subject_definitions:
<Subject 1> is the round white rabbit in <Picture 1>, with fine white fur, pink inner ears and dark eyes.
<Subject 2> is the orange carrot with a short green top in <Picture 2>.

summary:
[reference generation] In one continuous tabletop shot, <Subject 1> picks up <Subject 2>, takes one small bite and looks toward the camera.

retention_analysis:
<Subject 1> (appears in [Shot 1]): fully_preserved - facial proportions, round body, white fur and pink inner ears.
<Subject 2> (appears in [Shot 1]): partially_preserved - orange color, green top and proportions; one bite leaves a small notch.

detailed_description:
Natural afternoon side light reaches a pale wooden table by a slightly open window. A white plate sits in front of the rabbit. A cream curtain is visible in the upper-left background, with enough detail to see its lower hem.
[Shot 1] In a locked medium close-up, <Subject 1> sits behind the table with both ears and front paws inside the frame. It lowers its gaze to <Subject 2> and its nose twitches. Around the third second, it slowly lifts the carrot with both front paws. As it lifts the carrot, a light draft from the open window pushes the curtain hem inward once. The cloth drops back and settles behind the rabbit. Around the fifth second, one small bite leaves a notch in the carrot. The rabbit chews softly, then holds the carrot and lifts its eyes toward the camera during the final three seconds. Its ears tilt slightly while the tabletop and plate stay in place.

overall_soundscape:
Quiet room tone, a light tap from the plate as the carrot lifts, one faint rustle from the curtain and a small crisp crunch followed by soft chewing.

non_diegetic_music:
N/A

===SCENE_INSTRUCTION===
{"slots":["角色:角色A","道具:道具A"]}

===VIDEO_INSTRUCTION===
{"slots":[]}

===AUDIO_INSTRUCTION===
{"slots":[]}
[SHOT_END]
```

将样例的槽位、素材称呼和时长替换为本次实际值。场景图作为真实参考加入时，按槽位顺序同步更新全部图号；纯文字补充的小物可直接写在镜头正文。
