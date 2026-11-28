# H3 NSFW 最佳实践（整合社区实测）

来源综合：WeissGoat/h3-prompt-skill practice.md、xingheFF/minimax-h3-NSFW-skill、社区 Telegram/Discord 实测、Velvet Vice 等。

## 1. 正向命令优先（最重要）

提示词 = 指挥模型做什么，不是开罚单。  
关键事实（插入深度、接触状态、正确解剖、镜头类型、锁具状态）在 summary、动作段、结束状态重复 2–3 次。

示例（插入）：
```text
Summary: His erect penis is inserted in her vagina; he thrusts in and out.
Action:  His erect penis is inserted in her vagina. He thrusts in and out of her vagina with steady rhythm.
End:     His erect penis is still inserted in her vagina.
```

## 2. 接触绝对状态（Dual Lock / Absolute Contact）— WeissGoat 核心

- 写 “pressed flush against”, “fully inside”, “clear contact with correctly shaped …”
- 禁止悬空、滑过皮肤表面、瞄准错误部位。H3 会瞄准腹部、臀部或空气。
- 插入时同时锁定双方：
  ```text
  her pelvis stays pressed flush against his; his erect penis remains fully inside her vagina
  ```
- 每一段结束状态都要重申接触状态，防止漂移。
- 接触点在画面中的位置保持稳定。

## 3. 动作节奏与时间覆盖

- 一个主要驱动动作 + 对方反应。不要两边臀部同时主动（易卡顿或同步假动作）。
- 重复动作写一次节奏：`begins a steady, slow rhythm and keeps it until the end of the shot`
- 8 秒以上单镜用 “From 0 to 2 seconds… From 2 to 5 seconds…” 覆盖全时长，不留空白。
- 最重要动作放在镜头中段，避免压在最后一秒。
- 字面优先于委婉：`She slowly lowers her hips until...` 比 `they make love` 有效。

## 4. 镜头

- 明确内容优先静态：`The camera holds a static shot; the frame never moves: no cut, no pan, no tilt, no zoom, no push-in, no camera shake and no reframing.`
- 接触/插入用近景 prioritise the contact area。
- 一次镜头最多一种运动，且小幅度慢速。
- 详见 [camera-and-framing.md](camera-and-framing.md)。

## 5. 声音分层

- overall_soundscape：按来源、材质、节奏、对应动作写。  
  示例：`soft continuous female moans and quiet pleasured gasps synchronized with the hand movements and breast deformation. Soft skin contact sounds.`
- 非语言享受声与动作同步写在 detailed_description 对应位置。
- 结尾明确排除多余声音：`Only her breathing and moans and the specified dialogue are heard; there is no male voice, no extra dialogue, no music and no other ambient sound.`
- non_diegetic_music: N/A（除非用户要求）
- 避免拟声词（slapping / 啪啪）容易变成爆炸声。

## 6. 词汇（直接用训练过的词）

使用模型/LoRA 训练过的直接词：  
penis, erect penis, vagina, vaginal, labia, clitoris, anus, penetration, insert, thrust, breasts, jiggle, bounce, moan, heavy breathing, soft moans, plopping sound, wet, lubrication 等。  

避免过度委婉导致模型不知道要生成什么。

## 7. 多参考与身份锁定

- subject_definitions 清晰分工（身份 vs 局部解剖 vs 动作参考）。
- retention_analysis 对关键解剖和道具写 fully_preserved。
- 第一人称时把“viewer's hands”作为持续可见元素反复确认。
- 只有穿着图时，用条件句覆盖露出后状态。

## 8. 常见失败与正向修复

- 生殖器异形/融合 → 加入 “accurately shaped natural female/male genitals with correct proportions, visible labia / accurate glans and shaft, without distortion, fusion or deformation”
- 接触漂移 → 每段结束状态重申 absolute contact
- 双手消失 → “The viewer's hands remain clearly visible in the frame”
- 多余人声 → soundscape 明确排除
- 男娘下体被修正 → 三重锁定 + “clearly male”
- 贞操锁变形 → “remains firmly locked, correctly shaped” + 材质细节

## 9. 与官方 H3 写作 skill 的关系

本技能所有输出必须符合 h3-visual-prompting 的六字段（Ref2VA）或三字段（T2VA）结构。  
成人增强只发生在 detailed_description、retention_analysis、overall_soundscape 内部，不改变官方字段顺序与语法。

## 10. 用户主流工作流额外提醒（纯文生 / 穿衣服图）

- 露出瞬间是解剖与锁具锁定的黄金窗口。
- 优先短时长（6–12 秒）测试正确版本，再扩展。
- 多生成几个种子选解剖最稳的继续迭代。
