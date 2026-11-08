# 新对话从这里接手

本仓库保存当前工程、已确定的方向、已知问题和开发队列。无需访问旧聊天或原来的临时工作区即可了解项目；实际开发仍需取得此私有仓库的正常读写权限。

## 阅读顺序

| 顺序 | 文件 | 解决的问题 |
|---|---|---|
| 1 | [AGENTS.md](../AGENTS.md) | 用户授权范围、偏好与兼容约束 |
| 2 | [PROJECT_STATUS.md](PROJECT_STATUS.md) | 当前实现、验证、待确认事项 |
| 3 | [ROADMAP.md](ROADMAP.md) | 下一项任务、依赖与完成标准 |
| 4 | [ARCHITECTURE.md](ARCHITECTURE.md) | 现有模块和后续拆分边界 |
| 5 | [KNOWN_ISSUES.md](KNOWN_ISSUES.md) | 不要漏掉的风险和已有缺陷 |
| 按需 | [DECISIONS.md](DECISIONS.md)、[GAME_DESIGN.md](GAME_DESIGN.md)、[ART_DIRECTION.md](ART_DIRECTION.md) | 设计决定、玩法、美术依据 |

## 第一次操作

```bash
git status --short
git log -5 --oneline
python3 scripts/fetch_font.py
python3 scripts/check_project.py --godot godot
```

命令从仓库根目录运行。Godot 必须是 4.4.1 standard；统一检查脚本当前使用 Linux 隔离用户目录，其他宿主优先使用 GitHub Linux CI。详见 [DEVELOPMENT.md](DEVELOPMENT.md)。

## 接下来做什么

1. 如果用户带来新故障，优先复现、修复和添加回归检查。
2. 如果没有新故障，**P0-SAVE-01**已通过CI #7；**P1-BUILD-01**已实现、本地57项检查通过，先核对本批CI，成功后继续 **P1-DEATH-01：死亡后部分物资回收**。
3. 接着处理布防寻路、施工一致性和可持续资源循环，再扩大经营/战略内容。
4. 美术按一个可玩的营地与荒野样板区域推进，不把单张素材当作完整画面升级。

用户已在iQOO 11/OriginOS 6确认最近构建ZIP内APK的菜单正常开关、移动同时开火不失灵、界面显示完整，详见PLAYTEST。不要再把这三项写成未确认，也不要扩大成全部机型、存档或性能已验证。无需重复要求基础测试；施工批次新增行为尚待真机验证。

用户最新偏好：外勤与基地并重、死亡可冒险回收部分物资、克制手绘末日风；自由度参照《僵尸毁灭工程》与CDDA。死亡回收未实现，已列P1-DEATH-01；读取GAME_DESIGN与ADR-013，不要混淆设计和当前代码。

架构与路线图允许自主优化，见AGENTS与ADR-011；用实际收益、兼容方案与验证记录支撑调整。

## 每批结束时

- 修改与测试通过后，更新状态、路线图、已知问题和变更日志。
- 留下一个明确的下一项任务及其验收标准。
- 提交并核对 GitHub 内容；最终检查失败时写清失败原因和恢复入口。
- 只有确实发布新的试玩包时才更新“最近试玩版本”和安装说明。

复制用的一句话保存在 [CONTINUE_PROMPT.txt](../CONTINUE_PROMPT.txt)。

