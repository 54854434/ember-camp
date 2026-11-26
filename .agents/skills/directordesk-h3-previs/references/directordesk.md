# DirectorDesk 工程与导出

## 定稿转工程

1. 本机安装版在 `D:/comfyui/维护工具/DirectorDesk-0.5.5.1/`。如果已升级，找实际使用的同名安装目录。用它自带的 `skills/director-desk/SKILL.md` 和按需引用的 `project-format.md`、`camera.md`、`files.md`。用 Node 22+ 运行同版本 `skills/director-desk/scripts/project-tool.mjs`，或直接从该模块导入函数。
2. 先把每个真实切点、动作先后、朝向、站位和近远层关系整理成编排。把角色、地标和手持道具绑定进场景。角色位移用路径加动作片段，镜头运动用机身路径，摇镜或跟随用视线路径、目标绑定或合适的摄影机预设。动作起止与切镜对齐项目帧率；用选定的角色替身和场景简模保持身份及空间一致。镜头编号和切镜时间用定稿的已知值。
3. 单段从 `createScene` 或既有单段工程开始，使用 `applyOperationsWithResources` 写入时间轴，再用 `assertProject` 和 CLI `validate` 核对；多戏段用 `readSceneDocument`、`projectForScene` 等官方文档接口。用 `queryAssetCatalog` 定向获取真实资产与参数。剧本里有音效或对白时存为剧情备注及配套提示词，按实际导出设置说明白模是否有音轨。
4. 同目录不同稿用能区分的文件名，保留用户原稿。文件选择后界面未切换时，先核对选择的是 `.director` 和窗口标题/时间轴。单戏段可用同版本工具另存短路径的兼容副本；需要保留多戏段或外部资源时保留原工程结构。

## 实播和导出

- 本机 MCP 已连接时，按同版本 `files.md` 使用 `director_read` 取修订号，`director_import` 打开绝对路径，`director_job` 查看完成状态。对已有未保存工作先保留它。查看成片机位的关键时点，核对人物与道具入画、站位、关键动作、切镜后承接和最终姿态。
- 普通参考用 `director_export` 的 `kind:"video"`、`format:"mp4"`、节目机位（遵循实际切镜），输出目录用当前任务的工作区。用当前目标 fps；交给本机 1160 通常用 24 fps，同画幅先用 640 长边快速出样，辨识不足可以用 1280。深度视频用于明确要求深度的任务。轮询已有 `jobId` 至完成，核对 `result.files` 含已保存的实际路径和可读的视频文件。
- 未连接 MCP 时，已有桌面应用可按当前授权和适用的桌面操作规则使用「文件 → 打开」以及右上「导出」，选普通画面 MP4。没有可用渲染会话时说明 MP4 待导出，工程照常交付。离线 `project-tool.mjs` 可以生成和校验工程，视频由 DirectorDesk 渲染。

依用户所需交付工程、白模和提示词。分别说明经过文件校验、经过实际播放的内容，以及需要用户复核的接触、遮挡等效果。
