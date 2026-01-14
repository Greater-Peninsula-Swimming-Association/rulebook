# GitHub Pages Setup Guide

This guide explains how to configure GitHub Pages to host the GPSA Rulebook at `rulebook.gpsaswimming.org`.

## Overview

The rulebook is automatically built and deployed using GitHub Actions whenever changes are pushed to the `main` branch. The site is served from the `docs/` directory via GitHub Pages.

## Initial GitHub Repository Setup

### 1. Enable GitHub Pages

1. Go to your repository settings on GitHub
2. Navigate to **Settings** → **Pages**
3. Under **Build and deployment**:
   - **Source**: Select "GitHub Actions"
   - This allows the workflow to deploy directly without using a branch

### 2. Configure Custom Domain

In the same GitHub Pages settings:

1. Under **Custom domain**, enter: `rulebook.gpsaswimming.org`
2. Click **Save**
3. Check **Enforce HTTPS** (wait for SSL certificate to provision, usually 5-10 minutes)

**Note:** The `CNAME` file in the repository root is automatically copied to the `docs/` output directory by Quarto during builds.

## DNS Configuration

You need to configure DNS records at your domain registrar (wherever `gpsaswimming.org` is hosted) to point `rulebook.gpsaswimming.org` to GitHub Pages.

### Required DNS Records

Add the following DNS records:

**Option 1: Using CNAME (Recommended)**
```
Type: CNAME
Name: rulebook
Value: <your-github-username>.github.io
TTL: 3600 (or default)
```

Replace `<your-github-username>` with your actual GitHub username or organization name.

**Option 2: Using A Records (if CNAME doesn't work)**
```
Type: A
Name: rulebook
Value: 185.199.108.153
TTL: 3600

Type: A
Name: rulebook
Value: 185.199.109.153
TTL: 3600

Type: A
Name: rulebook
Value: 185.199.110.153
TTL: 3600

Type: A
Name: rulebook
Value: 185.199.111.153
TTL: 3600
```

### DNS Propagation

- DNS changes can take **5 minutes to 48 hours** to propagate globally
- Check propagation status: https://www.whatsmydns.net/
- You can test locally: `dig rulebook.gpsaswimming.org` or `nslookup rulebook.gpsaswimming.org`

## How the Deployment Works

### Automatic Deployment

1. **Trigger**: Push to `main` branch or manual workflow dispatch
2. **Build**: GitHub Actions runs the workflow (`.github/workflows/publish.yml`)
   - Checks out the code
   - Installs Quarto and TinyTeX
   - Runs `quarto render` to build HTML, PDF, and ePub
   - Uploads the `docs/` directory as an artifact
3. **Deploy**: Deploys the artifact to GitHub Pages
4. **Available**: Site is live at `https://rulebook.gpsaswimming.org`

### Build Time

- Typical build: **2-4 minutes**
- TinyTeX installation (first time): adds ~1-2 minutes
- Deployment: ~30 seconds

### Manual Deployment

You can trigger a deployment manually:

1. Go to **Actions** tab in GitHub
2. Select **Build and Deploy Rulebook** workflow
3. Click **Run workflow** → **Run workflow**

## Local Development

### Building Locally

```bash
# Build all formats (HTML, PDF, ePub)
quarto render

# Or use the build script
./build-quarto.sh
```

Output is generated to `docs/` directory.

### Preview Before Deploying

```bash
# Start live preview server
quarto preview
```

This opens a browser with live-reload when you edit files.

### Testing the Built Site Locally

```bash
# Serve the built HTML from docs/ directory
python3 -m http.server 8000 --directory docs

# Then open: http://localhost:8000
```

## Workflow Configuration

The workflow is defined in `.github/workflows/publish.yml`:

- **Triggers**: Push to `main`, manual dispatch
- **Permissions**: Read contents, write to Pages
- **Concurrency**: Only one deployment at a time
- **Jobs**:
  - `build`: Installs Quarto, renders the site, uploads artifact
  - `deploy`: Deploys artifact to GitHub Pages

### Key Settings in `_quarto.yml`

```yaml
project:
  output-dir: docs       # GitHub Pages serves from here
  resources:
    - CNAME              # Copied to docs/ for custom domain
    - .nojekyll          # Prevents Jekyll processing

book:
  site-url: https://rulebook.gpsaswimming.org  # Production URL
```

## Troubleshooting

### Site Not Loading

1. **Check GitHub Actions**:
   - Go to **Actions** tab
   - Verify the latest workflow run succeeded (green checkmark)
   - Click on failed workflows to see error logs

2. **Check GitHub Pages Settings**:
   - Settings → Pages
   - Verify source is "GitHub Actions"
   - Verify custom domain is set correctly
   - Check if HTTPS is enforced

3. **Check DNS**:
   - Run: `dig rulebook.gpsaswimming.org`
   - Should point to GitHub Pages IPs or `<username>.github.io`
   - If not, DNS hasn't propagated or records are incorrect

### Build Failures

**TinyTeX installation fails**:
- Usually a transient network issue
- Re-run the workflow (it caches TinyTeX after first success)

**Quarto render fails**:
- Check the workflow logs for specific errors
- Common issues: Lua filter syntax, LaTeX errors, missing files
- Test locally first: `quarto render`

**PDF generation fails**:
- Check that TinyTeX installed successfully
- Look for LaTeX compilation errors in logs
- Verify `_quarto.yml` LaTeX configuration is valid

### HTTPS Certificate Issues

- After setting custom domain, HTTPS can take **5-10 minutes** to provision
- If it fails, try:
  1. Remove custom domain from GitHub Pages settings
  2. Wait 5 minutes
  3. Re-add custom domain
  4. Wait for certificate to provision

### CNAME File Missing

If the custom domain setting keeps getting reset:
- Verify `CNAME` file exists in repository root
- Verify `_quarto.yml` includes `CNAME` in `resources`
- Check that `docs/CNAME` exists after build

## Updating the Site

### Standard Workflow

1. Edit Markdown files locally
2. Test with `quarto preview`
3. Commit and push to `main`:
   ```bash
   git add .
   git commit -m "Update rulebook content"
   git push origin main
   ```
4. GitHub Actions automatically builds and deploys
5. Check the **Actions** tab to monitor progress
6. Site updates in ~3-5 minutes

### Draft Mode

Edit `_metadata.yml`:
```yaml
gpsa_draft: true   # Adds DRAFT watermark and banner
gpsa_draft: false  # Production mode
```

Draft mode adds visual indicators without affecting deployment.

## Monitoring

### Checking Deployment Status

- **Actions Tab**: See all workflow runs and their status
- **Pages Settings**: Shows last deployment time and URL
- **Visit Site**: `https://rulebook.gpsaswimming.org`

### Logs

- Click on any workflow run to see detailed logs
- Each step (setup, build, deploy) has its own log section
- Logs are retained for 90 days

## Security

- Workflow uses GitHub's `GITHUB_TOKEN` with minimal permissions
- Only `main` branch triggers deployments
- Custom domain uses HTTPS (enforced)
- No secrets or API keys required

## Questions?

- **Quarto Documentation**: https://quarto.org/docs/publishing/github-pages.html
- **GitHub Pages Docs**: https://docs.github.com/en/pages
- **DNS Issues**: Contact your domain registrar's support
- **Repository Issues**: Check the Actions tab for workflow logs
