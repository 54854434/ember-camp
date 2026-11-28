# H3 NSFW 最佳实践（整合社区实测）

来源综合：WeissGoat/h3-prompt-skill practice.md、xingheFF/minimax-h3-NSFW-skill、Velvet Vice Prompt Director 等。

## 1. 正向命令优先（最重要）
提示词 = 指挥模型做什么，不是开罚单。  
关键事实（插入深度、接触状态、正确解剖、镜头类型）在 summary、动作段、结束状态重复 2–3 次。

示例（插入）：
```
Summary: His erect penis is inserted in her vagina; he thrusts in and out.
Action:  His erect penis is inserted in her vagina. He thrusts in and out of her vagina with steady rhythm.
End:     His erect penis is still inserted in her vagina.
```

## 2. 接触绝对状态
- 写 “pressed flush against”, “fully inside”, “clear contact with correctly shaped …”
- 禁止悬空、滑过皮肤表面、瞄准错误部位。

## 3. 动作节奏
- 一个主要驱动动作 + 对方反应。
- 重复动作写一次节奏：`begins a steady, slow rhythm and keeps it until the end of the shot`
- 8 秒以上单镜用 “From 0 to 2 seconds… From 2 to 5 seconds…” 覆盖全时长。

## 4. 镜头
- 明确内容优先静态：`The camera holds a static shot; the frame never moves: no cut, no pan, no tilt, no zoom, no push-in, no camera shake and no reframing.`
- 接触/插入用近景 prioritise the contact area。

## 5. 声音
- overall_soundscape：按来源、材质、节奏、对应动作写。
- 非语言享受声与动作同步。
- 结尾明确排除多余声音：`Only her breathing and moans are heard; there is no male voice, no dialogue, no music and no other ambient sound.`（按需调整）
- non_diegetic_music: N/A（除非用户要求）

## 6. 词汇
使用模型/LoRA 训练过的直接词：penis, vagina, vaginal, penetration, insert, thrust, breasts, jiggle, moan, heavy breathing, plopping sound 等。  
避免过度委婉导致模型不知道要生成什么。

## 7. 多参考与身份
- subject_definitions 清晰分工（身份 vs 局部解剖 vs 动作参考）。
- retention_analysis 对关键解剖和道具写 fully_preserved。
