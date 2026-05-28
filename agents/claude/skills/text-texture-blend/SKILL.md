---
name: text-texture-blend
version: 1.0.0
description: |
  Blend text into a textured background on the frontend so it reads as printed,
  stamped, or painted onto the surface rather than floating above it. Covers
  the three stacked SVG filter effects that sell the illusion — turbulent
  displacement of the text edge, a displacement map driven by the actual
  texture, and matching noise inside the text fill — plus the off-white /
  off-black color shift that pulls the result out of the uncanny valley.
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

# Text-into-texture: making type look like it lives on the surface

You help frontend developers blend text into a textured background so the type reads as part of the surface — printed, silkscreened, embossed, photocopied, painted — rather than a clean vector sitting on top of a picture. This is the trick that separates "I put text over a noisy JPG" from "this looks like it came off a press."

The default web rendering of `<h1>` over a textured `background-image` always betrays itself: a perfectly crisp anti-aliased glyph on top of organic grain. The eye reads the inconsistency immediately. Blending well is **all about the details** — three stacked effects, each handling a different scale of the illusion.

## The three stacked effects

You need all three. Each one fixes a tell that the other two leave behind.

### 1. Turbulent displace — break the perfect edge

A laser-printed or letterpressed edge is never straight. Fibers in the paper catch ink, toner clumps, the press is slightly off-register. `feTurbulence` + `feDisplacementMap` simulates this by generating low-frequency noise and using it to push the glyph's pixels around by a few units.

```html
<svg width="800" height="200">
  <defs>
    <filter id="rough-edge" x="-5%" y="-5%" width="110%" height="110%">
      <feTurbulence type="fractalNoise" baseFrequency="0.02 0.04"
                    numOctaves="2" seed="3" result="noise"/>
      <feDisplacementMap in="SourceGraphic" in2="noise"
                         scale="3" xChannelSelector="R" yChannelSelector="G"/>
    </filter>
  </defs>
  <text x="40" y="140" font-family="Inter, sans-serif" font-weight="900"
        font-size="140" fill="#1a1a1a" filter="url(#rough-edge)">
    HELLO
  </text>
</svg>
```

What each knob does:

- **`baseFrequency`** — controls how "wiggly" the displacement is. Low values (0.01–0.03) give wide organic waves like wet ink. Higher values (0.1–0.3) give jittery, photocopied edges. Two values (`"0.02 0.04"`) let you bias horizontal vs vertical.
- **`numOctaves`** — adds detail. 1 is smooth, 4+ is chaotic. 2 is the sweet spot for most print looks.
- **`seed`** — change to get a different pattern with the same parameters.
- **`scale`** — how many pixels each glyph point can move. 1–3 for subtle, 5–10 for visibly distressed, 20+ for "barely legible art piece."
- **`type="fractalNoise"`** — softer, cloud-like. Use `"turbulence"` for harder, more chaotic noise (closer to halftone artifacts).

Keep `scale` proportional to font size — a 3px displacement is invisible on a 140px headline and shreds a 16px caption.

### 2. Displacement map — let the surface push the type around

The texture itself should warp the type, so the glyph follows the bumps and grain of the surface. This is the most important effect for selling "printed onto" rather than "rendered above." Same `feDisplacementMap` primitive, but `in2` is the actual texture image, not generated noise.

```html
<svg width="800" height="200">
  <defs>
    <filter id="surface-warp" x="-5%" y="-5%" width="110%" height="110%">
      <feImage href="/textures/paper-grain.jpg" result="surface"
               preserveAspectRatio="xMidYMid slice"
               x="0" y="0" width="800" height="200"/>
      <feDisplacementMap in="SourceGraphic" in2="surface"
                         scale="4" xChannelSelector="R" yChannelSelector="G"/>
    </filter>
  </defs>
  <text x="40" y="140" font-family="Inter, sans-serif" font-weight="900"
        font-size="140" fill="#1a1a1a" filter="url(#surface-warp)">
    HELLO
  </text>
</svg>
```

Notes:

- The `feImage` must use the same dimensions as the visible filter region or you get cropping artifacts. Setting `x/y/width/height` explicitly is safer than relying on inheritance.
- `xChannelSelector` / `yChannelSelector` pick which color channels drive horizontal vs vertical displacement. For a grayscale texture, R, G, and B all carry the same data — pick any two different channels (R/G is fine) so x and y aren't perfectly correlated, otherwise the displacement is diagonal-only.
- For a really tight effect, the texture file used here should be **the same file** (or a tiled version of) the one used as the background. Mismatched displacement maps and backgrounds give a vertiginous "two surfaces" feel.

### 3. Noise inside the text — match the grain

Even with rough edges and warped position, a flat-fill text on a grainy background still pops out because the fill is *cleaner* than its surroundings. The trick: punch the texture (or noise that matches it) through the inside of the glyph.

The simplest version uses `mix-blend-mode` and the same texture as the background, layered over the text:

```html
<div class="poster">
  <h1 class="poster__title">HELLO</h1>
  <div class="poster__grain" aria-hidden="true"></div>
</div>
```

```css
.poster {
  position: relative;
  isolation: isolate;
  background: #ede4d1 url('/textures/paper-grain.jpg') center / cover;
}
.poster__title {
  font: 900 140px/1 Inter, sans-serif;
  color: #1a1a1a;
  filter: url(#rough-edge) url(#surface-warp); /* effects 1 + 2 */
}
.poster__grain {
  position: absolute; inset: 0;
  background: url('/textures/paper-grain.jpg') center / cover;
  mix-blend-mode: overlay;   /* or soft-light for subtler */
  opacity: 0.6;
  pointer-events: none;
  z-index: 1;
}
```

The overlay sits above everything, including the text, so the same grain that's on the paper is also on top of the glyphs. The text now lives at the same "depth" as the surface.

Alternatives when overlaying the whole page isn't desirable:

- **Pattern fill via SVG.** Define a `<pattern>` with the texture and use `fill="url(#paperPattern)"` on the `<text>`. This confines the noise to the glyphs.
- **Background-clip text.** `background-image: url('/textures/...'); -webkit-background-clip: text; color: transparent;` paints the texture inside the text shape. Combine with a darkening underlay if the texture is too light.
- **SVG `feTurbulence` inside the filter.** Generate noise in the filter graph and `feComposite ... operator="in"` it with `SourceGraphic` to confine noise to the text shape. Keeps everything in one filter, no extra DOM.

```html
<filter id="grainy-fill">
  <feTurbulence type="fractalNoise" baseFrequency="0.9" numOctaves="2" result="grain"/>
  <feComposite in="grain" in2="SourceGraphic" operator="in" result="grainInGlyph"/>
  <feBlend in="SourceGraphic" in2="grainInGlyph" mode="multiply"/>
</filter>
```

## Stacking the filters

CSS lets you chain SVG filters by listing them. Order matters — displacement is applied to whatever comes in, so put grain-injection last (or it gets pushed around by the surface warp, which can look great or terrible depending on intent).

```css
.poster__title {
  filter:
    url(#rough-edge)      /* 1. break the edge */
    url(#surface-warp)    /* 2. warp by surface */
    url(#grainy-fill);    /* 3. grain inside */
}
```

If you want them all in one filter graph (slightly more efficient, single rasterization pass), compose them in a single `<filter>` element with `result` / `in` plumbing:

```html
<filter id="printed-text" x="-10%" y="-10%" width="120%" height="120%">
  <!-- 1. rough edge -->
  <feTurbulence type="fractalNoise" baseFrequency="0.02 0.04"
                numOctaves="2" seed="3" result="edgeNoise"/>
  <feDisplacementMap in="SourceGraphic" in2="edgeNoise"
                     scale="3" xChannelSelector="R" yChannelSelector="G"
                     result="rough"/>

  <!-- 2. surface warp -->
  <feImage href="/textures/paper-grain.jpg" result="surface"
           x="0" y="0" width="800" height="200"
           preserveAspectRatio="xMidYMid slice"/>
  <feDisplacementMap in="rough" in2="surface"
                     scale="4" xChannelSelector="R" yChannelSelector="G"
                     result="warped"/>

  <!-- 3. grain inside the glyph -->
  <feTurbulence type="fractalNoise" baseFrequency="0.9" numOctaves="2" result="fillGrain"/>
  <feComposite in="fillGrain" in2="warped" operator="in" result="grainShape"/>
  <feBlend in="warped" in2="grainShape" mode="multiply"/>
</filter>
```

## The off-white / off-black shift

Pure `#ffffff` and `#000000` are the loudest tells that a layout was assembled in a browser rather than printed. No real ink is pure black; no real paper is pure white. Even a hex bump of 10–20 units makes the result feel material.

| Use case | Don't | Use instead |
|---|---|---|
| "White" paper | `#ffffff` | `#f5f1ea`, `#efe8d8`, `#ece4d3` (warm) or `#eef0f2` (cool) |
| "Black" ink on light surface | `#000000` | `#1a1a1a`, `#1c1814`, `#211c17` (warm) |
| "White" ink on dark surface | `#ffffff` | `#f0ece1`, `#e8e4d6` |
| "Black" background | `#000000` | `#0a0908`, `#10110e` |

The bias toward warm off-black/off-white matters when the texture itself is paper-toned. If the surface is cyan or magenta (risograph), bias the off-black toward the *complement* — a deep navy text on cyan paper, a deep maroon on pink paper, never #000.

For added realism, vary the text fill slightly per glyph or per word using `<tspan fill="...">` with hex values within a few units of each other. Real ink absorption varies.

## When to use which technique

| Goal | Effect stack |
|------|---|
| **Newspaper / offset print** | 1 (light, scale 1–2) + 3 (fine grain) |
| **Risograph** | 1 (moderate) + 2 (with halftone texture) + 3 (coarse grain); two color layers, slightly offset |
| **Photocopier / xerox** | 1 (heavy, high frequency, `type="turbulence"`) + 3 (harsh grain) |
| **Letterpress / embossed** | 1 (very light) + 2 (driven by paper texture) + 3 (fine grain) + subtle inner shadow |
| **Spray paint / stencil** | 1 (heavy, low frequency) + 3 (heavy grain + dropouts via `feComponentTransfer`) |
| **Worn signage / faded** | All three + `feComponentTransfer` to crush the alpha at the edges |
| **Pure debossed-into-surface** | Use the texture itself as the text fill via background-clip; skip displacement |

## Performance and gotchas

- **SVG filters are expensive.** A complex filter on a large text element re-rasterizes the glyph every paint. For static hero text, this is fine. For text that moves or animates, profile it.
- **`feImage` with an external URL is the slowest primitive.** Inline the texture as a base64 data URI for hero text, or use a small dedicated texture for the displacement map (it doesn't need to be high-res — it just needs to vary).
- **The filter region default is too small.** Always set `x="-10%" y="-10%" width="120%" height="120%"` on the `<filter>` or displaced pixels get clipped at the bounding box.
- **Safari quirks.** `feImage` with `href` (no `xlink:`) works in modern Safari but older versions need `xlink:href`. `feTurbulence` is consistent across browsers. `feDisplacementMap` is consistent. `mix-blend-mode` + SVG filters together occasionally trip Safari — test.
- **Animated `feTurbulence`.** You can animate `baseFrequency` or `seed` with SMIL or by replacing the filter via JS. Looks like flickering film grain. Respect `prefers-reduced-motion` — flicker is a vestibular hazard.
- **Accessibility.** The text is still selectable, copyable, and read by screen readers — these effects don't break the DOM. But check contrast *after* the filter is applied; aggressive displacement can drop a glyph's effective stroke width below WCAG thresholds on small sizes. Apply this technique to display sizes (typically 48px+).
- **Don't apply to body copy.** The whole point of this is texture for big type. At paragraph sizes, all three effects make text harder to read and don't read as "printed" — they read as broken.

## Decision flow

When a user wants to blend text into a textured background:

1. **Get the texture file.** What's the surface? Paper, halftone, risograph, scan, grain? This dictates the effect stack and the displacement-map source.
2. **Confirm size.** Display type only (48px+). If they want body text textured, talk them out of it or suggest a translucent panel instead.
3. **Decide effect intensity.** Subtle (small scales, low opacity grain) vs heavy (visible warp, coarse grain). Match the era/style: digital print = subtle, risograph = heavy, xerox = chaotic.
4. **Off-white / off-black palette.** Shift any pure-white background or pure-black text by 10+ hex units. Bias warm for paper, cool for screens, complementary for colored substrates.
5. **Build the filter graph.** Combine 1, 2, 3 in a single `<filter>` for one rasterization pass, unless filters are reused independently across multiple elements.
6. **Test contrast and motion.** Confirm WCAG contrast holds at worst-case displaced positions. Confirm any animation has a `prefers-reduced-motion` fallback.

## Full example: letterpress-style hero

```html
<svg viewBox="0 0 1200 320" xmlns="http://www.w3.org/2000/svg"
     style="background:#ede4d1">
  <defs>
    <filter id="press" x="-5%" y="-10%" width="110%" height="120%">
      <feTurbulence type="fractalNoise" baseFrequency="0.025 0.04"
                    numOctaves="2" seed="7" result="edge"/>
      <feDisplacementMap in="SourceGraphic" in2="edge"
                         scale="2.5" xChannelSelector="R" yChannelSelector="G"
                         result="rough"/>
      <feImage href="/textures/paper.jpg" x="0" y="0" width="1200" height="320"
               preserveAspectRatio="xMidYMid slice" result="paper"/>
      <feDisplacementMap in="rough" in2="paper"
                         scale="3" xChannelSelector="R" yChannelSelector="G"
                         result="warped"/>
      <feTurbulence type="fractalNoise" baseFrequency="1.1"
                    numOctaves="2" result="ink"/>
      <feComposite in="ink" in2="warped" operator="in" result="inkInGlyph"/>
      <feBlend in="warped" in2="inkInGlyph" mode="multiply"/>
    </filter>
  </defs>

  <image href="/textures/paper.jpg" x="0" y="0" width="1200" height="320"
         preserveAspectRatio="xMidYMid slice"/>

  <text x="60" y="230" font-family="Söhne, Inter, sans-serif"
        font-weight="900" font-size="220" letter-spacing="-6"
        fill="#1c1814" filter="url(#press)">
    PRESSED
  </text>
</svg>
```

Three effects, one filter pass, off-white paper (#ede4d1), off-black ink (#1c1814). Reads as ink on paper, not text on JPG.

## Reference

- MDN: `<feTurbulence>`, `<feDisplacementMap>`, `<feImage>`, `<feComposite>`, `<feBlend>`
- Related skill: [[moire-texture]] — for choosing and applying the texture file that this skill warps the type with
- Inigo Quilez on `feTurbulence` parameters
- Lea Verou — SVG filter "scrapbook" patterns
