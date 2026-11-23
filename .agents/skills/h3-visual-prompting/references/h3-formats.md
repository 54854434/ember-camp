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

## Ref2VA 六字段分别负责什么

| 字段 | 放入的内容 |
| --- | --- |
| `subject_definitions` | 定义同一人物、场景或道具的身份及参考来源。例如一张图提供衣服和体态，另一张提供同一张脸。把它们合在一个 `<Subject N>` |
| `summary` | 一小段确认任务类型和整段结果。参考重建常用 `[reference generation]`，具体画面锚点用 `[keyframe completion]`，可按实际关系组合 |
| `retention_analysis` | 逐项声明参考出现位置、应保留的特征和允许改变的部分。参考兔子长相可完整保留；若胡萝卜的几何形状将被咬出缺口，可标 `partially_preserved` 并保留颜色、比例及萝卜叶 |
| `detailed_description` | 按播放顺序写构图、人物、空间锚点、主动作、背景动作、镜头、同步声音与对白。背景物体何时开始动、如何动、最后怎样写在这里 |
| `overall_soundscape` | 整段可听的环境底声、动作音效和非语言人声。安静环境也可有轻微底噪 |
| `non_diegetic_music` | 观众听到的配乐。现场收音机、唱歌或角色听得到的音乐放到镜头正文。无配乐写 `N/A` |

有参考才绑定对应来源。普通身份参考可写进 `<Subject N>` 的定义；图本身承担首帧、构图或多格分镜时，再单列 `<Picture N>` 并标出用到的镜头或面板。视觉关联可用 `fully_preserved`、`partially_preserved`、`attribute_transfer`、`weak_reference`。音频标记根据需求选 `fully_copy`、`partially_copy`、`reference` 或 `weak_reference`。参考音色时把本镜实际台词写清楚。 [MiniMax 官方全参考指南](https://huggingface.co/MiniMaxAI/MiniMax-H3/blob/main/docs/VIDEO_PROMPT_WRITING_GUIDE_ref_en.md)

按官方格式交付时，描述正文写英文，对白和可见文字保留原语言。Ref2VA 的风格开场放在 `[Shot 1]` 前；基础模式写入 `[Shot 1]`。第一镜从片头开始；后续镜头才加递增的切点，如 `[Shot 2] At 00:04.250, cut to an insert of the loose hinge.`。对白使用稳定的 `(S1)`、`(S2)`，台词写成 `<d>[Chinese] 你准备好了吗?</d>`，说话人和语气写在标签外。画外音说明嘴唇保持闭合；跨镜台词按官方 `<scenetrans>` 处理。 [ComfyUI 提示词与镜头规则](https://docs.comfy.org/tutorials/video/minimax/minimax-h3-prompt-guide)

## 交付前审查官方正文

- **T2VA** 按官方示例排版，三个字段在各自的行内开始填写。第一行把 `[Shot 1]` 紧接在 `integrated_multimodal_description:` 后，先写画风和起始构图，再按动作顺序叙述。需要给单镜头内的动作定时间时，用叙述中的近似秒数。实际切镜另起递增的 `[Shot N]`，用单一的 `At MM:SS.mmm` 写切点。Seedance 的时间段可作为导演稿，转成 H3 正文时依真实镜头数量组织。
- **Ref2VA** 按上表的顺序保留六字段。最后核对素材槽位、编号、引用作用和保留标记，明确素材在哪一镜起效。
- **语言** 默认英文模型正文，交付时的说明可用中文。对白和画内文字保留原文。用户明确要求中文模型正文时，可交付同字段的中文适配版。
- **声音** 将事件声和对白写到发生的镜头内，`overall_soundscape` 概括整段环境和拟音，完整静音时使用 `N/A`。无画外配乐时写 `non_diegetic_music: N/A`。

可直接粘贴的 10 秒悬疑示例见[门缝里的钥匙](examples/door-key-t2va.txt)。[格式检查器](../scripts/check_h3_prompt.py)可从该技能目录运行。输入是 T2VA 或 Ref2VA 的模型正文，例如 `python scripts/check_h3_prompt.py references/examples/door-key-t2va.txt --mode t2va --duration 10`。它检查字段、镜头编号和切点，语言与实际素材关系由交付审查核对。 [MiniMax 官方基础模式指南](https://huggingface.co/MiniMaxAI/MiniMax-H3/blob/main/docs/VIDEO_PROMPT_WRITING_GUIDE_base_en.md)

## 适配本机 1160

本地检查时，现用 1160 为 **Ref2VA INT8 主模型 + Ref2V Turbo v0.1 4 步 LoRA**，穿透生成模式，4 步、CFG 1，默认 10 秒。INT8 表示主模型量化，4 步来自所用的加速方案。参考图通过实际素材调度绑定；1160 中的身份参考图仍按 Ref2VA 输入。需要原生首帧或首尾帧的精确接线时，选相应的原生节点和模型路径。 [ComfyUI 原生 R2V 与 Turbo 说明](https://docs.comfy.org/tutorials/video/minimax/minimax-h3-native)

- 原生节点粘贴模型正文。下面的 `[SHOT_START]`、`[SHOT_END]`、`===H3_PROMPT===` 与调度行是 1160 管理器读的外层。用户贴出的片段末尾有结束标记；整理成完整分段时补齐开头，使用真实换行。
- 穿透模式的单段正文可直接贴入中央提示词框。需要明确调度时，用下面的完整块；多段另核对管理器里实际分段数和时长。每个外层块是独立生成的一个视频段，正文内的 `[Shot N]` 是这段视频内部的镜头。
- 图片、视频、音频分别放在相应槽位。图片槽位的实际绑定顺序决定 `<Picture 1>` 等编号。每段重算，早一个素材绑定失败会改变后续顺序；通过日志和实际素材核对。无参考时留空槽位并去掉虚构的 `<Picture N>` 等引用。带参考视频或音频的模板要核对该管理器的音轨配对；原生节点的音轨接线按其独立输入。
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
