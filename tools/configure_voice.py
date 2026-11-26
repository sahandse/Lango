from pathlib import Path
p=Path('android/app/src/main/AndroidManifest.xml')
s=p.read_text()
if 'android.permission.RECORD_AUDIO' not in s:
    s=s.replace('<application','<uses-permission android:name="android.permission.RECORD_AUDIO" />\n    <application',1)
if 'android.speech.RecognitionService' not in s:
    if '<queries>' in s:
        s=s.replace('<queries>','<queries>\n        <intent><action android:name="android.speech.RecognitionService" /></intent>',1)
    else:
        s=s.replace('</manifest>','<queries><intent><action android:name="android.speech.RecognitionService" /></intent></queries>\n</manifest>')
p.write_text(s)
