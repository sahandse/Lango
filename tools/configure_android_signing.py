"""Fail closed if a persistent signing key is not configured."""
import os, base64, pathlib
names = ['KEYSTORE_B64', 'KEYSTORE_PASSWORD', 'KEY_PASSWORD', 'KEY_ALIAS']
if any(not os.environ.get(n) for n in names):
    raise SystemExit('Android signing secrets are required for release builds.')
app = pathlib.Path('android/app')
key = app / 'lango-release.jks'
key.write_bytes(base64.b64decode(os.environ['KEYSTORE_B64'], validate=True))
key.chmod(0o600)
gradle = app / 'build.gradle.kts'
if not gradle.exists():
    raise SystemExit('Expected Kotlin Gradle configuration; review generated scaffold.')
s = gradle.read_text()
marker = '    buildTypes {'
old = 'signingConfig = signingConfigs.getByName("debug")'
if marker not in s or old not in s:
    raise SystemExit('Unexpected Gradle signing configuration; refusing unsigned release.')
s = s.replace(marker, '''    signingConfigs {
        create("release") {
            storeFile = file("lango-release.jks")
            storePassword = System.getenv("KEYSTORE_PASSWORD")
            keyAlias = System.getenv("KEY_ALIAS")
            keyPassword = System.getenv("KEY_PASSWORD")
        }
    }
''' + marker, 1).replace(old, 'signingConfig = signingConfigs.getByName("release")', 1)
gradle.write_text(s)
