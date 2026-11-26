from pathlib import Path
import base64, io
from PIL import Image
logo = Image.open(io.BytesIO(base64.b64decode(Path('assets/brand/logo.webp.b64').read_text()))).convert('RGB')
res = Path('android/app/src/main/res')
for density, size in [('mdpi',48),('hdpi',72),('xhdpi',96),('xxhdpi',144),('xxxhdpi',192)]:
    folder = res / ('mipmap-' + density)
    folder.mkdir(parents=True,exist_ok=True)
    logo.resize((size,size),Image.Resampling.LANCZOS).save(folder/'ic_launcher.png')
for folder in ('drawable','drawable-v21'):
    target=res/folder
    target.mkdir(parents=True,exist_ok=True)
    logo.save(target/'lango_splash.png')
    (target/'launch_background.xml').write_text('<layer-list xmlns:android="http://schemas.android.com/apk/res/android"><item android:drawable="@android:color/white"/><item><bitmap android:gravity="center" android:src="@drawable/lango_splash"/></item></layer-list>')
manifest=Path('android/app/src/main/AndroidManifest.xml')
manifest.write_text(manifest.read_text().replace('android:label="lango"','android:label="Lango"'))
