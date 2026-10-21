# Unigreen design profile

This is what design judgements are made against. README files, notes and decisions give context,
but this profile is the reference for "does the design fit the product". Keep it short and cite files.

## Product lines seen in the repo

Observed on the pack images (cite the file when you use one):
- Toilet tissue, multi-roll packs in colour: `frontend/public/images/products/gvs-uni-green-jpg.webp`
  (10 rolls, 3 ply; a cartoon child and foliage on magenta).
- Mega roll, blue "Ultra Soft" pack with Japanese text: packaging artwork in
  `frontend/public/images/factory/production-line.webp` (the printed artwork sheet, not a photo).
- Coreless rolls, recycled and standard, in the product folder under `frontend/public/images/products/coreless*`.

## Brand cues observed

- Logo: a green oval with "UNI-GREEN" in bold capitals.
- Colours seen on the packs: green (logo, accents), blue (Ultra Soft), magenta and red (10-roll pack).
  These are observed values, not a brand guide. Exact hex values are UNPROVEN until a brand source is supplied.
- Copy on the packs is Vietnamese, with Japanese lines: "Japan quality", "Japanese technology".
- Claims printed on packs: ISO 9001:2015 and ISO 14001:2015, "không lõi" (coreless), "tiết kiệm hơn" (saves more).

## Audience (assumption, to confirm with Lystiger)

- Business buyers: distributors, retailers and institutions who request quotations. The site is a quotation
  request tool first, a brochure second.
- End users are not the buyer on the site, but the packs must still look appealing on shelves.

## Tone

- Trustworthy and clear for a buyer, friendly for the brand. Warm, not childish.
- Show the product and its pack formats (rolls, cartons, coreless) plainly; the quotation step must be obvious.
- Japanese quality is a claim the site can support with specifications, not decoration.

## Must

- Vietnamese and English layouts that hold up with longer Vietnamese words, on phone width.
- Contrast that meets WCAG AA. Visible focus states. Touch targets large enough to use on a phone.
- Product photos on a neutral background, so the pack colours carry the page.
- Motion limited to transitions and entry, per the theme rules. No perpetual animation.
- Page weight within the performance budget (LCP under 2.5 s on the staging measure).

## Must not

- Cartoon characters as the main visual on the buyer pages.
- Dense pattern backgrounds behind text.
- Claims the site cannot back with a specification or certificate.

## How agents judge fit

1. Score each candidate direction against the rubric in `docs/` of the research notes (clarity, trust,
   typography, colour restraint, accessibility, motion, speed, bilingual layout).
2. Cite the file or source for each observation. Observations without a source are UNPROVEN.
3. Record the judgement in the decision log as a proposal. Only Lystiger accepts a direction.
4. A judgement is reasoning evidence, not proof. Checks like contrast and load time are measured, not judged.
