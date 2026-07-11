#!/usr/bin/env python3
"""Small App Store Connect release helper for 1S0 Inspector Trainer.

This script intentionally uses only Python standard library modules and the
system openssl binary so release automation does not add app dependencies.
"""

from __future__ import annotations

import argparse
import base64
import json
import os
import ssl
import subprocess
import sys
import time
import urllib.error
import urllib.parse
import urllib.request
from pathlib import Path
from typing import Any


API_BASE = "https://api.appstoreconnect.apple.com/v1"
DEFAULT_APP_ID = "6758813561"
DEFAULT_BUNDLE_ID = "com.abdoulbah.1s0-inspector-trainer"
DEFAULT_PLATFORM = "IOS"
DEFAULT_PROJECT = "1S0 Inspector Trainer.xcodeproj"
DEFAULT_SCHEME = "1S0 Inspector Trainer"
MACOS_CA_BUNDLE = Path("/etc/ssl/cert.pem")


class AscError(RuntimeError):
    pass


def b64url(data: bytes) -> str:
    return base64.urlsafe_b64encode(data).rstrip(b"=").decode("ascii")


def read_der_len(data: bytes, offset: int) -> tuple[int, int]:
    first = data[offset]
    offset += 1
    if first < 0x80:
        return first, offset
    count = first & 0x7F
    if count == 0 or count > 2:
        raise AscError("Unsupported DER length in ECDSA signature")
    value = int.from_bytes(data[offset : offset + count], "big")
    return value, offset + count


def der_ecdsa_to_jose(signature: bytes) -> bytes:
    offset = 0
    if signature[offset] != 0x30:
        raise AscError("Expected DER sequence for ECDSA signature")
    offset += 1
    _, offset = read_der_len(signature, offset)
    if signature[offset] != 0x02:
        raise AscError("Expected DER integer for ECDSA r value")
    offset += 1
    r_len, offset = read_der_len(signature, offset)
    r = signature[offset : offset + r_len]
    offset += r_len
    if signature[offset] != 0x02:
        raise AscError("Expected DER integer for ECDSA s value")
    offset += 1
    s_len, offset = read_der_len(signature, offset)
    s = signature[offset : offset + s_len]
    r = r.lstrip(b"\x00").rjust(32, b"\x00")
    s = s.lstrip(b"\x00").rjust(32, b"\x00")
    if len(r) != 32 or len(s) != 32:
        raise AscError("Unexpected ECDSA signature length")
    return r + s


def sign_es256(signing_input: str, key_path: Path) -> str:
    if not key_path.exists():
        raise AscError(f"Private key not found: {key_path}")
    proc = subprocess.run(
        ["openssl", "dgst", "-sha256", "-sign", str(key_path)],
        input=signing_input.encode("ascii"),
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        check=False,
    )
    if proc.returncode != 0:
        raise AscError(proc.stderr.decode("utf-8", "replace").strip())
    return b64url(der_ecdsa_to_jose(proc.stdout))


def make_token(key_id: str, issuer_id: str | None, key_path: Path, key_type: str) -> str:
    now = int(time.time())
    header = {"alg": "ES256", "kid": key_id, "typ": "JWT"}
    payload: dict[str, Any] = {
        "iat": now,
        "exp": now + 20 * 60,
        "aud": "appstoreconnect-v1",
    }
    if key_type == "individual":
        payload["sub"] = "user"
    else:
        if not issuer_id:
            raise AscError("ASC_ISSUER_ID is required for team API keys")
        payload["iss"] = issuer_id
    signing_input = ".".join(
        [
            b64url(json.dumps(header, separators=(",", ":")).encode("utf-8")),
            b64url(json.dumps(payload, separators=(",", ":")).encode("utf-8")),
        ]
    )
    return f"{signing_input}.{sign_es256(signing_input, key_path)}"


class AscClient:
    def __init__(
        self,
        *,
        key_id: str,
        issuer_id: str | None,
        key_path: Path,
        key_type: str,
    ) -> None:
        self.key_id = key_id
        self.issuer_id = issuer_id
        self.key_path = key_path
        self.key_type = key_type
        self._token = ""
        self._token_at = 0

    def token(self) -> str:
        if not self._token or time.time() - self._token_at > 15 * 60:
            self._token = make_token(
                self.key_id,
                self.issuer_id,
                self.key_path,
                self.key_type,
            )
            self._token_at = time.time()
        return self._token

    def request(
        self,
        method: str,
        path: str,
        *,
        body: dict[str, Any] | None = None,
        query: dict[str, str] | None = None,
    ) -> dict[str, Any]:
        url = path if path.startswith("https://") else f"{API_BASE}{path}"
        if query:
            url = f"{url}?{urllib.parse.urlencode(query)}"
        payload = None
        headers = {
            "Authorization": f"Bearer {self.token()}",
            "Accept": "application/json",
        }
        if body is not None:
            payload = json.dumps(body).encode("utf-8")
            headers["Content-Type"] = "application/json"
        request = urllib.request.Request(url, data=payload, method=method, headers=headers)
        try:
            with urllib.request.urlopen(
                request,
                timeout=60,
                context=default_ssl_context(),
            ) as response:
                data = response.read()
        except urllib.error.HTTPError as error:
            details = error.read().decode("utf-8", "replace")
            raise AscError(f"{method} {url} failed: HTTP {error.code}\n{details}") from error
        if not data:
            return {}
        return json.loads(data.decode("utf-8"))


def default_ssl_context() -> ssl.SSLContext:
    paths = ssl.get_default_verify_paths()
    if paths.cafile or os.environ.get(paths.openssl_cafile_env):
        return ssl.create_default_context()
    if MACOS_CA_BUNDLE.exists():
        return ssl.create_default_context(cafile=str(MACOS_CA_BUNDLE))
    return ssl.create_default_context()


def client_from_env() -> AscClient:
    key_type = os.environ.get("ASC_KEY_TYPE", "team").strip().lower()
    if key_type not in {"team", "individual"}:
        raise AscError("ASC_KEY_TYPE must be either 'team' or 'individual'")
    missing = [
        name
        for name in ("ASC_KEY_ID", "ASC_PRIVATE_KEY_PATH")
        if not os.environ.get(name)
    ]
    if key_type == "team" and not os.environ.get("ASC_ISSUER_ID"):
        missing.append("ASC_ISSUER_ID")
    if missing:
        raise AscError(
            "Missing App Store Connect credentials: "
            + ", ".join(missing)
            + ". Source .env.appstoreconnect first."
        )
    return AscClient(
        key_id=os.environ["ASC_KEY_ID"],
        issuer_id=os.environ.get("ASC_ISSUER_ID"),
        key_path=Path(os.environ["ASC_PRIVATE_KEY_PATH"]).expanduser(),
        key_type=key_type,
    )


def app_id_from_args(client: AscClient, app_id: str | None, bundle_id: str | None) -> str:
    if app_id:
        return app_id
    bundle_id = bundle_id or DEFAULT_BUNDLE_ID
    response = client.request("GET", "/apps", query={"filter[bundleId]": bundle_id})
    apps = response.get("data", [])
    if not apps:
        raise AscError(f"No App Store Connect app found for bundle id {bundle_id}")
    return apps[0]["id"]


def xcode_build_setting(project: str, scheme: str, key: str) -> str | None:
    proc = subprocess.run(
        [
            "xcodebuild",
            "-scheme",
            scheme,
            "-project",
            project,
            "-showBuildSettings",
        ],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
        check=False,
    )
    if proc.returncode != 0:
        return None
    prefix = f"{key} = "
    for line in proc.stdout.splitlines():
        line = line.strip()
        if line.startswith(prefix):
            return line.removeprefix(prefix).strip()
    return None


def get_versions(client: AscClient, app_id: str) -> list[dict[str, Any]]:
    response = client.request(
        "GET",
        f"/apps/{app_id}/appStoreVersions",
        query={
            "limit": "200",
            "include": "build",
            "fields[appStoreVersions]": "platform,versionString,appStoreState,appVersionState,build",
        },
    )
    return response.get("data", [])


def find_version(
    client: AscClient,
    app_id: str,
    version_string: str,
    platform: str = DEFAULT_PLATFORM,
) -> dict[str, Any] | None:
    for version in get_versions(client, app_id):
        attrs = version.get("attributes", {})
        if attrs.get("versionString") == version_string and attrs.get("platform") == platform:
            return version
    return None


def create_version(
    client: AscClient,
    app_id: str,
    version_string: str,
    platform: str = DEFAULT_PLATFORM,
    dry_run: bool = False,
) -> dict[str, Any]:
    body = {
        "data": {
            "type": "appStoreVersions",
            "attributes": {
                "platform": platform,
                "versionString": version_string,
            },
            "relationships": {
                "app": {"data": {"type": "apps", "id": app_id}},
            },
        }
    }
    if dry_run:
        print_json("would_create_app_store_version", body)
        return {"id": "<dry-run-version-id>", "attributes": {"versionString": version_string}}
    return client.request("POST", "/appStoreVersions", body=body)["data"]


def ensure_version(
    client: AscClient,
    app_id: str,
    version_string: str,
    *,
    create: bool,
    dry_run: bool,
) -> dict[str, Any]:
    existing = find_version(client, app_id, version_string)
    if existing:
        return existing
    if not create:
        raise AscError(f"Version {version_string} does not exist and --no-create-version was set")
    return create_version(client, app_id, version_string, dry_run=dry_run)


def patch_whats_new(
    client: AscClient,
    version_id: str,
    whats_new: str,
    *,
    dry_run: bool,
) -> None:
    response = client.request(
        "GET",
        f"/appStoreVersions/{version_id}/appStoreVersionLocalizations",
        query={"limit": "200"},
    )
    localizations = response.get("data", [])
    if not localizations:
        print("No appStoreVersionLocalizations found; skipping whatsNew update", file=sys.stderr)
        return
    for localization in localizations:
        loc_id = localization["id"]
        body = {
            "data": {
                "type": "appStoreVersionLocalizations",
                "id": loc_id,
                "attributes": {"whatsNew": whats_new},
            }
        }
        if dry_run:
            print_json(f"would_update_whats_new_{loc_id}", body)
        else:
            client.request("PATCH", f"/appStoreVersionLocalizations/{loc_id}", body=body)


def find_build(
    client: AscClient,
    app_id: str,
    version_string: str,
    build_number: str,
    *,
    include_processing: bool = False,
) -> dict[str, Any] | None:
    query = {
        "filter[app]": app_id,
        "filter[version]": build_number,
        "sort": "-uploadedDate",
        "limit": "10",
        "include": "preReleaseVersion",
        "fields[builds]": "version,uploadedDate,processingState,preReleaseVersion",
        "fields[preReleaseVersions]": "version,platform",
    }
    if not include_processing:
        query["filter[processingState]"] = "VALID"
    response = client.request("GET", "/builds", query=query)
    included = {item["id"]: item for item in response.get("included", [])}
    for build in response.get("data", []):
        pre_release_data = (
            build.get("relationships", {})
            .get("preReleaseVersion", {})
            .get("data")
            or {}
        )
        pre_release = included.get(pre_release_data.get("id"), {})
        attrs = pre_release.get("attributes", {})
        if attrs.get("version") == version_string:
            return build
    return None


def wait_for_build(
    client: AscClient,
    app_id: str,
    version_string: str,
    build_number: str,
    *,
    timeout_minutes: int,
) -> dict[str, Any]:
    deadline = time.time() + timeout_minutes * 60
    while True:
        build = find_build(client, app_id, version_string, build_number)
        if build:
            return build
        processing = find_build(
            client,
            app_id,
            version_string,
            build_number,
            include_processing=True,
        )
        if processing:
            state = processing.get("attributes", {}).get("processingState", "UNKNOWN")
            print(f"Build {version_string} ({build_number}) processing state: {state}")
        else:
            print(f"Build {version_string} ({build_number}) not visible yet")
        if time.time() > deadline:
            raise AscError(f"Timed out waiting for valid build {version_string} ({build_number})")
        time.sleep(30)


def attach_build(client: AscClient, version_id: str, build_id: str, *, dry_run: bool) -> None:
    body = {"data": {"type": "builds", "id": build_id}}
    if dry_run:
        print_json("would_attach_build", body)
        return
    client.request("PATCH", f"/appStoreVersions/{version_id}/relationships/build", body=body)


def create_review_submission(
    client: AscClient,
    app_id: str,
    version_id: str,
    *,
    dry_run: bool,
    submit: bool,
) -> str:
    submission_body = {
        "data": {
            "type": "reviewSubmissions",
            "attributes": {"platform": DEFAULT_PLATFORM},
            "relationships": {"app": {"data": {"type": "apps", "id": app_id}}},
        }
    }
    if dry_run:
        print_json("would_create_review_submission", submission_body)
        submission_id = "<dry-run-submission-id>"
    else:
        submission_id = client.request("POST", "/reviewSubmissions", body=submission_body)["data"]["id"]

    item_body = {
        "data": {
            "type": "reviewSubmissionItems",
            "relationships": {
                "reviewSubmission": {
                    "data": {"type": "reviewSubmissions", "id": submission_id}
                },
                "appStoreVersion": {
                    "data": {"type": "appStoreVersions", "id": version_id}
                },
            },
        }
    }
    if dry_run:
        print_json("would_create_review_submission_item", item_body)
    else:
        client.request("POST", "/reviewSubmissionItems", body=item_body)

    if submit:
        submit_body = {
            "data": {
                "type": "reviewSubmissions",
                "id": submission_id,
                "attributes": {"submitted": True},
            }
        }
        if dry_run:
            print_json("would_submit_review_submission", submit_body)
        else:
            client.request("PATCH", f"/reviewSubmissions/{submission_id}", body=submit_body)
    else:
        print("Created draft review submission. Re-run with --submit-for-review to submit.")
    return submission_id


def read_text_arg(value: str | None, path: str | None) -> str | None:
    if value and path:
        raise AscError("Use either --whats-new or --whats-new-file, not both")
    if path:
        return Path(path).read_text(encoding="utf-8").strip()
    return value


def print_json(label: str, value: Any) -> None:
    print(f"\n## {label}")
    print(json.dumps(value, indent=2, sort_keys=True))


def command_status(args: argparse.Namespace) -> None:
    client = client_from_env()
    app_id = app_id_from_args(client, args.app_id, args.bundle_id)
    app = client.request("GET", f"/apps/{app_id}")["data"]
    print(f"App: {app.get('attributes', {}).get('name')} ({app_id})")
    print("\nVersions:")
    for version in get_versions(client, app_id):
        attrs = version.get("attributes", {})
        print(
            f"- {attrs.get('versionString')} "
            f"{attrs.get('platform')} "
            f"{attrs.get('appVersionState') or attrs.get('appStoreState')} "
            f"id={version.get('id')}"
        )
    reviews = client.request(
        "GET",
        f"/apps/{app_id}/reviewSubmissions",
        query={"limit": "10", "fields[reviewSubmissions]": "platform,submittedDate,state"},
    )
    print("\nRecent review submissions:")
    for review in reviews.get("data", []):
        attrs = review.get("attributes", {})
        print(f"- {attrs.get('state')} submitted={attrs.get('submittedDate')} id={review.get('id')}")


def command_submit(args: argparse.Namespace) -> None:
    client = client_from_env()
    app_id = app_id_from_args(client, args.app_id, args.bundle_id)
    build_number = args.build_number or os.environ.get("ASC_BUILD_NUMBER")
    if not build_number:
        build_number = xcode_build_setting(args.project, args.scheme, "CURRENT_PROJECT_VERSION")
    if not build_number:
        raise AscError("Could not infer build number. Pass --build-number.")

    whats_new = read_text_arg(args.whats_new, args.whats_new_file)
    version = ensure_version(
        client,
        app_id,
        args.version,
        create=not args.no_create_version,
        dry_run=args.dry_run,
    )
    version_id = version["id"]

    if whats_new:
        patch_whats_new(client, version_id, whats_new, dry_run=args.dry_run)

    build = wait_for_build(
        client,
        app_id,
        args.version,
        build_number,
        timeout_minutes=args.wait_for_build_minutes,
    )
    attach_build(client, version_id, build["id"], dry_run=args.dry_run)
    submission_id = create_review_submission(
        client,
        app_id,
        version_id,
        dry_run=args.dry_run,
        submit=args.submit_for_review,
    )
    print(f"Version id: {version_id}")
    print(f"Build id: {build['id']}")
    print(f"Review submission id: {submission_id}")


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--app-id", default=os.environ.get("ASC_APP_ID", DEFAULT_APP_ID))
    parser.add_argument("--bundle-id", default=os.environ.get("ASC_BUNDLE_ID", DEFAULT_BUNDLE_ID))
    subparsers = parser.add_subparsers(required=True)

    status = subparsers.add_parser("status", help="Show app versions and review submissions")
    status.set_defaults(func=command_status)

    submit = subparsers.add_parser("submit", help="Prepare or submit an App Store version")
    submit.add_argument("--version", required=True, help="Marketing version, e.g. 1.5")
    submit.add_argument("--build-number", help="Bundle build number; defaults to CURRENT_PROJECT_VERSION")
    submit.add_argument("--project", default=DEFAULT_PROJECT)
    submit.add_argument("--scheme", default=DEFAULT_SCHEME)
    submit.add_argument("--whats-new", help="Release notes text")
    submit.add_argument("--whats-new-file", help="Path to release notes text file")
    submit.add_argument("--wait-for-build-minutes", type=int, default=30)
    submit.add_argument("--no-create-version", action="store_true")
    submit.add_argument("--submit-for-review", action="store_true")
    submit.add_argument("--dry-run", action="store_true")
    submit.set_defaults(func=command_submit)
    return parser


def main() -> int:
    parser = build_parser()
    args = parser.parse_args()
    try:
        args.func(args)
        return 0
    except AscError as error:
        print(f"error: {error}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
