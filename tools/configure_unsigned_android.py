"""Prepare explicitly UNSIGNED release outputs for later signing, never debug-key releases."""
from pathlib import Path


def configure(path):
    path=Path(path)
    text=path.read_text()
    old='signingConfig = signingConfigs.getByName("debug")'
    if text.count(old)!=1:
        raise ValueError('Unexpected Gradle signing setup; refusing to change it')
    path.write_text(text.replace(old,'signingConfig = null // UNSIGNED preparation only',1))


if __name__=='__main__':
    configure('android/app/build.gradle.kts')
