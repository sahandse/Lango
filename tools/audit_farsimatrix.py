"""Audit an upstream checkout without redistributing unreviewed dictionary text."""
import argparse
import collections
import hashlib
import json
from pathlib import Path
import subprocess


def audit(root):
    root = Path(root)
    license_text = (root / 'LICENSE').read_text(encoding='utf-8')
    readme = (root / 'README.md').read_text(encoding='utf-8')
    files = []
    totals = collections.Counter()
    for path in sorted((root / 'public/data/groups').glob('*.json')):
        raw = path.read_bytes()
        rows = json.loads(raw)
        counts = collections.Counter(entries=len(rows))
        ids, terms = set(), set()
        for row in rows:
            term = row.get('word', '').strip().casefold()
            meanings = row.get('meanings')
            if row.get('id') in ids:
                counts['duplicate_ids'] += 1
            if term in terms:
                counts['duplicate_terms'] += 1
            if not term or not isinstance(meanings, list) or not meanings or not all(isinstance(m, str) and m.strip() for m in meanings):
                counts['invalid_entries'] += 1
            elif not any('\u0600' <= ch <= '\u06ff' for ch in ''.join(meanings)):
                counts['no_persian_script'] += 1
            ids.add(row.get('id'))
            terms.add(term)
        totals.update(counts)
        files.append(dict(path=path.relative_to(root).as_posix(), sha256=hashlib.sha256(raw).hexdigest(), **counts))
    if not files:
        raise ValueError('No dictionary groups found')
    return dict(source='https://github.com/TssHack/FarsiMatrix',
                revision=subprocess.check_output(['git', '-C', str(root), 'rev-parse', 'HEAD'], text=True).strip(),
                groups=len(files), totals=dict(totals),
                license_file='Apache-2.0' if 'Apache License' in license_text else 'unrecognized',
                readme_claims_mit='[MIT](LICENSE)' in readme,
                redistribution_status='blocked_pending_dataset_provenance_and_license_clarification',
                quality_note='Structural checks only; no automatic claim of translation accuracy. Non-Persian script is a review flag, not an automatic error.',
                files=files)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('checkout')
    parser.add_argument('--out', default='docs/farsimatrix-audit.json')
    args = parser.parse_args()
    result = audit(args.checkout)
    Path(args.out).parent.mkdir(parents=True, exist_ok=True)
    Path(args.out).write_text(json.dumps(result, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print(json.dumps({k: result[k] for k in ('revision', 'groups', 'totals', 'redistribution_status')}))


if __name__ == '__main__':
    main()
