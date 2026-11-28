# 常见失败与文本修复

## 1. 生殖器异形 / 融合 / 比例崩坏

**文本修复优先级：**
1. 在接触 / 露出瞬间加入精确正向描述（见 anatomy-writing.md 与 genital-anatomy.md）
2. 拆分动作，降低同帧竞争
3. 加强 retention 对解剖部位的约束
4. 仍不行再考虑加局部参考图

常用修复句：
```text
accurately shaped natural female/male genitals with correct proportions, without distortion, fusion or deformation
```

## 2. 男娘下体被自动修正为女性 / 消失（高频）

**原因**：模型先验倾向于“外表女性 = 女性下体”。

**修复**：
- 露出瞬间立刻写 `correctly proportioned penis and testicles that remain fully present and clearly male`
- summary + 动作 + 结束状态三重锁定
- retention 明确：`When lower body is revealed: correctly proportioned male genitals remain fully present and clearly male; do not replace with female genitals.`
- 避免只写 “cute femboy / pretty boy” 而不提下体

## 3. 贞操锁变形 / 消失 / 融成模糊块

**修复**：
- 使用具体材质：`metal chastity cage` + `realistic metal reflections` + `small padlock`
- 三重锁定：`remains firmly locked, correctly shaped and in place`
- 被触碰时再次确认：`the cage remains rigid, correctly shaped and securely locked`
- 避免 “jiggle / soft / flexible” 等描述

## 4. 双手中途消失或穿模

在关键动作后补充：  
`The viewer's hands remain clearly visible in the frame and maintain natural contact.`

## 5. 享受声变成乱说话

在 `overall_soundscape` 明确：  
`No other voices. Only the specified dialogue and non-verbal pleasure sounds.`

并检查对白是否用了正确的 `<d>[Language] ...</d>` 格式。

## 6. 口型与声音不同步

把声音描述与具体动作绑定，例如：  
`as the fingers press firmly, she lets out a soft moan`

## 7. 身体贴合后透视崩溃

明确距离变化：  
`She steps closer until her breasts nearly fill the frame...`

并保持第一人称提示词稳定。

## 8. 穿衣服图生视频时下体/锁具失败

**原因**：参考图只有穿着状态，模型缺乏下体先验。

**修复优先级**：
1. 露出动作写得足够清晰且立刻锁定解剖 + 锁具
2. retention_analysis 专门覆盖 “when lower body is revealed”
3. 缩短单镜时长，先锁定正确版本再加动作
4. 多生成几个种子选解剖最稳的继续

## 生成策略建议（针对用户主流工作流）

- 关键亲密 / 露出镜头优先短时长（6–12 秒）测试
- 先锁定解剖正确的版本，再延长动作或加对白
- 采样时适当提高细节相关权重（如有）
- 多生成几个种子，选解剖与锁具最稳的继续迭代
- 纯文生时把关键锁定句写得更密；有穿着图时把重点放在露出瞬间
