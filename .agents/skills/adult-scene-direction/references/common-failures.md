# 常见失败与文本修复

## 1. 生殖器异形 / 融合 / 比例崩坏

**文本修复优先级：**
1. 在接触瞬间加入精确正向描述（见 anatomy-writing.md）
2. 拆分动作，降低同帧竞争
3. 加强 retention 对解剖部位的约束
4. 仍不行再考虑加局部参考图

## 2. 双手中途消失或穿模

在关键动作后补充：  
`The viewer's hands remain clearly visible in the frame and maintain natural contact.`

## 3. 享受声变成乱说话

在 `overall_soundscape` 明确：  
`No other voices. Only the specified dialogue and non-verbal pleasure sounds.`

并检查对白是否用了正确的 `<d>[Language] ...</d>` 格式。

## 4. 口型与声音不同步

把声音描述与具体动作绑定，例如：  
`as the fingers press firmly, she lets out a soft moan`

## 5. 身体贴合后透视崩溃

明确距离变化：  
`She steps closer until her breasts nearly fill the frame...`

并保持第一人称提示词稳定。

## 生成策略建议

- 关键亲密镜头优先短时长（6–10 秒）测试
- 先锁定解剖正确的版本，再延长动作
- 采样时适当提高细节相关权重（如有）
- 多生成几个种子，选解剖最稳的继续迭代
