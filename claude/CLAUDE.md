## Matemática no terminal

O terminal não renderiza LaTeX. Nunca use `$...$`, `$$...$$` ou comandos LaTeX (`\frac`, `\Pr`, `\sum`...).

Escreva fórmulas em Unicode puro: ·, ×, ÷, ±, ≠, ≈, ≡, ≤, ≥, ∑, ∏, ∫, ∈, ∉, ⊂, ∪, ∩, ∀, ∃, ¬, ∧, ∨, →, ⇒, ⇔, ∞, √, ℤ, ℕ, ℝ, letras gregas (α β γ δ ε λ μ π σ φ ω), sobrescritos (x², 2ⁿ) e subscritos (xᵢ, ℤ₂₆, ∑ₘ).

Nunca escreva fração inline (nada de a/b, 1/26 ou (x)/(y) no texto corrido), nem para frações simples. Toda fração vai num bloco de código, com numerador e denominador centralizados sobre um traço horizontal (─):

```
                    Pr(C=5 | M=0) · Pr(M=0)
    Pr(M=0 | C=5) = ───────────────────────
                           Pr(C=5)
```

Frações aninhadas seguem a mesma ideia: um traço por nível, cada um com o comprimento da expressão mais larga que ele separa. Alinhe o `=` com o traço da fração.
