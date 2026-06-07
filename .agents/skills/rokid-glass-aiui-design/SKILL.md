---
name: rokid-glass-aiui-design
description: Applies Rokid Glass AIUI visual design rules using the `yodaos-sprite-greenonly` theme and Design Tokens for layout, color, borders, radius, spacing, surfaces, and inputs. Use when creating, modifying, or reviewing AIUI `.ink` pages or visual designs for Rokid Glasses, YodaOS-Sprite, AR glasses UI, wearable UI, or when the user mentions Rokid visual/design specs.
---

# Rokid Glass AIUI Design

## Quick Start

Use this skill together with `aiui-dev` whenever implementing AIUI pages for Rokid Glasses.

1. Use the Ink built-in `yodaos-sprite-greenonly` theme as the default visual baseline for Rokid Glasses.
2. Build visual decisions from Design Tokens first, not hard-coded page-local colors and spacing.
3. Keep app surfaces `480px` wide, with `120px` minimum height and `380px` maximum height before switching to scrolling.
4. Use black surfaces plus Rokid green foreground (`#40ff5e`) for text, borders, key data, and high-priority interactions.
5. Prefer light fills, clear outlines, stable spacing, and text/border brightness changes over shadows, multicolor decoration, or large filled blocks.
6. Reuse card, input, and error-state tokens before inventing component-specific visual values.

## Design Rules

For the detailed source extract, read `references/design-spec.md`.

- Core principles: clarity, hierarchy, brand consistency, simplicity, and themeability.
- Theme mechanism: the host injects the default theme first; app-level `app.wxss`, page styles, and component styles may override tokens while keeping the token structure stable.
- Recommended theme: `yodaos-sprite-greenonly`.
- Layout tokens: `--app-width: 480px`, `--app-height-min: 120px`, and `--app-height-max: 380px`.
- Color tokens: `--color-primary: #40ff5e`, `--color-primary-60: rgba(64, 255, 94, 0.6)`, `--color-primary-40: rgba(64, 255, 94, 0.4)`, `--color-background: #000000`, and `--color-surface: #000000`.
- Text tokens: `--color-text-primary: var(--color-primary)` and `--color-text-secondary: var(--color-primary-60)`.
- Border tokens: `--border-width-thin: 1px`, `--border-width-default: 2px`, `--border-width-strong: 4px`; use `--border-color-default`, `--border-color-muted`, and `--border-color-accent`.
- Radius tokens: use `--radius-sm: 12px` and `--radius-md: 12px`.
- Spacing tokens: use `--spacing-sm: 8px`, `--spacing-md: 12px`, and `--spacing-lg: 18px`.
- Components: use `--card-*`, `--input-*`, and `--error-state-*` tokens for cards, inputs, and error states.
- Visual emphasis: use green text, border opacity, and surface layers for emphasis; avoid complex shadows and multicolor decoration in the single-green glasses context.

## AIUI Implementation Notes

- Prefer using the theme token names directly so AIUI pages inherit host-level visual updates:
  - `--color-primary`
  - `--color-primary-60`
  - `--color-primary-40`
  - `--color-background`
  - `--color-surface`
  - `--color-text-primary`
  - `--color-text-secondary`
  - `--border-width-default`
  - `--radius-md`
  - `--spacing-md`
- Keep `.ink` layouts compact. Avoid scroll-heavy pages unless the task requires browsing a list or history.
- When content exceeds `--app-height-max`, introduce a `scroll-view` rather than expanding the surface without bounds.
- Use `view`, `text`, `button`, `image`, and `scroll-view` in simple flex layouts first. Use grid only where two-dimensional placement is clearer.
- Do not add emoji to UI copy unless the user explicitly asks for it.
- Do not use marketing-style hero layouts. Build the actual wearable interaction surface as the first screen.

## Review Checklist

Before final response or handoff:

- Rokid Glasses pages use `yodaos-sprite-greenonly` token names.
- The main app surface is `480px` wide and stays between `120px` and `380px` tall unless a deliberate scroll layout is used.
- Colors come from `--color-primary`, `--color-primary-60`, `--color-primary-40`, `--color-background`, and `--color-surface`.
- Text uses `--color-text-primary` for primary content and `--color-text-secondary` for descriptions, hints, and placeholders.
- Borders use `1px`, `2px`, or `4px` token widths with default/muted/accent border tokens.
- Corners use `12px` token radius for compact controls and standard containers.
- Spacing uses the `8px`, `12px`, and `18px` token scale.
- Cards, inputs, and error states reuse the matching component tokens.
- Important states are expressed through text brightness, border strength, or surface emphasis rather than shadows or decorative colors.
