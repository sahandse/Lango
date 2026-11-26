# Real learning content

The bundled starter words are authored educational material, not generated user statistics. External sentence data must be reviewed for accurate translation, age suitability and licensing before shipping.

## Tatoeba sentence import
1. Download detailed sentences and links from https://tatoeba.org/en/downloads and extract the TSV files.
2. Run python tools/import_tatoeba.py sentences_detailed.csv links.csv to generate candidates.
3. Review both sides of each pair, confirm licensing and record approved source ID and Persian translation ID in a two-column TSV.
4. Run python tools/import_tatoeba.py sentences_detailed.csv links.csv --approved approved.tsv --out assets/content/sentences.json

The app loads this asset at startup. Entries retain both authors and original sentence IDs; Tatoeba text is attributed under CC BY 2.0 FR (https://creativecommons.org/licenses/by/2.0/fr/). Raw candidate dumps must not be shipped.

No CEFR label is inferred from sentence length. No invented IPA or native recording is substituted for missing data. TTS is synthesized by the device.

Wiktionary/Kaikki is a possible future source for word senses and IPA, subject to license and content review. It is not yet imported.

## Verified reference catalog
- https://www.coe.int/en/web/portfolio/self%20-assessment-grid — official CEFR reference, not a licensed word list.
- https://github.com/open-dsl-dict/wiktionary-dict — bilingual dictionaries including English–Persian; preserve CC BY-SA 3.0/GFDL notices and verify upstream provenance before redistribution.
- https://open-dict-data.github.io/ — open dictionary reference catalog; check individual dataset licenses.
These references are linked in-app; no unreviewed external corpus is bundled. Imported entries must pass manual translation and suitability review.
