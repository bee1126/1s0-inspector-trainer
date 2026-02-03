# Hosting the App Store URLs

App Store Connect expects publicly reachable **HTTPS** links for Support/Privacy (and optionally Marketing).

This folder contains simple static pages you can host anywhere:
- `index.html` (marketing page)
- `support.html` (support page)
- `privacy.html` (privacy policy)

## Option A: GitHub Pages (easy)
1. Push this repo to GitHub.
2. In GitHub → Settings → Pages:
   - Source: `Deploy from a branch`
   - Branch: `main` (or `master`)
   - Folder: `/docs`
3. Your URLs will look like:
   - `https://<username>.github.io/<repo>/`
   - `https://<username>.github.io/<repo>/support.html`
   - `https://<username>.github.io/<repo>/privacy.html`

## Option B: Any static host
Upload the `docs/` folder to any static host (Netlify, Vercel, S3, Cloudflare Pages, etc.) and use the resulting HTTPS URLs.

## Don’t forget
Update placeholders (support email/name) in the HTML files before publishing.

