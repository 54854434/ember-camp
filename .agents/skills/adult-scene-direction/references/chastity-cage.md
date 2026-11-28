# 贞操锁 / Chastity Cage 写法（强化版）

## 1. 核心目标

让金属或塑料贞操锁在运动中保持：
- 正确形状与比例
- 锁具细节清晰
- 不消失、不变形、不融合成模糊块
- 与男娘下体正确结合（阴茎被完全包住，睾丸在下方可见）

## 2. 不同输入条件的成功率（用户主流场景）

| 输入条件 | 锁具存在与形状 | 建议 |
|----------|----------------|------|
| 纯文生（无参考） | 中等偏低 | 必须三重正向锁定 + 材质细节 |
| 只有穿衣服人物图 | 中等 | 推荐主力；露出瞬间重点描述 |
| 穿衣服图 + 锁具局部参考 | 高 | 有条件时优先使用 |
| 有对应 chastity LoRA | 高 | 可降低文本重复强度 |

**结论**：无 LoRA、无局部参考图时，仍可通过 skill 的正向重复达到可用效果，但细节精度会受影响。优先使用穿衣服身份图作为起点。

## 3. 推荐基础描述

- 核心词：`chastity cage` / `chastity device` / `locked chastity cage`
- 材质与颜色（写清楚比模糊好）：
  - `metal chastity cage`
  - `pink plastic chastity cage`
  - `transparent chastity cage`
  - `flat chastity cage` / `cb-style chastity cage`
- 细节补充：
  - `small padlock`
  - `testicles visible below the cage`
  - `urethral tube`（如有）
  - `realistic metal reflections` / `smooth plastic surface`

## 4. 正向锁定模板（必须多次出现）

```text
He wears a [material] chastity cage that fully encloses his penis, with the testicles visible below. The cage remains firmly locked, correctly shaped and in place throughout the movement, with clear [metal/plastic] details and realistic reflections.
```

在 **summary、露出/可见动作段、结束状态** 各写一次。

## 5. 男娘 + 贞操锁组合（最高频）

同时锁定三件事：
1. 外表女性化（femboy / otoko no ko）
2. 下体是男性生殖器
3. 生殖器被贞操锁正确锁住

推荐组合句：
```text
A feminine-presenting adult male (femboy) wearing a metal chastity cage that fully encloses his correctly proportioned penis, with the testicles clearly visible below the cage. The cage remains firmly locked and correctly shaped throughout.
```

### 露出瞬间专用（用户最常用场景）

```text
He lifts the skirt / pulls the panties aside, revealing a correctly proportioned penis fully enclosed inside a metal chastity cage, with the testicles clearly visible below. The cage remains firmly locked and correctly shaped with realistic metal details.
```

## 6. 与参考图 / LoRA

- 优先使用清晰的局部参考图（正面 + 侧面），在 `subject_definitions` 中单独定义为 `<Subject N>`，职责为 chastity device shape and details。
- retention_analysis 写：
  ```text
  <Subject N> (chastity cage): fully_preserved - retain exact shape, lock, material and position.
  ```
- 社区有针对 H3 / Illustrious 的 chastity 相关 LoRA。有 LoRA 时加入触发词，并控制强度。
- **无 LoRA 时**：靠「穿衣服身份图 + 三次正向描述 + end state 重申」仍可大幅提升稳定性。

## 7. 运动与接触时的写法

- 走动 / 被触碰时：
  ```text
  The chastity cage stays firmly locked and correctly shaped as he moves / as the hand touches it.
  ```
- 被他人把玩时：
  ```text
  The hand gently holds and turns the locked chastity cage; the cage remains rigid, correctly shaped and securely locked with the padlock visible.
  ```
- 避免写 “the cage jiggles” 或过度柔软描述，容易导致模型把硬质装置画软。

## 8. 纯文生 / 只有穿着图时的额外建议

- 在 `retention_analysis` 中即使没有额外 Subject，也要写：
  ```text
  When lower body is revealed: correctly proportioned male genitals fully enclosed in a metal chastity cage with testicles visible below; the cage remains firmly locked and correctly shaped.
  ```
- 材质尽量具体（metal / pink plastic），并加 `realistic reflections` 或 `smooth surface`。
- 先出短时长（8–12 秒）测试锁具形状，再延长动作。

## 9. 检查清单

- [ ] 锁具第一次出现时是否写清材质、形状、锁具细节？
- [ ] 是否在 summary / 动作 / 结束状态重复了 “remains firmly locked and correctly shaped”？
- [ ] 运动或被触碰时是否再次确认锁具稳定？
- [ ] 男娘场景是否同时锁定了男性下体？
- [ ] 露出瞬间是否立刻完成解剖 + 锁具双重锁定？
