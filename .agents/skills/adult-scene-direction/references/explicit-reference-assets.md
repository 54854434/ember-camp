# 成人角色参考资产建议

## 推荐最小资产包

1. **全身 / 身份主图**（必须）  
   文件名示例：`character_front_identity.png`  
   职责：脸、身体比例、整体造型、服装/配饰（如兔耳）

2. **女性下体特写**（强烈推荐）  
   文件名示例：`character_genital_closeup.png`  
   职责：准确的 labia 形状、阴毛分布、皮肤质感、比例

3. **可选增强**  
   - 胸部特写（如果有特殊形状或需要高精度）  
   - 男性生殖器参考（如果画面会出现）  
   - 表情组（享受、半闭眼、张嘴喘息等）

## 绑定写法示例

```text
subject_definitions:
<Subject 1> is the adult woman shown in <Picture 1> (character_front_identity), used for face, body proportions, breasts, overall identity and accessories.
<Subject 2> is the detailed genital area shown in <Picture 2> (character_genital_closeup), used for accurate shape, proportions and details of the female genitals when visible.

retention_analysis:
<Subject 1> (appears throughout): fully_preserved - retain exact face, body shape, skin and accessories.
<Subject 2> (appears when lower body is visible): fully_preserved - retain exact genital anatomy and proportions.
```

## 命名规范

遵循仓库 `reference-assets.md` 的命名与绑定规则：  
建议保存完整文件名 → 1160 素材名称 → 槽位 → 实际图号 → 职责，全部列出。
