# 解剖准确性写法（纯文本 + 参考）

## 目标
在不依赖或仅依赖有限参考图的情况下，尽量让模型生成正确比例、形状清晰、不融合、不穿模的男女生殖器。

## 纯文本强化原则

1. **在可见的瞬间明确写出结构**  
   不要假设模型知道“正常”长什么样。必须在手触碰到或镜头能看清的时候写清楚。

2. **使用精确正向描述**  
   推荐表达（英文正文中使用）：
   - female: `accurately shaped natural female genitals with visible labia and dark pubic hair`, `correct proportions`, `realistic anatomy without distortion or fusion`
   - male: `correctly proportioned erect penis`, `natural shape and vein detail`, `accurate glans and shaft proportions`

3. **接触与响应分开写**  
   模板：  
   `The hand reaches between her legs and makes clear contact with her natural female genitals. The genitals are correctly shaped with visible labia... The soft flesh responds naturally to the touch without distortion.`

4. **避免同时发生过多动作**  
   揉胸 + 下探 + 身体贴合 + 亲吻同时进行时，下体细节最容易崩。优先保证接触那一刻的描述清晰，其他动作为辅。

5. **形变要自然**  
   用 `soft natural deformation`、`visible but realistic compression`、`flesh yields naturally under pressure`，少用 `heavily deforming`、`extreme jiggle`。

## 有局部参考时的写法

在 `subject_definitions` 中分开定义：

```text
<Subject 1> is the adult woman shown in <Picture 1> (bunny_girl_front_identity), used for face, body proportions, breasts, bunny ears and overall identity.
<Subject 2> is the detailed genital close-up shown in <Picture 2> (bunny_girl_genital_closeup), used for accurate shape, proportions, skin texture and hair of the female genitals when visible.
```

在 `retention_analysis` 中：

```text
<Subject 2> (appears when lower body is visible): fully_preserved - retain exact shape, proportions and details of the genitals.
```

在 `detailed_description` 对应位置引用：

```text
... makes clear contact with her natural female genitals matching <Subject 2>, which remain accurately shaped with correct proportions...
```

## 男性身体出现时

同样原则：单独定义或在可见时明确写 `correctly proportioned erect penis with natural shape`，并描述接触方式与响应。

## 检查清单（成稿前）

- [ ] 下体第一次清楚可见时，是否写了正确结构与比例？
- [ ] 接触因果是否清楚（谁碰到哪里 → 正确形状如何响应）？
- [ ] 是否避免了同帧过多竞争动作？
- [ ] retention 是否覆盖了关键解剖部位？
