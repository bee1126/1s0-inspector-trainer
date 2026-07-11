# App Store Connect API Release Setup

This repo now has a no-dependency release helper at `scripts/asc_release.py`.
It uses the official App Store Connect API for version setup, build attachment,
release notes, draft review submissions, and final App Review submission.

The app itself still has zero third-party dependencies. This is release tooling
only.

## One-time Apple setup

Create an App Store Connect API key:

1. Open App Store Connect.
2. Go to `Users and Access` -> `Integrations` -> `App Store Connect API`.
3. Create a key named `1S0 Inspector Trainer Release Bot`.
4. Grant `App Manager` access, or `Admin` if Apple requires broader release permissions.
5. Download the `.p8` file once.
6. Move it to `~/.appstoreconnect/AuthKey_<KEY_ID>.p8`.

Then create the local env file:

```sh
cp scripts/appstore_release.env.example .env.appstoreconnect
$EDITOR .env.appstoreconnect
```

Fill in:

- `ASC_KEY_ID`
- `ASC_KEY_TYPE`
- `ASC_ISSUER_ID`, only for team keys
- `ASC_PRIVATE_KEY_PATH`

The `.env.appstoreconnect` and `AuthKey_*.p8` patterns are gitignored.

Apple supports two App Store Connect API key types:

- Individual keys use `ASC_KEY_TYPE=individual` and do not use an issuer ID.
- Team keys use `ASC_KEY_TYPE=team` and require `ASC_ISSUER_ID`.

## Verify credentials

```sh
source .env.appstoreconnect
python3 scripts/asc_release.py status
```

## Upload a build

Archive:

```sh
xcodebuild \
  -scheme "1S0 Inspector Trainer" \
  -project "1S0 Inspector Trainer.xcodeproj" \
  -configuration Release \
  -destination "generic/platform=iOS" \
  -archivePath "/tmp/1S0 Inspector Trainer.xcarchive" \
  -allowProvisioningUpdates \
  -authenticationKeyPath "$ASC_PRIVATE_KEY_PATH" \
  -authenticationKeyID "$ASC_KEY_ID" \
  -authenticationKeyIssuerID "$ASC_ISSUER_ID" \
  archive
```

Upload:

```sh
xcodebuild -exportArchive \
  -archivePath "/tmp/1S0 Inspector Trainer.xcarchive" \
  -exportPath "/tmp/1s0-appstore-export" \
  -exportOptionsPlist scripts/appstore-export-options.plist \
  -allowProvisioningUpdates \
  -authenticationKeyPath "$ASC_PRIVATE_KEY_PATH" \
  -authenticationKeyID "$ASC_KEY_ID" \
  -authenticationKeyIssuerID "$ASC_ISSUER_ID"
```

The Xcode upload commands above are intended for team keys because Xcode's
`-authenticationKeyIssuerID` option expects an issuer ID. Individual keys are
valid for the App Store Connect API helper, but may not work for Xcode build
upload authentication. Keep using Xcode's signed-in account for upload, or
create a team key later if you want upload fully API-authenticated too.

## Prepare and submit a version

Create release notes:

```sh
cat > /tmp/1s0-release-notes.txt <<'EOF'
- Reviewed and updated quiz questions and answer options for OSHA 1910 alignment and current Air Force safety guidance.
- Expanded the training bank to 14 modules with 140 total questions.
- Refined hearing conservation, fall protection, confined space, PPE, mishap reporting, hazard communication, electrical safety, machine guarding, material handling, and hot work content.
EOF
```

Dry-run the API operations:

```sh
source .env.appstoreconnect
python3 scripts/asc_release.py submit \
  --version 1.6 \
  --build-number 5 \
  --whats-new-file /tmp/1s0-release-notes.txt \
  --dry-run
```

Submit for review:

```sh
python3 scripts/asc_release.py submit \
  --version 1.6 \
  --build-number 5 \
  --whats-new-file /tmp/1s0-release-notes.txt \
  --submit-for-review
```

Without `--submit-for-review`, the script creates a draft review submission but
does not perform the final submit action.

## Notes

- If a build is still processing, the script waits up to 30 minutes by default.
- App Store screenshots, privacy labels, pricing, and app review contact info
  should already be configured in App Store Connect. The script assumes those
  account-level and app-level settings are valid.
- Apple can change App Store Connect API validation rules. Run the dry run and
  `status` checks before unattended releases.
