#!/usr/bin/env python3
"""Validate the shared brand against the prepared bundle, website, and listing."""
from pathlib import Path
import argparse, html, plistlib, re
root = Path(__file__).resolve().parents[1]
parser = argparse.ArgumentParser(); parser.add_argument('--check', action='store_true'); parser.parse_args()
source = (root/'1S0 Inspector Trainer/Models/ContentCatalog.swift').read_text()
name = re.search(r'static let shortName = "([^"]+)"', source).group(1)
tagline = re.search(r'static let tagline = "([^"]+)"', source).group(1)
disclaimer = re.search(r'static let disclaimer = "(.*)"', source).group(1).replace('\\(name)',name)
info = plistlib.loads((root/'1S0 Inspector Trainer/Resources/Info.plist').read_bytes())
assert info['CFBundleDisplayName'] == name
for path in (root/'docs').glob('*.html'):
    text = html.unescape(path.read_text())
    assert name in text and disclaimer in text, path
    assert not re.search(r'Safety(?:XP|Skill)|InspectXP|inspection-ready', text), path
listing = (root/'AppStoreAssets/safetyfluent/listing_1.8_safetyfluent_FINAL.md').read_text()
assert disclaimer in listing
assert tagline in (root/'docs/index.html').read_text()
for field, limit in [('Name',30), ('Subtitle',30), ('Promotional Text',170), ('Keywords',100), ('Description',4000), ("What's New",4000)]:
    value = re.search(r'^## '+re.escape(field)+r'[^\n]*\n(.*?)(?=\n## |\Z)',listing,re.S|re.M).group(1).strip()
    length = len(value.encode('utf-8')) if field == 'Keywords' else len(value)
    assert length <= limit, (field,length,limit)
    print(f'{field}: {length}/{limit}')
assert not re.search(r'\[[^\]]+\]',listing)
print(f'{name}: bundle, disclaimer, site and listing verified')
