# WHO LMS reference tables

The eight JSON files in this folder hold the official **WHO Child Growth
Standards (2006)** LMS (Lambda-Mu-Sigma) z-scores tables, downloaded from
<https://www.who.int/tools/child-growth-standards> / <https://www.who.int/toolkits/child-growth-standards>.

Each file's `_source` field records the exact download date and what `x`
means for that file:

- `weight_for_age_*.json`, `height_for_age_*.json`, `bmi_for_age_*.json`:
  `x` is **age in months** (0-60).
- `weight_for_height_*.json`: `x` is the **measured length/height in cm**,
  *not* age. WHO indexes weight-for-height by the child's height — the
  0-2y "weight-for-length" table (45-110cm) and the 2-5y "weight-for-height"
  table (65-120cm) were merged into one file, deduped at the overlap.

`height_for_age` combines WHO's 0-2y recumbent-length table with its 2-5y
standing-height table (the WHO methodology itself switches measurement
technique at 2 years; this is reflected in the official tables, not an
approximation introduced here).

## Provenance

Source files were the official z-scores `.xlsx` tables linked from each
WHO indicator page (Weight-for-age, Length/height-for-age,
Weight-for-length/height, BMI-for-age — boys and girls, birth to 5 years).
The conversion extracted columns A (age or height), B (L), C (M), D (S)
from each table's underlying sheet data and wrote them to this folder's
JSON shape:

```json
{
  "_source": "WHO Child Growth Standards (2006), ... x = age in months.",
  "rows": [
    { "x": 0, "l": 0.3487, "m": 3.3464, "s": 0.14602 },
    { "x": 1, "l": 0.2297, "m": 4.4709, "s": 0.13395 }
  ]
}
```

## Before relying on this for the dissertation or a real demo

Per the literature review's own caution ("an error of even 0.5 SD could mean
classifying a malnourished child as healthy"), spot-check a handful of
(age or height, sex, measurement) combinations against the official WHO
Anthro desktop software before trusting this in front of an examiner or a
real user.
