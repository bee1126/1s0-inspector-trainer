#!/usr/bin/env python3
"""Regenerate static brand outputs after the one-line AppBrand.name fallback.
Run with --check in CI to reject stale bundle/site/listing names.
"""
from pathlib import Path
import argparse, re
root = Path(__file__).resolve().parents[1]
parser = argparse.ArgumentParser(); parser.add_argument('--check', action='store_true'); args = parser.parse_args()
source = (root / '1S0 Inspector Trainer/Models/ContentCatalog.swift').read_text()
name = re.search(r'static let name = "([^"]+)"', source).group(1)
assert name in ('SafetyXP', 'InspectXP')
files = [root / '1S0 Inspector Trainer/Resources/Info.plist'] + list((root/'docs').glob('*.html')) + [root/'AppStoreAssets/safetyxp/listing_1.8_safetyxp_final.md']
changed=[]
for path in files:
    old = path.read_text(); new = re.sub(r'\b(?:SafetyXP|InspectXP)\b', name, old)
    if old != new:
        changed.append(str(path.relative_to(root)))
        if not args.check: path.write_text(new)
if args.check and changed: raise SystemExit('Stale brand outputs: ' + ', '.join(changed))
print(f'{name}: {len(files)} static outputs verified' if not changed else 'Updated: ' + ', '.join(changed))
