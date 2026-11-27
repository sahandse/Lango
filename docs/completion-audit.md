# Lango completion audit — 2026-11-27

Baseline: `62a7ff8272b9264ca7bf047f1368e819dd385ee0`. Existing user content and preference keys are preserved.

| Requested stage | Implementation / evidence | Remaining validation |
|---|---|---|
| 1. FarsiMatrix | Reproducible audit of pinned upstream revision; 51 groups, 245,975 entries, 2,742 entries without Arabic-script letters (Unicode-aware review flag). Per-file SHA-256 and review flags in `farsimatrix-audit.json`. | Dataset provenance is unresolved. LICENSE says Apache-2.0 while README says MIT. The upstream builder points to a local dictionary archive with no distributable provenance. Full corpus is deliberately not bundled or declared reviewed. Existing selected headwords with Lango-authored glosses remain. |
| 2–3. Five languages, A1–C2 | Added 30 original practical lessons and 120 phrase pairs alongside the existing 30 lessons / 120 pairs. All 60 lessons expose meaning, writing, listening/transcription and token ordering. New lessons and exercise progress have separate persistent keys. | These 240 phrase pairs are learning material, not a comprehensive or certified CEFR curriculum. Independent native-speaker and pedagogical review remains necessary. |
| 4. IPA / accents | Missing IPA explicitly identified in UI; never copy a different accent's transcription. Existing broad IPA references retained. | IPA is partial. en-AU, de-AT and fr-CA have no authored IPA entries. No automatic transliteration is mislabelled as verified IPA. |
| 5. Voice | Locale-aware transcript comparison, bounded recognition timeout, final-result guard, app background cancellation, empty-result handling. Tests cover Turkish I/İ/ı, punctuation and empty transcripts. | Recognition is not acoustic pronunciation assessment. Phoneme-level evaluation requires a licensed scoring engine and calibration against expert-rated recordings. Real microphone, permissions and offline engine tests need Android hardware. |
| 6. Lens | Selected image preview, bounded decode size, cached dictionary matches, deferred ML Kit disposal during processing, unknown-label fallback retained. | Real camera/gallery, denied permissions, offline model and representative object images need Android device testing. |
| 7. Offline / font | Vendored integrity-verified Vazirmatn Regular/Bold and OFL license; font preparation remains an integrity check. Content loads from assets. | Device TTS/STT depend on installed language packs. No blanket claim of offline voice support. |
| 8. Performance | Lens dictionary lookup cache and preview decode size; transcript edit distance uses two rows and no per-cell sorting. | The debug APK is 191,651,489 bytes (all ABIs / debug runtime). This is not representative of store install size. No device memory, startup, frame-time or signed release-size benchmark has been completed. |
| 9. UI | Scrollable settings and dictionary details; text-scaled skill grid; scrollable card contents; progress clamping; corrupted personal-card recovery; one-card mistake removal regression fixed. | Widget matrix was executed on GitHub-hosted Flutter 3.50.1. It initially found a 41-pixel overflow at 320px / 2x text in both themes; the title was made flexible and the selector expanded. The subsequent workflow passed this test step. Hardware visual review remains separate. |
| 10. Tests / CI | Added content, speech, personal-storage, UI matrix and regression tests; Python corpus-audit tests; existing tests retained. | Test status is recorded below only after actual execution. |
| 11. APK / AAB | CI prepares signed candidates when all four existing signing secrets are present, verifies signatures and records SHA-256. Automatic GitHub Release publication removed. | Signed candidate steps were skipped in run 45981939526 because persistent signing credentials were unavailable. The browser fallback reached GitHub sign-in; it is not authenticated. A separate branch/workflow compiles explicitly unsigned release files for later signing. These must never be installed or published as signed releases. No release has been published. |

## Validation log

- Local: `python -m unittest discover -s tools/tests -v` passed (3 tests in the final tool revision).
- Local: `python -m py_compile tools/*.py` passed.
- Local: pinned FarsiMatrix audit completed on all 245,975 entries. Structural checks are not semantic translation review.
- Local: `python tools/prepare_fonts.py` verified all three pinned assets against expected Git blob hashes.
- Local: Dart formatter parsed changed Dart sources successfully.
- Local Flutter execution was blocked by automatic approval review because it attempted cloud instance metadata access. Flutter tests/builds are delegated to GitHub-hosted CI, not claimed as locally run.
- CI `45981550738` (`b557376`): analyzer passed; 42 Flutter tests passed, 2 large-text UI tests failed. No build was claimed from this run.
- Follow-up CI `45981939526` (`ba7978d`): analyzer passed, all 44 Flutter tests passed, debug APK built successfully, and the Android 35 emulator offline smoke test passed. Both workflow jobs completed successfully. The three actual emulator screenshots (home light, home dark, Turkish dictionary) were downloaded and visually inspected: Persian glyphs rendered, the selected favorite appeared, both themes rendered and no clipping was observed in these captures.
- Lesson-flow tests exercise actual answer selection, writing and ordering across all five languages and verify isolated persistent progress. UI tests cover both brightness modes, three viewport sizes and 1x/2x text, plus narrow landscape secondary pages.
- No device microphone, camera, pronunciation calibration, native-speaker curriculum validation or release performance result is implied by widget tests.

## Reproduce corpus audit

```sh
git clone https://github.com/TssHack/FarsiMatrix.git ../FarsiMatrix
git -C ../FarsiMatrix checkout ccf6dbaacda5bba1a16bc811df2e20da079388e4
python tools/audit_farsimatrix.py ../FarsiMatrix
python -m unittest discover -s tools/tests -v
```

Do not import raw candidates or relabel programmatically checked text as human-reviewed. Resolve dataset rights and review translation/suitability before redistribution.

## Manual upstream quality spot-check

At the audited revision, `public/data/groups/algorithms.json` contains:

- `algorithms_1`: `2-3 tree` is glossed only as «درخت», losing the defining 2–3 distinction.
- `algorithms_16`: `adaptive k-d tree` has two split meanings, «درخت K» and «d تطابقی», suggesting a broken phrase boundary.

These are spot-check findings, not an accuracy estimate for the entire corpus. The builder's `DICT_DIR` is an absolute path to the maintainer's local dictionary archive; a source archive and its separate rights are not documented there. Clarification should cover dataset provenance and redistribution rights, not only the contradictory README badge.

## Workspace preservation

Task checkout: `/workspace/scratch/998d53f24f4d/Lango`. Upstream data and SDK checkouts are retained as reproducible inputs; no unrelated user files or remote branches were removed. No signing credentials were created or committed. Debug artifact SHA-256: `0d1750fa1c110adfe9da505639911baf26ed0e06ebe14d4511a7dc09c5dfc874` (191,651,489 bytes). This debug size is not a release-size benchmark.

## Evidence links

- Main app validation and offline device run: https://github.com/sahandse/Lango/actions/runs/45981939526
- Signed release preparation is blocked by unavailable `ANDROID_KEYSTORE_BASE64`, `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_PASSWORD`, `ANDROID_KEY_ALIAS`.
- Unsigned build preparation: https://github.com/sahandse/Lango/actions/runs/45983276141 (first attempt failed on Maven HTTP 429; a single retry was started).

## Release-only build issue discovered

The first unsigned build attempt encountered Maven HTTP 429. The bounded retry got past downloads but exposed a genuine release-only Lint crash in `image_picker_android:lintVitalAnalyzeRelease`: `NoSuchMethodError: java.util.List.removeLast()` while running on Java 17. Both build workflows were changed to Java 21; Lint was not disabled. Java's API documents the method in JDK 21: https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/util/List.html#removeLast(). The corrective commit is `98974a3`; run `45984495610` passed, compiling both release formats and verifying that they were unsigned.

## CI resource cleanup

Superseded task-owned runs `45981080916` and `45981398922` were cancelled by a one-time, SHA-guarded workflow on the separate `work/cancel-obsolete-builds` branch (run `45984766590`). It targets only those exact run IDs and expected commit SHAs. The workflow is not added to the main app branch.

## Final release preparation result

- https://github.com/sahandse/Lango/actions/runs/45984495610 — Java 21 release build passed. APK and AAB were compiled with normal release checks, including Lint, enabled.
- Artifact `15191256830` (`lango-unsigned-for-signing`) contains explicitly unsigned APK/AAB, signature checks, SHA-256 and size reports. No debug key was substituted for a missing release key.
- The earlier unsigned failure run `45983276141` is superseded by this successful corrective run.
- Unicode-aware audit checks now recognize Arabic presentation forms outside the basic Arabic block: 2,742 entries lack Arabic-script letters. The initial basic-block heuristic had flagged 3,001; this refinement avoids 259 false-positive flags. This remains a structural review signal, not a translation accuracy score. The updated audit and all three Python tool tests were run locally.

## Remaining work before final publication

1. Resolve FarsiMatrix dataset rights/provenance and review translations before full ingestion.
2. Expand and independently validate the curriculum beyond the current 60 lessons / 240 phrase pairs; fill missing IPA with reviewed sources and accent-specific coverage.
3. Integrate and calibrate real acoustic pronunciation assessment; transcript similarity must remain labelled as transcript similarity.
4. Test actual microphone, denied permissions, camera/gallery and representative image recognition on Android hardware. Measure release startup, memory and frames on representative devices.
5. Supply the four persistent signing secrets via authenticated GitHub settings, build signed candidates and verify the signing certificate and install/update path. Browser fallback is currently at sign-in; repository code access does not supply a browser session or secret-write capability.
6. Obtain the owner's explicit final publication approval. Neither an unsigned build nor the debug APK is a publishable release.

### Unsigned package measurements

| File | Bytes | SHA-256 |
|---|---:|---|
| Lango-UNSIGNED.apk | 86,825,475 | `fb7bd73cb0f0153c01d8720c9ae1e3dc7d492b18360b436bb777286267366907` |
| Lango-UNSIGNED.aab | 69,752,491 | `685fe7f01a3e60591476f509efd1c20d0a2eac6a5f16396313ed7a0ef3328791` |

Both files were downloaded from the successful artifact and independently hashed. The artifact ZIP digest was also verified. These are universal release-build file sizes, not per-device install sizes or signed store submissions.

Final audit/report changes do not alter Dart application code from the tested `ba7978d` snapshot. The Java 21 build-tool change is independently exercised by successful release run `45984495610`. The final Unicode audit/tool changes passed all three Python tests locally; the audit/report closeout commit skips redundant Flutter/Android builds.
