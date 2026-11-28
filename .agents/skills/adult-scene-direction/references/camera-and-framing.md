# 成人向镜头与构图（整合 xingheFF + WeissGoat 实测）

来源：xingheFF/minimax-h3-NSFW-skill camera-lighting-shot.md + WeissGoat practice.md + 社区实测。

## 1. 默认相机声明（明确内容优先）

```text
The camera holds a static shot; the frame never moves: no cut, no pan, no tilt, no zoom, no push-in, no camera shake and no reframing.
```

静态比任何运动更能保住解剖细节与接触点。只有用户明确要求运动时才加入一次运动（type + amplitude + speed）。

## 2. 景别（Shot Size）

| Shot Size | Preferred Terms | NSFW 用途 |
|-----------|-----------------|----------|
| Wide / Extreme long | wide shot, extreme long shot | 很少用，仅环境 |
| Full / Long | full shot, long shot | 全身站立或后入 |
| Medium | medium shot, mid shot, knee shot | 最通用；动作 + 脸 |
| Medium close-up | medium close-up | 脸 + 上半身 + 插入（推荐默认，需保留面部可读性时） |
| Close-up | close-up | 脸 + 表情焦点 |
| Extreme close-up | extreme close-up | 生殖器细节、眼睛、嘴、液体 |

**规则**：当女性是主要主体时，优先 **medium shot** 或 **medium close-up**。

## 3. 视角（Camera Angle）

### 垂直（V-axis）— 情绪影响最强
- **eye-level / eye level shot** — 默认，最自然平等
- **low angle / from below** — 权力 / 支配感（用户要求时用）
- **high angle / from above** — 脆弱感，清晰看到身体与插入
- **overhead / top-down** — 仅特定构图
- 避免污染词：bird’s eye, worm’s eye, hero view

### 水平（H-axis）
- front view / straight on
- side view / profile
- back view / from behind
- quarter view / 3/4 view / three-quarter view
- over the shoulder (OTS)

### 常见体位推荐组合
- Missionary POV：high angle 或 overhead + medium close-up
- Doggy（第三人称）：side view 或 three-quarter from behind + medium shot
- Cowgirl：front view 或 slight high angle + medium shot
- Standing：side view 或 three-quarter + full / medium shot

## 4. 光线（Lighting）— 四维度

| 维度 | 选项 | NSFW 床戏推荐 |
|------|------|---------------|
| Quality | soft / hard / diffused | soft light, diffused light |
| Direction | front / side / back / top | Top-Left Soft Key（默认）, soft window light from left |
| Color | warm / cool / golden hour | warm soft key light |
| Intensity | bright / dim / low-key / high-key | soft ambient, minimal harsh shadows |

**默认**：Top-Left Soft Key，阴影方向稳定。  
强替代：soft window light, soft ambient lighting, Rembrandt lighting (45°), rim lighting for body separation。

避免冲突组合（harsh midday + soft diffused）。

## 5. 提示词顺序建议

[Angle] → [Shot size] → [Subject & action] → [Lighting] → [Quality]

示例：
```text
medium shot, side view, eye-level, the woman in doggy position..., Top-Left Soft Key, soft light
```

## 6. 高频解剖与动作锚点（NSFW）

优先使用这些具体词（配合精确几何语言）：
- pussy, labia, clitoris, anus, ass, breasts, nipples, penis
- spread pussy, pussy from back, ass grab, spread ass
- thighs, hips, navel, back
- sex from behind, penetration, vaginal, thrusting, looking back, on all fours
- wet, pussy juice, lubrication strands

## 7. 可选镜头品牌 / 焦段味道

仅在用户明确要求特定摄影感时加入：
- Canon + 85mm f/1.2 → soft skin, creamy bokeh
- Leica + 35/50mm → high contrast, documentary
- Nikon wide → high sharpness

对大多数 H3 NSFW 提示词，景别 + 视角 + 光线比品牌更重要。

## 8. 第一人称额外注意

- 双手必须始终可见于画面底部。
- 接触区域优先近景，但保持双手入画。
- 详见 [first-person-intimacy.md](first-person-intimacy.md)。
