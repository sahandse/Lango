#!/usr/bin/env python3
"""Prepare reviewable Persian sentence pairs from official Tatoeba exports."""
import argparse, csv, json, pathlib, re
LANG = {'eng':'en','deu':'de','fra':'fr','spa':'es','tur':'tr'}
def rows(path):
    with open(path, encoding='utf-8', newline='') as f:
        yield from csv.reader(f, delimiter='\t', quoting=csv.QUOTE_NONE)
def main():
    p=argparse.ArgumentParser()
    p.add_argument('sentences', help='Extracted detailed sentences TSV')
    p.add_argument('links', help='Extracted links TSV')
    p.add_argument('--approved', help='TSV of human-approved source ID, Persian ID pairs')
    p.add_argument('--out', default='build/corpus_candidates.json')
    a=p.parse_args()
    entries={}
    for row in rows(a.sentences):
        if len(row)>=6 and row[1] in {*LANG,'pes'} and row[0].isdigit() and row[3] not in ('','\\N'):
            entries[row[0]]=row
    approved={tuple(row[:2]) for row in rows(a.approved) if len(row)>=2} if a.approved else None
    result={code:[] for code in LANG.values()}
    seen=set()
    for row in rows(a.links):
        if len(row)!=2: continue
        first,second=(entries.get(k) for k in row)
        if not first or not second or first[1] not in LANG or second[1]!='pes': continue
        ids=(first[0],second[0])
        if approved is not None and ids not in approved: continue
        key=(first[1],first[2],second[2])
        if key in seen or not first[2].strip() or not second[2].strip(): continue
        if len(first[2])>150 or len(second[2])>150: continue
        seen.add(key)
        result[LANG[first[1]]].append(dict(term=first[2],meaning=second[2],source='Tatoeba',sourceId=first[0],translationId=second[0],author=first[3],translator=second[3],license='CC BY 2.0 FR'))
    out=pathlib.Path(a.out)
    if approved is None and 'assets' in out.parts: raise SystemExit('Unreviewed candidates cannot enter app assets')
    if approved is not None and not any(result.values()): raise SystemExit('No approved pairs matched')
    out.parent.mkdir(parents=True,exist_ok=True)
    out.write_text(json.dumps(result,ensure_ascii=False,indent=2),encoding='utf-8')
    print({k:len(v) for k,v in result.items()})
if __name__=='__main__': main()
