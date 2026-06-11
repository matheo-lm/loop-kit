---
name: design
description: Use when building or refining UI components, pages, or visual design.
---

# design

Frontend design guidelines adapted from Anthropic's frontend-design skill.

## when to use
- building or restyling any component
- creating new layouts, modals, or screens
- refining visual polish, motion, or typography

## design thinking
Before coding, understand the context and commit to a clear aesthetic direction:
- **Purpose**: What does this interface solve? Who uses it?
- **Tone**: refined minimalism. intentional. never chaotic or loud.
- **Differentiation**: what makes this unforgettable? extreme refinement. every pixel intentional.

## frontend aesthetics guidelines

### typography
- Choose fonts that fit the project's character. Avoid generic system fonts, Inter, Roboto, Arial.
- Pair a distinctive display font with a refined body font.
- Use CSS custom properties for consistent font stacks.

### color & theme
- Commit to a cohesive palette via CSS custom properties.
- Dominant colors with sharp accents outperform timid palettes.
- Keep contrast ratios accessible (WCAG AA minimum).

### motion
- Use animation for purposeful feedback, not decoration.
- Always respect `prefers-reduced-motion`.
- Keep durations short (150-300ms micro-interactions).

### spatial composition
- Generous negative space. Controlled density. Intentional alignment.
- Avoid visual clutter. Every element earns its place.

### avoid these cliches
- Purple gradients on dark backgrounds
- Generic sans-serif everywhere
- Cookie-cutter card layouts with rounded corners + shadow
- Over-engineered animations that serve no purpose
- Trend-driven aesthetics (glassmorphism, neubrutalism)
