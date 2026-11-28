# 扶他 / 混合解剖（Futanari & Mixed Anatomy）

## 核心锁定规则
扶他 = 有女性胸部特征 + 男性生殖器（阴茎+睾丸）同时存在，且归属明确。

必须正向锁定：
```
She has full breasts and a correctly proportioned erect penis with testicles that remain fully present and attached to her body throughout. Do not replace the penis with female-only genitals.
```

## 多扶他 / 混合场景
- 每个角色的解剖独立锁定。
- 使用 “anatomy ownership”：哪根阴茎属于谁，接收角色是谁。
- 暂时被遮挡或进入接收位时，仍保持 PRESENT_LOCKED，不消失、不改变性别特征。

## 推荐写法示例
```
The futanari woman has soft full breasts and a hard erect penis. Her penis remains attached and correctly shaped. She presses her body against the other person while her penis stays fully visible and present.
```

## 常见失败
- 模型自动去掉阴茎变成普通女性 → 多次重复 “penis remains fully present and attached”。
- 阴茎归属混乱 → 明确 “her own penis” / “his penis”。
- 与参考图冲突 → 用局部解剖参考 + retention fully_preserved。
