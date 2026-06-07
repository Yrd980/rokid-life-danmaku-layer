# Rokid AIUI Visual Design Spec Extract

Source page:
https://js.rokid.com/AIUI/design/visual

This page defines AIUI visual design as a theme-driven Design Tokens system for Rokid AR experiences. The current recommended baseline for Rokid Glasses is the Ink built-in `yodaos-sprite-greenonly` theme.

## Core Principles

- Clarity: keep text readable across changing light, transparent display backgrounds, and viewing distances.
- Hierarchy: use surfaces, borders, text levels, and spacing to build stable information structure.
- Brand consistency: preserve Rokid's green visual language across pages and components.
- Simplicity: avoid occupying the user's main field of view with unnecessary decoration.
- Themeability: express visual rules through Design Tokens so the host and app can share or override a stable theme layer.

## Theme Mechanism

- AIUI visual design should be organized with CSS custom properties, also called Design Tokens.
- The host injects the theme first as the default token layer.
- Applications may override variables in `app.wxss`, page styles, and component-local styles.
- Token structure should stay stable across themes so components do not need markup changes when switching themes.

## Recommended Theme

Use `yodaos-sprite-greenonly` for Rokid Glasses single-green display scenarios.

The theme uses black backgrounds and green foregrounds to maintain contrast, recognition, and comfort on single-green display hardware.

## Layout Tokens

| Token | Usage | Value |
| --- | --- | --- |
| `--app-width` | Default width for floating surfaces and card-like agent interfaces. | `480px` |
| `--app-height-min` | Minimum height for compact surfaces or short information cards. | `120px` |
| `--app-height-max` | Maximum recommended height before switching to scrolling. | `380px` |

Use this range as the default surface size model. When content exceeds the maximum height, prefer a scroll layout instead of unbounded vertical expansion.

## Color Tokens

| Token | Usage | Value |
| --- | --- | --- |
| `--color-primary` | Brand color and core accent for titles, key data, and high-priority interactions. | `#40ff5e` |
| `--color-primary-60` | Medium emphasis for secondary text, borders, and softened emphasis layers. | `rgba(64, 255, 94, 0.6)` |
| `--color-primary-40` | Low emphasis for light fills, highlighted surfaces, and background hint layers. | `rgba(64, 255, 94, 0.4)` |
| `--color-background` | Page-level background for transparent display environments. | `#000000` |
| `--color-surface` | Base surface background for cards, panels, and containers. | `#000000` |
| `--color-surface-highlight` | More emphasized surface layer for highlighted cards and demo blocks. | `rgba(64, 255, 94, 0.4)` |
| `--color-text-primary` | Primary text for headings, body text, and high-contrast labels. | `#40ff5e` |
| `--color-text-secondary` | Secondary text for descriptions, hints, placeholders, and weaker information. | `rgba(64, 255, 94, 0.6)` |

Use green for titles, key data, interaction borders, and highlighted states. Use transparent green layers for weakened information, panels, and input areas.

## Border, Radius, And Spacing Tokens

### Border Width

| Token | Usage | Value |
| --- | --- | --- |
| `--border-width-thin` | Lightweight outlines, dividers, and input borders. | `1px` |
| `--border-width-default` | Cards, ordinary panels, and most content containers. | `2px` |
| `--border-width-strong` | Strong outlines or key states. | `4px` |

### Border Color

| Token | Usage | Value |
| --- | --- | --- |
| `--border-color-default` | Default neutral border for most outlines. | `var(--color-primary-60)` |
| `--border-color-muted` | Softer border for dividers and weak separators. | `var(--color-primary-40)` |
| `--border-color-accent` | Accent border close to the theme primary color. | `var(--color-primary)` |

### Radius

| Token | Usage | Value |
| --- | --- | --- |
| `--radius-sm` | Inputs and compact elements. | `12px` |
| `--radius-md` | Cards and most containers. | `12px` |

### Spacing

| Token | Usage | Value |
| --- | --- | --- |
| `--spacing-sm` | Compact gaps, icon spacing, and small padding. | `8px` |
| `--spacing-md` | Standard component padding and regular spacing. | `12px` |
| `--spacing-lg` | Page padding, section gaps, and relaxed layouts. | `18px` |

The visual direction is light fills, clear outlines, and stable spacing. Prefer these over shadow-heavy treatments in transparent AR display environments.

## Component Tokens

### Card

| Token | Usage | Value |
| --- | --- | --- |
| `--card-padding` | Default card body padding. | `var(--spacing-md)` |
| `--card-border-width` | Default card border width. | `var(--border-width-default)` |
| `--card-border-color` | Default card border color. | `var(--border-color-default)` |
| `--card-cover-height` | Default card cover or media header height. | `180px` |

### Input

| Token | Usage | Value |
| --- | --- | --- |
| `--input-background-color` | Default input background. | `rgba(64, 255, 94, 0.08)` |
| `--input-border-color` | Default input border color. | `var(--border-color-default)` |
| `--input-placeholder-color` | Placeholder text color. | `var(--color-text-secondary)` |
| `--input-padding-y` | Vertical input padding. | `10px` |
| `--input-padding-x` | Horizontal input padding. | `14px` |

### Error State

| Token | Usage | Value |
| --- | --- | --- |
| `--error-state-background` | Error container background. | `rgba(64, 255, 94, 0.08)` |
| `--error-state-border-color` | Error container border color. | `var(--border-color-muted)` |
| `--error-state-text-color` | Error text color. | `var(--color-text-primary)` |

Component tokens avoid repeatedly re-deciding visual details for cards, inputs, error hints, chart containers, and similar surfaces.

## Theme CSS Baseline

The source page references `packages/ink/themes/yodaos-sprite-greenonly.theme.css` as the baseline:

```css
:root {
  --app-width: 480px;
  --app-height-min: 120px;
  --app-height-max: 380px;

  --color-primary: #40ff5e;
  --color-primary-60: rgba(64, 255, 94, 0.6);
  --color-primary-40: rgba(64, 255, 94, 0.4);
  --color-background: #000000;
  --color-surface: #000000;
  --color-surface-highlight: var(--color-primary-40);
  --color-text-primary: var(--color-primary);
  --color-text-secondary: var(--color-primary-60);

  --border-width-thin: 1px;
  --border-width-default: 2px;
  --border-width-strong: 4px;
  --border-color-default: var(--color-primary-60);
  --border-color-muted: var(--color-primary-40);
  --border-color-strong: var(--color-primary);
  --border-color-accent: var(--color-primary);

  --radius-sm: 12px;
  --radius-md: 12px;

  --spacing-sm: 8px;
  --spacing-md: 12px;
  --spacing-lg: 18px;

  --card-padding: var(--spacing-md);
  --card-border-width: var(--border-width-default);
  --card-border-color: var(--border-color-default);

  --input-background-color: rgba(64, 255, 94, 0.08);
  --input-border-width: var(--border-width-thin);
  --input-border-color: var(--border-color-default);
  --input-placeholder-color: var(--color-text-secondary);
  --input-padding-y: 10px;
  --input-padding-x: 14px;
  --input-radius: var(--radius-sm);
}
```

## Design Recommendations

- Start from tokens instead of writing page-local color and spacing constants.
- Use `yodaos-sprite-greenonly` as the visual baseline for Rokid Glasses.
- Express emphasis through border strength, text brightness, and surface hierarchy.
- Avoid complex shadows and multicolor decoration.
- Reuse `card`, `input`, and `error-state` tokens before introducing new component-specific values.
