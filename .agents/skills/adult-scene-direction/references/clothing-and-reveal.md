# 着衣、半脱与露出过程（强化版）

本文件重点覆盖用户最常见工作流：**纯文生视频** 或 **只有一张穿衣服人物图做图生视频**，尤其是男娘 + 贞操锁场景。

## 1. 核心原则

- 服装状态变化必须有清晰的先后顺序和可见结果。
- 半脱 / 掀起比直接全裸更利于身份锁定与连续性。
- **露出瞬间是解剖锁定的黄金窗口**：下体第一次可见时必须立刻写清正确结构。
- 布料形变、拉扯、滑落要自然，并在结束状态明确最终位置。

## 2. 用户主流工作流成功率参考

| 输入条件 | 男娘下体成功率 | 贞操锁细节成功率 | 建议 |
|----------|----------------|------------------|------|
| 纯文生（无任何参考） | 中等偏低 | 中等偏低 | 必须靠正向重复拉成功率 |
| 只有穿衣服全身图 | **中等偏上** | 中等 | 推荐主力方案 |
| 穿衣服图 + 锁具局部参考 | 高 | 高 | 有条件时优先 |
| 有下体局部参考 | 高 | 高 | 最稳 |

## 3. 男娘 + 贞操锁 推荐露出写法（无下体参考时）

### 3.1 必须锁定的三件事（同时出现）

1. 外表女性化（femboy / otoko no ko / feminine-presenting adult male）
2. 下体是正确比例的男性生殖器（penis + testicles）
3. 阴茎被贞操锁完全包住，睾丸在锁下方可见，锁具保持正确形状

### 3.2 标准正向锁定句（summary / 露出动作 / 结束状态各写一次）

```text
A feminine-presenting adult male (femboy) with soft feminine features. He has a correctly proportioned penis that is fully enclosed inside a metal chastity cage, with the testicles clearly visible below the cage. The chastity cage remains firmly locked, correctly shaped and in place throughout.
```

### 3.3 露出动作模板（推荐）

**掀裙子 / 掀衣服：**
```text
From X to Y seconds: He lifts the skirt / hem of the clothing, revealing a correctly proportioned penis fully enclosed inside a metal chastity cage, with the testicles clearly visible below. The cage remains firmly locked and correctly shaped with realistic metal details.
```

**拉下内裤 / 拨开内裤：**
```text
He pulls the panties aside / down, revealing a correctly proportioned penis fully enclosed in a metal chastity cage. The testicles are clearly visible below the cage. The cage stays firmly locked and correctly shaped.
```

**裤子被拉下：**
```text
The pants are pulled down to the thighs, revealing a correctly proportioned penis fully enclosed inside a metal chastity cage with the testicles visible below. The cage remains firmly locked and correctly shaped throughout the movement.
```

### 3.4 结束状态必须重申

```text
At the end of the shot, the metal chastity cage is still firmly locked and correctly shaped around his penis, with the testicles clearly visible below. His clothing remains [最终服装状态].
```

## 4. 普通女性 / 男性着衣露出（通用）

### 拉扯 / 拨开
- `she pulls her panties aside, exposing her accurately shaped natural female genitals`
- `he tugs her top down, freeing her breasts`
- `the fabric is pushed to the side and stays there`

### 半脱状态
- `skirt hiked up around her waist`
- `bra straps slipped off her shoulders, cups pulled down under her breasts`
- `shirt unbuttoned and open, revealing bare skin underneath`
- `pants pulled down to mid-thigh`

### 丝袜 / 连裤袜
- `sheer stockings`, `ripped stockings at the crotch`
- `pantyhose pulled down to her thighs`

### 连续性
结束状态必须写清衣服最终停在哪里，方便下一镜接续：
```text
Her panties remain pulled aside, breasts exposed, skirt bunched at her waist.
```

## 5. 纯文生 / 只有穿着图时的额外强化

- 在 `subject_definitions` 中明确：  
  `<Subject 1> is the feminine-presenting adult male shown in <Picture 1>, used for face, body proportions, clothing and overall identity.`
- 在 `retention_analysis` 中额外写：  
  `When lower body is revealed: correctly proportioned male genitals fully enclosed in a metal chastity cage with testicles visible below; the cage remains firmly locked and correctly shaped.`
- 不要只写 “cute boy” 或 “pretty femboy” 而不提下体与锁，否则模型容易自动修正为女性下体。

## 6. 检查清单

- [ ] 露出动作是否立刻锁定了正确男性解剖 + 锁具状态？
- [ ] summary / 露出段 / 结束状态是否各出现一次关键锁定句？
- [ ] 服装最终位置是否在结束状态写清？
- [ ] 是否避免了在同一秒同时做过多动作（露出 + 触碰 + 说话）？
