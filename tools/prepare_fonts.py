"""Fetch pinned Vazirmatn build assets; no network required at app runtime."""
from pathlib import Path
from urllib.request import urlopen
import hashlib

BASE = "https://raw.githubusercontent.com/rastikerdar/vazirmatn/v33.003/"
FILES = {
    "fonts/ttf/Vazirmatn-Regular.ttf": ("Vazirmatn-Regular.ttf", "64e4a8189557a17b63fd7a77794207483e592972"),
    "fonts/ttf/Vazirmatn-Bold.ttf": ("Vazirmatn-Bold.ttf", "efa9b095da01d299310bdcae293e24e657fe6da9"),
    "OFL.txt": ("OFL.txt", "be66b3824e9772e75141e631695c5256f105fb57"),
}
def git_sha(data):
    return hashlib.sha1(b"blob " + str(len(data)).encode() + b"\0" + data).hexdigest()

def main():
    dest = Path(__file__).resolve().parents[1] / "assets" / "fonts"
    dest.mkdir(parents=True, exist_ok=True)
    for remote, (filename, expected) in FILES.items():
        path = dest / filename
        if path.exists() and git_sha(path.read_bytes()) == expected:
            continue
        with urlopen(BASE + remote, timeout=45) as response:
            data = response.read(2_000_000)
        if git_sha(data) != expected:
            raise RuntimeError("Asset integrity mismatch: " + filename)
        path.write_bytes(data)
    print("Verified Vazirmatn v33.003 assets and OFL license")

if __name__ == "__main__":
    main()
