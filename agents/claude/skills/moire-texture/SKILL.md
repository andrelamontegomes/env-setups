---
name: moire-texture
version: 1.0.0
description: |
  Apply moiré and interference textures to web interfaces. Use when integrating
  texture files (from texturelabs.org, texturefabrik.com, or similar) into a
  frontend as backgrounds, overlays, or surface treatments. Covers what moiré
  is in graphic design, how to pick the right texture file for a use case, and
  how to apply it cleanly with CSS backgrounds, blend modes, masks, filters,
  and SVG/Canvas overlays. Includes performance, color treatment, and
  accessibility guidance.
license: MIT
compatibility: claude-code opencode
allowed-tools:
  - Read
  - Write
  - Edit
  - Grep
  - Glob
  - Bash
  - AskUserQuestion
---

# Moiré texture: design language and frontend integration

You help frontend developers integrate moiré and interference texture files into web UIs. The textures themselves come from libraries like **texturelabs.org**, **texturefabrik.com**, or similar — typically high-resolution PNG/JPG files of grain, halftone, line, dot, and interference patterns. Your job is not to generate the pattern from scratch but to apply a provided file well.

## What moiré is

Moiré is an **interference pattern** that emerges when two similar repeating patterns overlap with a small offset in angle, scale, or position. The eye perceives a third, larger pattern that exists in neither source. The provided texture file usually already contains the interference baked in — your task is to integrate it without losing what makes it readable.

In design, moiré signals editorial print, risograph, op-art, post-digital, Y2K, and "made by humans" aesthetics. It is decorative texture, not content.

### When to use it

**Good fits:** hero sections, splash pages, posters, cards, accent panels, brand backgrounds, dividers, large-type backdrops.

**Avoid behind:** body copy, dashboards, dense reading interfaces. Moiré interferes with text legibility — both literally (low local contrast) and perceptually (eye strain).

## Texture file vocabulary

Texture libraries typically ship files in these flavors. Knowing which you have determines how to apply it.

| Flavor | Looks like | Typical file form | How to apply |
|---|---|---|---|
| **Halftone / dot screen** | Regular dot grid, often with moiré already visible | Black-on-transparent PNG, or black-on-white JPG | Overlay with `multiply` or `mix-blend-mode: multiply` |
| **Line / stripe** | Parallel lines, sometimes wavy or curved | Black-on-transparent PNG | Overlay with `multiply`, or use as `mask-image` to reveal color underneath |
| **Interference / moiré** | Banded curved interference, often hypnotic | Grayscale JPG | Overlay with `multiply`, `overlay`, or `soft-light` |
| **Grain / noise** | Fine speckled texture, often subtle | Grayscale JPG (large) | Overlay with `overlay` or `soft-light` at low opacity |
| **Distortion / scan** | Photocopier streaks, scanner artifacts | Grayscale JPG | Overlay with `multiply` or `screen` depending on polarity |
| **Paper / fiber** | Subtle paper grain | JPG | Overlay with `multiply` at low opacity |

Two questions to ask of any new file before using it:

1. **Polarity** — is the *texture* dark on light (use `multiply`) or light on dark (use `screen`)? Look at the file in a viewer.
2. **Transparency** — does the PNG have an alpha channel, or is it on a white background? Transparent PNGs composite with anything; white-background JPGs need `multiply` to "drop out" the white.

## Choosing the right file

When integrating a texture, match the file to the surface:

- **Hero background** → large file (2000–4000px), seamless or oversized to cover viewport
- **Card or panel overlay** → mid-size (1000–2000px), pick one with even distribution so cropping reads consistently
- **Subtle paper/grain over the whole page** → small tileable file (500–1000px) repeated
- **Behind a single piece of large type** → choose a file whose pattern frequency contrasts with the type weight (fine grain behind bold display type; bold halftone behind thin type)

If the source library offers multiple resolutions, take the largest the page can afford and let CSS scale down. Scaling up a small texture introduces real moiré of its own — usually unwanted.

## Implementation

### 1. Plain background image

The simplest case: drop the file in as a background.

```css
.surface {
  background-color: #f5f1ea;
  background-image: url('/textures/moire-01.png');
  background-size: cover;        /* or specific px for tiled */
  background-position: center;
  background-repeat: no-repeat;  /* or repeat for tileable files */
}
```

Use `cover` for a hero, `repeat` with a fixed `background-size` for a tileable grain. If the file has its own background color baked in (white-background JPG), use a blend mode (next section).

### 2. Overlay with blend modes

The most common pattern: keep the texture as a separate layer over your real content surface, blended in.

```html
<div class="panel">
  <div class="panel__content">...real content...</div>
  <div class="panel__texture" aria-hidden="true"></div>
</div>
```

```css
.panel { position: relative; isolation: isolate; background: #ffe14a; }
.panel__texture {
  position: absolute; inset: 0;
  background: url('/textures/halftone-dots.jpg') center / cover no-repeat;
  mix-blend-mode: multiply;        /* drops out the white, keeps black dots */
  pointer-events: none;
  opacity: 0.85;                   /* dial back to taste */
}
```

Blend mode quick guide for greyscale textures on a colored surface:

- **`multiply`** — texture darkens. White areas of the texture vanish; black areas show as the surface color darkened. Default for halftone/line files.
- **`screen`** — texture lightens. Black areas vanish; white areas brighten. Use when the texture is light-on-dark.
- **`overlay`** — boosts contrast and color. Useful for grain over photography.
- **`soft-light`** — subtle version of `overlay`. Good for fine grain.
- **`difference`** — color-flips. Striking, abrasive — good for editorial moments, bad for everyday UI.

`isolation: isolate` on the parent stops the blend from bleeding into ancestors. Always set it.

### 3. Tint a grayscale texture with a color

To recolor a black-and-white texture, put a colored layer underneath and use `multiply`. The texture acts as a darkness map over your chosen color.

```css
.tinted {
  position: relative; isolation: isolate;
  background: #2e4bff;             /* the tint */
}
.tinted::after {
  content: ""; position: absolute; inset: 0;
  background: url('/textures/moire-bands.jpg') center / cover;
  mix-blend-mode: multiply;
  pointer-events: none;
}
```

For a two-color print/risograph look, stack two `::before` and `::after` layers with two textures (or the same texture rotated/offset), each over a different solid color, blended with `multiply`.

### 4. Use the texture as a mask

`mask-image` reveals the layer beneath only where the mask is opaque. This is the cleanest way to apply a moiré pattern as a shape rather than as a tint — letting a color, gradient, or even a photograph show through the texture's bright areas.

```css
.masked {
  background: linear-gradient(135deg, #ff3d7f, #ffe14a);
  -webkit-mask-image: url('/textures/lines.png');
          mask-image: url('/textures/lines.png');
  -webkit-mask-size: cover;
          mask-size: cover;
  -webkit-mask-repeat: no-repeat;
          mask-repeat: no-repeat;
}
```

`mask-image` requires a texture with real alpha (PNG with transparency, or an SVG). A white-background JPG will not mask — it will appear as a solid filled rectangle.

### 5. Layer multiple textures

Stack background images on a single element, or use multiple absolutely-positioned overlay layers. Multiple `background-image` values compose top-to-bottom (first listed is on top).

```css
.layered {
  background:
    url('/textures/grain.png') center / 800px repeat,
    url('/textures/moire-bands.jpg') center / cover no-repeat,
    #ffe14a;
}
```

When you need different blend modes per layer, use `background-blend-mode` (one mode per layer, comma-separated):

```css
.layered {
  background:
    url('/textures/grain.png'),
    url('/textures/moire-bands.jpg'),
    #ffe14a;
  background-size: 800px, cover, auto;
  background-repeat: repeat, no-repeat, no-repeat;
  background-blend-mode: overlay, multiply, normal;
}
```

`background-blend-mode` blends layers *within the same element*. `mix-blend-mode` blends an element *with what's behind it*. Both have their place.

### 6. Animate it (sparingly)

The texture file is static, but the overlay element can move. The cheapest, most accessible technique: a slow `transform: translate` on the overlay tied to scroll or a long-period animation.

```css
@keyframes drift {
  from { transform: translate(0, 0); }
  to   { transform: translate(-40px, -30px); }
}
.panel__texture {
  animation: drift 18s linear infinite alternate;
  will-change: transform;
}

@media (prefers-reduced-motion: reduce) {
  .panel__texture { animation: none; }
}
```

Keep the period long (10s+). Fast-moving moiré is the most likely thing in a UI to make a user feel unwell.

## File format and performance

- **PNG with alpha** for textures meant to overlay on arbitrary backgrounds. Larger files; lossless.
- **JPG** for grayscale grain or interference on a known background color. Smaller files; lossy but usually fine for texture.
- **WebP / AVIF** are strictly better than PNG/JPG for size and quality when browser support is sufficient. Convert at build time and use `<picture>` for fallbacks if needed.
- **SVG** only if the file ships as SVG (rare for moiré — vectors don't capture grain).
- **Compress aggressively.** Texture detail is forgiving; 60–75% JPG quality is usually invisible.
- **Tile when possible.** A 600×600 tileable grain repeats cheaply across a viewport. A 4000×3000 non-tileable moiré is one big paint.
- **Avoid loading more than ~500KB of textures per route.** Above that, lazy-load: set the overlay's `background-image` only when its parent enters the viewport (IntersectionObserver).
- **`will-change: transform`** on animated overlay layers promotes them to their own compositor layer and prevents re-rasterization on each frame.
- **Don't combine `mix-blend-mode` with `position: fixed`** in iOS Safari without testing — historically buggy. Prefer `position: absolute` inside an `isolation: isolate` container.

## Color treatment

Texture libraries usually ship grayscale. To get color, layer underneath (as in section 3) or use CSS filters on the texture:

```css
.panel__texture {
  background: url('/textures/moire.jpg') center / cover;
  filter: hue-rotate(30deg) saturate(1.2);
  /* or: filter: invert(1); to flip polarity */
}
```

For risograph two-color looks, the standard recipe is:

1. Solid color A as the base layer
2. Texture 1 with `mix-blend-mode: multiply` over a color B layer
3. Texture 2 (often the same file, offset/rotated) with `mix-blend-mode: multiply` over the whole thing

The result reads like two ink runs on paper.

## Accessibility

Texture is decoration — treat it as such.

- **Mark the overlay** `aria-hidden="true"` and `pointer-events: none` so it stays out of the accessibility tree and out of click targets.
- **Never place body text on top of a busy moiré.** If the design demands text over texture, use a translucent panel (`backdrop-filter: blur(2px)` and a flat fill) or restrict text to large display sizes.
- **Test contrast against the worst-case texture spot**, not the surface base color. WCAG contrast is measured locally; a dark stripe of texture can push contrast below threshold even when the average passes.
- **Respect `prefers-reduced-motion`** for any animated overlays. Animated moiré can trigger photosensitive epilepsy and vestibular issues — give it a full `animation: none` under that media query, not just a slower variant.
- **Respect `prefers-contrast: more`** for users who need higher contrast. Hide or reduce texture opacity in that mode.

```css
@media (prefers-contrast: more) {
  .panel__texture { opacity: 0; }
}
```

## Decision flow

When a user asks to "add a moiré texture":

1. **Confirm the texture file exists** (path, format, resolution). If not, ask which library and which file.
2. **Identify polarity and transparency** of the file to pick the blend mode.
3. **Identify the surface**: full-page background, panel, card, behind type? This sets file size, tiling, and whether to use `background-image` directly or an overlay element.
4. **Decide color treatment**: monochrome, tinted via underlying color + multiply, or risograph-style two-layer stack.
5. **Confirm motion**: static (preferred) or animated (with reduced-motion fallback).
6. **Check accessibility**: text contrast, `aria-hidden`, reduced-motion, reduced-transparency.

## Common failure modes

- **Texture appears as a solid white/black rectangle.** The file is a JPG with a baked background; you forgot `mix-blend-mode: multiply` (or `screen`).
- **Texture looks washed out.** Wrong blend mode (e.g., `overlay` where `multiply` was wanted), or opacity is too low. Try `multiply` at full opacity first, then back off.
- **Texture looks pixelated / has new unwanted moiré.** You're scaling up a small file. Use a larger source, or `image-rendering: pixelated` if pixelated is the intent.
- **Visible seams when tiling.** The file is not seamless. Either source a tileable variant or use a single oversized non-tiling background with `background-size: cover`.
- **Blend mode bleeds into ancestor.** Missing `isolation: isolate` on the parent.
- **Animation stutters.** Add `will-change: transform` to the overlay. If still bad, the texture file is too large — downscale.
- **Looks great in Chrome, broken in Safari.** Almost always `mix-blend-mode` + `position: fixed`, or `mask-image` without the `-webkit-` prefix.

## Reference

- texturelabs.org — large free texture library (grain, halftone, scan, distortion)
- texturefabrik.com — print-style textures, halftones, paper, dust
- MDN: `mix-blend-mode`, `background-blend-mode`, `mask-image`, `isolation`
- WCAG 2.2 — contrast and non-text contrast guidelines for textured surfaces
