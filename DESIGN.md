# Existing OTL mobile component contract

This change preserves the existing app design, not the separate web redesign.

- Colors: `OTLColor` in `lib/constants/color.dart`; white surfaces, gray text,
  `pinksMain` actions, `blockColors` for timetable tiles.
- Typography: existing `NotoSansKR` and `lib/constants/text_styles.dart`.
- Spacing: existing timetable 16px outer padding, 3px column gaps, 4px tile radius.
- Primitives: Material AlertDialog, TextFormField, DropdownButtonFormField,
  TextButton, IconButton, SnackBar. Reuse these; no new dependency or animation.
- Custom blocks: name and optional place, existing block palette, semantic tap
  label. Tap opens editing; destructive removal requires confirmation.
- Editor states: input validation, pending actions disabled, inline localized
  error with data retained on failure. Read-only primary timetable has no add action.
- Time grid: keep 09:00 start unless earlier custom blocks require expansion;
  include Saturday/Sunday when required, up to 24:00. Small blocks clip content
  rather than overflow. Form scrolls for the keyboard and small displays.
- Accessibility: tooltips/semantic labels on icons, labeled inputs, localized
  Korean/English text. No decorative motion; use existing Material feedback.
- QA: real widget CRUD, invalid input, overlap, network failure, tab switching,
  mobile viewport and enlarged text. Native platform/plugin verification is
  distinct from a browser component harness.
