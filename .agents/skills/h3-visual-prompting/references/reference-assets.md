# 参考素材与连续性

先锁定项目风格和一份主参考。批准一张角色正面图后，再用同一角色参考派生侧面、背面和面部图。派生图之间核对发际线、五官比例、服装剪裁、左右不对称特征和体态。三视图是制作素材，交给当前图像生成或编辑工作流；H3 在视频段里读对应的参考图。

## 角色资产包

- 给人物一条可重复使用的固定描述，记录脸型、眉眼和五官比例、发际线及发型结构、肤色、体型比例与辨识标记。区分素材里可见的特征、用户明确的设定与新增设计。衣服、配饰及道具按服装版本记录，表情、走位和灯光按镜头变动。痣、疤痕、耳饰等以角色自身左右为准。
- 给每份素材一个主职责。单独标出身份、服装、发型、表情、构图、画风或版式参考。发现参考有冲突时先据用户最新要求确定主依据。背面不可见时标明补画假设，核对分缝、束发、领口和背部连接能与正侧面对应。
- 当前项目的默认角色参考为每人一张白底四格图，左侧三格是全身正面、严格侧面和背面，右侧是以脸部细节为主的放大人像。用户只要某个视图时按指定交付。对白多时可加同角度同光线的表情图。重复使用的服饰与手持道具可补结构、佩戴位置、手与道具接触图。用得上的动作、色彩、材质和剧情氛围可另出单图。
- 总览用疏朗网格，优先让全身结构与核心肖像清楚。文字密时可把无字资产版与后期排字分开。每张独立生成图的提示词都包含必要的固定身份、服装版本、角度和构图。制作总览和逐张生成图是两种可选交付，按本轮实际用途给提示词，用户要求生成时再创作图片。

### 完整角色资产总览

用户需要完整总览或后续跨集复用时，从下列模块挑选本项目实际需要的内容，并保持同一套人物固定设定和服装版本。参考图仅负责用户指定的身份、造型、画风或排版。身份资料、背景和故事信息从已提供资料或获准创作范围确定。

| 模块 | 需要交代和检查的内容 |
| --- | --- |
| 人物档案 | 名称、身份、年龄段、体型或身高、性格、角色定位及现阶段必要背景 |
| 全身视图 | 完整正面、严格侧面、背面。服装结构或常拍角度需要时另外加四分之三全身视图 |
| 核心肖像 | 头肩或胸像的五官、肤质、发际线和标记清晰，做身份图时优先扩大脸部 |
| 表情组 | 同角度、尺度和光位下做中性、微笑、生气、难过、惊讶、坚定等所需表情，面部基本结构始终一致 |
| 发型与五官细节 | 正侧面与后脑的分缝、发长、卷曲方向、束发结构和发饰位置。局部五官辨识点与全脸相符 |
| 服装结构 | 外套、内搭、鞋、剪裁、领口、袖口、腰部、扣件、接缝和背面连接能跨视图核对 |
| 配饰和随身道具 | 形状、比例、材质、佩戴位置、人物自身左右及携带方式 |
| 手部和持物 | 选符合角色身份的动作，标明接触点、握持关系、饰品和持物的手 |
| 全身动作 | 用该人物的生活、工作或剧情动作说明站姿、走路、转身及承重方式。换装单列版本 |
| 色彩与材质 | 颜色对应具体部位，示出关键材质的纹理和光泽。目测色值标为近似 |
| 故事氛围图 | 让人物在职业、住处或关键情绪场景中可被认出，沿用同一身份与该场的服装版本 |

总览可用横向网格，优先给全身视图和核心肖像留空间，再安排表情、服装、配饰、手势、动作、色卡和氛围图。参考中的姓名、职业和纸张色调按素材各自职责取用。图中文字需要精确时把无字生成底图与后期排字分开。

默认交付角色设计定位、参考职责、固定设定和可变化项、布局与可复制生图词。要拆图时给每张独立的完整提示，用户只要一个模块时直接处理该部分。生成后核对角度、对齐基线、左右不对称特征、服装配件与局部清晰度。发生身份或服装修改时同步受影响视图、表情、动作和剧情图，说明哪些已生成并验收。

## 人物白底三视图

三格版面左到右为正面、左侧 90 度、背面。侧别从角色本人定义，必要时单独加右侧。三格统一身高比例、头顶和脚底基线、服装、发型、鞋、光位和镜头尺度。保留手、脚、头顶和轮廓边缘。让拼版承担美术核对；实际生成视频时可裁出当前镜头最有用的单格。拼版作为分镜或构图参考时，按 H3 指南单列 `<Picture N>` 并指出哪一格生效。 [ComfyUI 参考拼版说明](https://docs.comfy.org/tutorials/video/minimax/minimax-h3-prompt-guide)

做四格身份图时，三格全身共用脚底基线。第四格优先用正面头肩近照，保留头顶、发际线和完整下颌，底边收到锁骨或上胸，脸从发际到下颌占该格约六至七成高度。验收时按整张图缩小后的实际观感，确认眉眼、发际线和脸部轮廓仍能区分。需要上身姿态时可留到腰部，并优先扩大人像一栏。核对侧格为严格侧面，背格朝远离摄影机，服装、配饰所在侧和身体比例能够互证。作为 1160 身份素材时为每个人分别绑定一张四格图，主体定义说明前三格供体型、服装与轮廓，右侧近照供面部识别。整张图描述的是同一人，镜头正文仍写该人物实际只在对应位置出现一次，按故事环境构图。

引用已有的不同排版时，按实际位置映射面部与全身，例如上方的头肩特写负责骨相、眼型、妆容和发际线，下方的全身视图负责体型、剪裁、配饰和发束轮廓。根据用户指定的主参考化解同一属性冲突。需要确定三维形体和材质方向时，参见[画面美术与角色渲染](../../video-scene-direction/references/look-design.md)。

```text
A production turnaround sheet of the same character in three full-body views, arranged left to right: front, true left profile at 90 degrees, and back. Match the attached character reference: {face and hair}; {body proportions}; {wardrobe and shoes}; {asymmetric detail and its side}.
Use a relaxed neutral standing pose and the same head and foot baselines in all three panels. Show complete hands, feet and hair silhouette. Orthographic-style presentation, consistent image scale, large neutral soft lighting, a clean pure white background, and wide separation between panels.
```

## 半身和面部细节

半身图提供比例、服装与上肢关系；面部图提供眉眼、鼻形、唇线、发际线、皮肤材质和细小标记。对白常用的正面或四分之三侧面优先。睫毛、配饰和识别点可见时，对照正侧面；红色偏光或夸张表情另作表演参考。

```text
Waist-up character reference of the exact person in the approved image, in a {front or three-quarter} view at eye level. Keep {hairline, head shape and features}, {body proportions}, and {garment landmarks}. Both shoulders and the waistline are in frame. Neutral posture and expression, lens at eye level, even soft light, pure white background, with clear hands when visible.
```

```text
Head-and-shoulders identity reference of the same character, {front or three-quarter} angle. Frame the full hairline, ears if normally visible, and chin. Preserve {eyes, nose, lips, jaw, skin texture and the exact side of distinctive marks}. Eyes relaxed and mouth naturally closed. Neutral white background, soft balanced light, clear focus across the face, natural texture.
```

## 场景和道具的参考包

| 素材 | 先规定什么 | 可复制的图像提示词 |
| --- | --- | --- |
| 场景主参考 | 时段、主光方向、入口、窗、家具及关键道具所在位置 | `An unoccupied establishing view of {location} from {camera position}. {door, window, table and other landmarks, with fixed spatial relationships}. {time of day and light source}. Show clear walking space and retain the approved color and material palette.` |
| 同场反角度 | 从主参考推导实际机位，区分画面左右和场景里的固定方位 | `A reverse angle of the same approved room from {opposite position}, looking toward {landmark}. Keep the existing floor plan, entrances, furniture, light source and prop positions. Reveal only the new viewpoint of that same space.` |
| 道具设计 | 统一尺寸、材质、色块、磨损点、握持处和运动零件 | `Isolated production reference of {prop} on a pure white background, front, side and three-quarter views at the same scale. Show {dimensions or scale cue}, {material}, {distinctive details}, and clearly separate the {moving part} from the fixed body.` |
| 道具状态图 | 开合、完整或损坏、指针初末位置及接触关系 | `Two clearly separated panels of the same {prop}: {starting state} and {ending state}. Preserve dimensions, material and fixed anchor points; show the exact change to {hinge, handle, surface or contents}.` |

每个镜头填写人物、服装、场景、道具版本，注明哪张图负责身份、哪张负责环境、哪张负责开场构图。白底身份图与实际故事环境是两种用途；镜头正文要明确实际背景。需要精确构图时，先准备合成后的场景关键帧。保持物件的绝对位置，让摄影机移动造成的画面左右变化能从同一平面布局推导。
