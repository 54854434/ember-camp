# 开发与验证

## 工程准备

1. 取得私有仓库的正常权限并克隆 `https://github.com/54854434/ember-camp.git`。
2. 安装官方Godot **4.4.1 standard**。目前没有C#、原生扩展或第三方插件依赖。
3. 在仓库根目录运行 `python3 scripts/fetch_font.py`，下载固定提交的Noto CJK SC与许可。字体二进制不入Git，原始生成环境不必保留。
4. 用Godot打开`project.godot`，运行主场景。

如果连接工具对私有仓库返回404，不代表仓库不存在。需要正常的仓库授权；不要公开仓库、复制浏览器凭据或把密钥写入文档来解决访问问题。当前仓库维护曾通过已登录GitHub网页完成，新对话不得假定同一登录会话仍可用。

## 一条命令验证

```bash
python3 scripts/check_project.py --godot godot
```

也可把`--godot`设为本机可执行文件的完整路径。该脚本目前支持Linux：在`.godot/checks/`中创建临时目录，每组测试使用独立`XDG_DATA_HOME`，完成后清理；不读写开发者的正常玩法存档。其他宿主使用GitHub Linux CI，直接运行单独场景测试前应自行隔离用户目录。

检查顺序：固定引擎版本与字体 → 导入 → 68项规则 → 12项世界兼容 → 29项触屏 → 场景。脚本超时、非零退出、GDScript错误或缺少成功标记都视为失败。测试数变化时更新状态文档，不能只改说明中的数字。

单独定位时可在隔离环境中执行：

```bash
godot --headless --path . --script tests/test_rules.gd
godot --headless --path . --script tests/test_world_generation.gd
godot --headless --path . --script tests/test_touch.gd
godot --headless --path . --script tests/smoke.gd
```

## Android构建

`.github/workflows/android.yml`配置Godot4.4.1、OpenJDK17、Android build-tools34.0.0、platform34，执行统一检查、导出arm64 debug APK并验证签名。push到main或手动workflow_dispatch均可触发，最终提交需要检查。

产物`ember-camp-debug`含APK与SHA256SUMS，默认保留30天。下载产物过期时可从源码重新构建，不应在交接文档中依赖临时下载URL。

本地Godot Android路径设置完成后：

```bash
godot --headless --path . --export-debug Android build/ember-camp-debug.apk
```

用户要求由其自行安装真机测试；无需主动部署安卓模拟器。

## 签名与更新

- 包名：`org.embercamp.survival`；最近试玩0.1.1的versionCode为2。
- 上一次对话直装0.1与0.1.1使用同一本地debug key；CI使用另一份缓存的debug key。
- 新环境不必拥有旧临时目录；但没有旧签名私钥就不能保证覆盖更新原安装。不要建议用户为测试轻易卸载而丢失进度，应先区分安装渠道与备份需求。
- CI缓存不能作为永久签名保障；正式发行前单独确定安全保存和签名流程。密钥、口令与令牌永不入Git。

## 变更类型与验证

| 变更 | 必须确认 |
|---|---|
| 存档/营地/物流 | v1读取、跨营地归属、材料守恒、重复领取、失败恢复 |
| 世界生成 | 版本、冻结夹具、正负坐标、调用顺序和旧存档地区 |
| 手机交互 | 原生触摸、多指、按住、取消、暂停模态、动态菜单生命周期 |
| 美术/UI | 真实引擎渲染、按钮边界与遮挡、字体与对比、实际设备反馈待确认 |
| 构建/依赖 | 固定版本、导入和签名、可重现源码与最终CI结果 |

## 每批提交清单

代码与必要测试 → 统一检查 → 实际界面变更时桌面渲染 → 状态/路线图/已知问题/CHANGELOG → 提交GitHub → 核对CI。若暂时无法完成某一步，准确记录阻塞与接续命令，不把待完成项标记为完成。
