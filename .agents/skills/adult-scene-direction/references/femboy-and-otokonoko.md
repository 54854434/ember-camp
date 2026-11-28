# 男娘 / Femboy / Otoko no ko 写法（强化版）

## 1. 核心定义与风险

- 男娘（otoko no ko / femboy）：外表高度女性化，但保留完整男性生殖器（penis + testicles）的成年角色。
- 最大风险：模型会自动把下体“修正”成女性生殖器，或让阴茎消失 / 融合。
- 必须用正向锁定，而不是负向禁止。
- **用户主流工作流**：纯文生视频，或只有一张穿衣服人物图做图生视频。此时无下体参考图，全靠文本锁定。

## 2. 不同输入条件的成功率（实测参考）

| 输入 | 男性下体保持率 | 建议策略 |
|------|----------------|----------|
| 纯文生（无参考） | 中等偏低 | 必须在 summary + 可见瞬间 + 结束状态三重锁定 |
| 只有穿衣服全身图 | **中等偏上** | 推荐主力方案，身份由参考图稳住，下体靠文本 |
| 穿衣服图 + 下体局部参考 | 高 | 有条件时优先 |
| 有对应 LoRA（如 ST-REAL-SHEMALE） | 高 | 可降低文本重复强度 |

## 3. 推荐身份与身体描述

- 身份：`feminine-presenting adult male` / `otoko no ko` / `femboy with soft feminine features and male genitalia`
- 身体特征（按角色设定选择）：
  - `soft feminine face, long eyelashes, smooth skin`
  - `flat chest` 或 `small soft breasts`（按设定）
  - `narrow waist, feminine hips, smooth thighs`
- **下体强制锁定**（必须多次出现）：
  ```text
  He has a correctly proportioned erect (or flaccid) penis and testicles that remain fully present, attached and clearly male throughout the entire shot.
  ```

## 4. 正向重复策略（最重要）

在以下位置各写一次关键锁定句：

1. `summary`
2. `detailed_description` 中下体可见的动作段（尤其是露出瞬间）
3. 镜头结束状态（end state）

示例：
```text
Summary: A feminine-presenting adult male (femboy) with correctly proportioned penis and testicles...
Action:  His correctly proportioned penis remains fully present and attached...
End:     His penis and testicles are still clearly visible and correctly shaped.
```

## 5. 与穿衣服参考图配合（用户最常用）

```text
subject_definitions:
<Subject 1> is the feminine-presenting adult male shown in <Picture 1>, used for face, body proportions, clothing and overall identity.

retention_analysis:
<Subject 1> (throughout): fully_preserved - retain exact face, body proportions and clothing. 
When lower body is revealed: correctly proportioned male genitals remain fully present and clearly male; do not replace with female genitals.
```

露出时立刻写：
```text
He lifts the skirt / pulls the panties aside, revealing a correctly proportioned penis and testicles that remain fully present and clearly male.
```

## 6. 与贞操锁组合（高频场景）

同时锁定三件事：

1. 外表女性化
2. 下体是男性生殖器
3. 生殖器被贞操锁正确锁住

推荐组合句（summary / 露出 / 结束各写一次）：
```text
A feminine-presenting adult male (femboy) wearing a metal chastity cage that fully encloses his correctly proportioned penis, with the testicles clearly visible below the cage. The cage remains firmly locked and correctly shaped throughout.
```

详见 [chastity-cage.md](chastity-cage.md) 与 [clothing-and-reveal.md](clothing-and-reveal.md)。

## 7. 与参考图 / LoRA 配合（可选增强）

- 推荐资产：
  - 全身身份图（脸 + 体型 + 服装）—— 用户最常有
  - 下体局部特写图（带阴茎和睾丸）—— 有则更好
- 已知有效 LoRA：`ST-REAL-SHEMALE MMH3`（训练数据明确是 femboy + 男性下体）。有该 LoRA 时在提示词中加入对应触发词，并降低强度避免过拟合。
- **无 LoRA 时**：靠「穿衣服身份图 + 三重正向锁定」仍可达到可用成功率。

## 8. 常见场景写法要点

- 着装露出：裙子掀起、丝袜、内裤偏到一边时，必须立刻锁定男性下体。
- 手部互动：手碰到下体时写 `makes clear contact with his correctly proportioned penis`。
- 避免只写 “cute boy / pretty boy” 而不提下体，否则模型容易自动女性化。

## 9. 检查清单

- [ ] 下体第一次可见时是否写了正确男性解剖？
- [ ] 是否在 summary / 动作 / 结束状态重复了锁定句？
- [ ] retention 是否覆盖了 genital anatomy（即使只有穿着图）？
- [ ] 是否避免了只写外表而不提下体？
- [ ] 与贞操锁组合时是否同时锁定了三件事？
