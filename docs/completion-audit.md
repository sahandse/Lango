# Lango completion audit — 2026-11-27

Baseline: `62a7ff8272b9264ca7bf047f1368e819dd385ee0`. Existing user content and preference keys are preserved.

| Requested stage | Implementation / evidence | Remaining validation |
|---|---|---|
| 1. FarsiMatrix | Reproducible audit of pinned upstream revision; 51 groups, 245,975 entries, 3,001 entries without Persian script. Per-file SHA-256 and review flags in `farsimatrix-audit.json`. | Dataset provenance is unresolved. LICENSE says Apache-2.0 while README says MIT. The upstream builder points to a local dictionary archive with no distributable provenance. Full corpus is deliberately not bundled or declared reviewed. Existing selected headwords with Lango-authored glosses remain. |
| 2–3. Five languages, A1–C2 | Added 30 original practical lessons and 120 phrase pairs alongside the existing 30 lessons / 120 pairs. All 60 lessons expose meaning, writing, listening/transcription and token ordering. New lessons and exercise progress have separate persistent keys. | These 240 phrase pairs are learning material, not a comprehensive or certified CEFR curriculum. Independent native-speaker and pedagogical review remains necessary. |
| 4. IPA / accents | Missing IPA explicitly identified in UI; never copy a different accent's transcription. Existing broad IPA references retained. | IPA is partial. en-AU, de-AT and fr-CA have no authored IPA entries. No automatic transliteration is mislabelled as verified IPA. |
| 5. Voice | Locale-aware transcript comparison, bounded recognition timeout, final-result guard, app background cancellation, empty-result handling. Tests cover Turkish I/İ/ı, punctuation and empty transcripts. | Recognition is not acoustic pronunciation assessment. Phoneme-level evaluation requires a licensed scoring engine and calibration against expert-rated recordings. Real microphone, permissions and offline engine tests need Android hardware. |
| 6. Lens | Selected image preview, bounded decode size, cached dictionary matches, deferred ML Kit disposal during processing, unknown-label fallback retained. | Real camera/gallery, denied permissions, offline model and representative object images need Android device testing. |
| 7. Offline / font | Vendored integrity-verified Vazirmatn Regular/Bold and OFL license; font preparation remains an integrity check. Content loads from assets. | Device TTS/STT depend on installed language packs. No blanket claim of offline voice support. |
| 8. Performance | Lens dictionary lookup cache and preview decode size; transcript edit distance uses two rows and no per-cell sorting. | No device memory, startup, frame-time or final APK-size benchmark has been completed. |
| 9. UI | Scrollable settings and dictionary details; text-scaled skill grid; scrollable card contents; progress clamping; corrupted personal-card recovery; one-card mistake removal regression fixed. | Widget matrix covers planned checks; hardware visual review remains separate. |
| 10. Tests / CI | Added content, speech, personal-storage, UI matrix and regression tests; Python corpus-audit tests; existing tests retained. | Test status is recorded below only after actual execution. |
| 11. APK / AAB | CI prepares signed candidates when all four existing signing secrets are present, verifies signatures and records SHA-256. Automatic GitHub Release publication removed. | No release is published by this workflow. A green debug build does not establish a signed candidate or store readiness. Missing signing credentials are reported explicitly in CI. |

## Validation log

- Local: `python -m unittest discover -s tools/tests -v` passed (1 test).
- Local: `python -m py_compile tools/*.py` passed.
- Local: pinned FarsiMatrix audit completed on all 245,975 entries. Structural checks are not semantic translation review.
- Local: `python tools/prepare_fonts.py` verified all three pinned assets against expected Git blob hashes.
- Local: Dart formatter parsed changed Dart sources successfully.
- Local Flutter execution was blocked by automatic approval review because it attempted cloud instance metadata access. Flutter tests/builds are delegated to GitHub-hosted CI, not claimed as locally run.
- CI results and artifact availability: pending the new commit's actual workflow run.

## Reproduce corpus audit

```sh
git clone https://github.com/TssHack/FarsiMatrix.git ../FarsiMatrix
git -C ../FarsiMatrix checkout ccf6dbaacda5bba1a16bc811df2e20da079388e4
python tools/audit_farsimatrix.py ../FarsiMatrix
python -m unittest discover -s tools/tests -v
```

Do not import raw candidates or relabel programmatically checked text as human-reviewed. Resolve dataset rights and review translation/suitability before redistribution.
