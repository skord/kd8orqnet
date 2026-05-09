# bin/gallery — photo galleries on R2

Two-step authoring for posts that include a photo gallery. Photos are uploaded
to Cloudflare R2; only the manifest (URLs + captions) lands in git.

## One-time setup

1. **Create the R2 bucket.** In the Cloudflare dashboard, R2 → Create bucket →
   `mikedanko-photos` (or your name; override with `R2_REMOTE` env var).

2. **Connect a custom domain.** R2 → bucket → Settings → Public access →
   Connect domain. Use something like `photos.mikedanko.me`. Avoid the
   `r2.dev` URL — it's rate-limited and not for production.

3. **API token.** R2 → Manage R2 API Tokens → Create token (read+write on the
   bucket). Note the access key ID, secret, and S3 endpoint URL
   (`https://<account>.r2.cloudflarestorage.com`).

4. **Configure rclone.** Run `rclone config`:
   - `n` (new remote); the remote name must match the first half of `R2_REMOTE` in `bin/gallery` (default: `mikedanko-photos`)
   - storage: `s3`
   - provider: `Cloudflare`
   - paste access key + secret
   - region: `auto`
   - endpoint: the S3 endpoint URL from step 3
   - leave the rest at defaults

   Verify with `rclone ls <remote>:<bucket>`. If the token is scoped to a
   single bucket, `rclone lsd <remote>:` will return AccessDenied (no
   ListBuckets) — that's expected. The script uses `--s3-no-check-bucket` so
   uploads work without that permission.

5. **Install ImageMagick.** `magick --version` (or `convert --version` on
   older systems). Fedora: `sudo dnf install ImageMagick`.

No CORS configuration is needed — `<img>` loads and lightGallery don't trigger
preflight requests.

## Authoring a post with a gallery

```bash
bin/gallery new my-trip
# edit _drafts/my-trip.md (title, body)
# drop full-resolution photos into _drafts/galleries/my-trip/
bin/gallery publish my-trip
# review _posts/<today>-my-trip.md, fill in captions, commit
```

`new` scaffolds a draft and a gitignored photo staging directory. `publish`
generates 1200px thumbnails, uploads originals + thumbs to R2, and writes the
post with the `gallery:` manifest injected into front matter.

`_drafts/galleries/` is gitignored — raw photos never end up in the repo.

## Env overrides

```
R2_REMOTE=r2:other-bucket bin/gallery publish ...
PUBLIC_BASE=https://example.com bin/gallery publish ...
THUMB_WIDTH=800 bin/gallery publish ...
```

## Re-publishing

Not supported in v1. After `publish`, the draft is gone. To add or remove
photos later, edit the post's `gallery:` block by hand and re-upload only the
new files with `rclone copy _drafts/galleries/<slug> r2:.../galleries/<slug>`.
