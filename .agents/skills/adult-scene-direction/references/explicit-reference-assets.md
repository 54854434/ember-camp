# 成人角色参考资产建议（强化版）

针对用户主流工作流（纯文生 或 只有穿衣服人物图）优化。

## 1. 优先级排序（从高到低）

1. **穿衣服全身 / 身份主图**（最常用，推荐必备）  
   职责：脸、身体比例、服装、整体造型。  
   即使没有下体参考，也能显著提升身份稳定性。

2. **下体 / 锁具局部特写**（强烈推荐，但非必须）  
   - 女性下体特写  
   - 男性下体特写（男娘场景）  
   - 贞操锁正面 / 侧面清晰图  

3. **可选增强**  
   - 胸部特写  
   - 表情组（享受、半闭眼、张嘴喘息）  
   - 特定服装细节

## 2. 只有穿衣服图时的写法（用户最常见）

```text
subject_definitions:
<Subject 1> is the feminine-presenting adult male shown in <Picture 1>, used for face, body proportions, clothing and overall identity.

retention_analysis:
<Subject 1> (throughout): fully_preserved - retain exact face, body proportions and clothing.
When lower body is revealed: correctly proportioned male genitals fully enclosed in a metal chastity cage with testicles visible below; the cage remains firmly locked and correctly shaped.
```

关键：即使没有额外 Subject，也要在 retention 里用条件句覆盖“露出后”的解剖与锁具。

## 3. 有局部参考时的完整绑定示例

```text
subject_definitions:
<Subject 1> is the adult character shown in <Picture 1> (character_front_identity), used for face, body proportions, clothing and overall identity.
<Subject 2> is the genital / chastity close-up shown in <Picture 2>, used for accurate male anatomy and chastity cage shape when lower body is visible.

retention_analysis:
<Subject 1> (appears throughout): fully_preserved - retain exact face, body shape, skin and clothing.
<Subject 2> (appears when lower body is visible): fully_preserved - retain exact genital anatomy, proportions and chastity cage shape/details.
```

## 4. 纯文生（无任何参考图）时的应对

- 完全依赖文本三重锁定（summary + 可见瞬间 + 结束状态）
- 把材质、比例、状态写得更具体
- 优先短时长测试，锁定正确版本后再扩展
- 成功率低于有穿着图的情况，但仍可用

## 5. 命名规范

遵循仓库 `reference-assets.md` 的命名与绑定规则：  
建议保存完整文件名 → 1160 素材名称 → 槽位 → 实际图号 → 职责，全部列出。

## 6. 检查清单

- [ ] 是否至少提供了身份主图（穿衣服亦可）？
- [ ] retention 是否覆盖了“露出后”的解剖与道具？
- [ ] 有局部参考时，Subject 职责是否清晰分开？
