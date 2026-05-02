# Design System Document: The Refined Artifact

## 1. Overview & Creative North Star: "The Digital Curator"
This design system rejects the "standard" internet aesthetic of rounded bubbles and heavy shadows. Its North Star is **The Digital Curator**—a philosophy that treats every screen like a high-end architectural portfolio or a physical gallery space. 

By utilizing an "Analog" soul within a digital framework, we prioritize intentionality over density. We break the "template" look by using extreme whitespace, asymmetric content balancing, and a "Refined Artifact" aesthetic where every element feels like it was placed by hand. There are no hero sections; the content *is* the hero. We rely on raw structural integrity and tonal depth rather than decorative fluff.

---

### 2. Colors & Tonal Architecture
The palette is a study in restrained sophistication. We use a grayscale foundation to provide an "architectural" backdrop, allowing our singular terracotta accent to feel like a deliberate mark of human craft.

*   **Primary (Terracotta):** `#924a28` (Primary) & `#D27D56` (Base Accent). Use sparingly for high-intent actions or to draw the eye to a single "Artifact" on the page.
*   **Neutral Foundation:** We utilize a warm-leaning grayscale (`#fcf9f8` background) to avoid the clinical coldness of pure blue-grays.

#### The "No-Line" Rule
**Prohibit 1px solid borders for sectioning.** Conventional dividers are forbidden. Use background color shifts to define boundaries. For example, a `surface-container-low` (`#f6f3f2`) section sitting on a `surface` (`#fcf9f8`) background provides a sophisticated, "pressed" look that 1px lines cannot replicate.

#### Surface Hierarchy & Nesting
Treat the UI as a series of physical layers.
- **Base:** `surface` (`#fcf9f8`)
- **Nested Content:** Use `surface-container-low` (`#f6f3f2`) for large structural blocks.
- **Interactive Elements:** Use `surface-container-highest` (`#e4e2e2`) for small utility components to give them a "carved" appearance.

#### Signature Textures
For main CTAs, do not use flat fills. Apply a subtle linear gradient from `primary` (`#924a28`) to `primary_dim` (`#833f1d`) at a 150-degree angle. This adds "visual soul" and a tactile, leathery quality to the terracotta accent.

---

### 3. Typography: The Editorial Voice
We pair **Lora** (serif) with **Inter** (sans) to create a rhythmic, editorial feel — the serif carries the editorial voice while the sans handles the framing chrome.

*   **Display & Titles (The Statement):** Lora serif for page titles, post titles (both in listings and the single-post `<h1>`), and hero captions. The serif gives titles weight and intent without shouting.
*   **Body (The Narrative):** Lora serif at `body-lg` (1.05rem) with a generous line-height for post bodies, page content, and excerpts. This is the "artifact" description.
*   **Chrome (The Frame):** Inter sans for site name, navigation, dates, labels, pagination, and footer. These are the museum placards and signage — they orient the reader without competing with the work.
*   **Label (The Metadata):** `label-md` (0.75rem) in all-caps with 0.05em letter spacing for category tags or technical data, mimicking the small placards found in museums.

The relationship between Lora titles and Inter labels creates a "high-low" contrast that feels premium and authoritative.

---

### 4. Elevation & Depth: Tonal Layering
Traditional drop shadows are largely banned. We convey depth through **Tonal Layering**.

*   **The Layering Principle:** Place a `surface-container-lowest` (#ffffff) card on a `surface-container` (#f0eded) background. This creates a soft, natural "lift" based on color value rather than artificial lighting.
*   **Ambient Shadows:** If an element *must* float (e.g., a dropdown or modal), use a shadow with a 40px blur and only 4% opacity of the `on-surface` color. It should feel like an ambient glow, not a shadow.
*   **The "Ghost Border" Fallback:** For accessibility in form fields, use the `outline-variant` token at **20% opacity**. Never use a 100% opaque border; it breaks the architectural fluidity.
*   **Glassmorphism:** For navigation overlays, use `surface` at 80% opacity with a `24px` backdrop blur. This allows the "artifacts" beneath to bleed through, softening the interface.

---

### 5. Components

#### Buttons
*   **Primary:** Terracotta gradient, `4px` (DEFAULT) corner radius. No border. Text in `on-primary` (`#fff6f3`).
*   **Secondary:** `surface-container-highest` fill. Minimalist and architectural.
*   **Tertiary:** Text-only in `primary` with a `2px` underline that only appears on hover.

#### Input Fields
*   **Styling:** No background fill. Only a bottom border using `outline-variant` at 40% opacity. 
*   **Focus State:** The bottom border transforms into a `1px` solid `primary` (terracotta).
*   **Labels:** Use `label-sm` positioned precisely 8px above the input line.

#### Cards & Lists
*   **Rule:** Forbid divider lines. Use `spacing-8` (2.75rem) to separate list items. 
*   **Structure:** Cards should have no borders and no shadows. Use a subtle `surface-container-low` background to distinguish the card from the main surface.

#### Artifact Previews (Custom Component)
A large-scale image component with no padding, using the `primary_fixed` color as a "matte" background for transparent PNGs. This reinforces the museum-curation aesthetic.

---

### 6. Do's and Don'ts

**Do:**
*   **Embrace Asymmetry:** Align text to the left while keeping images slightly offset to the right.
*   **Use Large Spacing:** Use `spacing-20` (7rem) between major sections to let the design breathe.
*   **Stick to 4px:** Every corner (buttons, cards, inputs) must use the `0.25rem` (4px) radius exactly. Consistency is the key to the "Modern Analog" feel.

**Don't:**
*   **No Hero Sections:** Never use a full-width background image with centered text. Introduce content through typography and whitespace instead.
*   **No High Saturation:** Avoid neon or "digital" colors. Even the terracotta must feel like it was sourced from natural clay.
*   **No Rounded Pills:** Never use `full` (9999px) roundness for buttons. It contradicts the architectural integrity of the system.
*   **No 1px Dividers:** If you feel the need to add a line, add `2rem` of whitespace instead.