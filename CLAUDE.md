# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is the GPSA (Greater Peninsula Swimming Association) Rulebook project. It uses **Quarto** to build a multi-format publication from Markdown source files:

- **HTML website** (GitHub Pages) at `public-html/`
- **PDF document** with custom GPSA branding
- **ePub format** for e-readers

The source files are individual Markdown chapters that Quarto assembles into complete publications.

## Build System

### Building the Rulebook

**Build all formats (PDF, HTML, ePub):**
```bash
./build-quarto.sh
```

Or manually:
```bash
quarto render
```

**Build specific formats:**
```bash
quarto render --to pdf
quarto render --to html
quarto render --to epub
```

**Live preview with auto-reload:**
```bash
quarto preview
```

### Requirements

- **Quarto** (install: `brew install quarto` or download from https://quarto.org)
- **TinyTeX** for PDF generation (install: `quarto install tinytex`)

### Deployment

**The site is automatically deployed to `rulebook.gpsaswimming.org` via GitHub Pages.**

- Push to `main` branch triggers `.github/workflows/publish.yml`
- GitHub Actions builds all formats and deploys to GitHub Pages
- Site updates in ~3-5 minutes
- Check the **Actions** tab on GitHub to monitor deployment status

**For local testing only:**
- Run `quarto render` to build to `docs/`
- Do not commit the `docs/` directory (GitHub Actions builds it)
- The workflow handles all deployment automatically

## Architecture

### Configuration Structure

The build system uses a hierarchical configuration:

1. **`_quarto.yml`** - Main Quarto configuration
   - Defines book structure and chapter order
   - Configures output formats (HTML, PDF, ePub)
   - Sets up navigation, sidebar, and branding
   - Output directory: `public-html/`

2. **`_metadata.yml`** - Document metadata and draft control
   - Contains `gpsa_draft: true/false` flag
   - This controls draft watermarks and banners (see Draft Mode below)

3. **`_custom.scss`** - GPSA brand styling
   - Defines brand colors (Navy: #002366, Red: #d9242b)
   - Styles tables, headers, navigation, callouts
   - Applies to HTML output

### Draft Mode System

This project uses a **custom draft system** (not Quarto's native draft feature, which breaks sidebar navigation):

**Controlled by `_metadata.yml`:**
- `gpsa_draft: true` → Adds "DRAFT" watermark to PDF and banner to HTML
- `gpsa_draft: false` → Production-ready, no draft indicators

**Implementation via Lua filters** (in `filters/`):
- `draft-watermark.lua` - Adds diagonal "DRAFT" watermark to PDF pages
- `draft-banner.lua` - Injects sticky banner at top of HTML pages

These filters check `gpsa_draft` metadata and inject LaTeX (PDF) or HTML/CSS (web) accordingly.

### Chapter Management

**Chapters are listed in `_quarto.yml` under `book.chapters`:**
```yaml
chapters:
  - index.qmd
  - definitions.md
  - eligibility-and-rosters.md
  - officials.md
  # ... etc
```

To add a new chapter:
1. Create the `.md` file in the root directory
2. Add it to the `chapters` list in `_quarto.yml`
3. Run `quarto render`

### Output Structure

- **HTML**: Published to `public-html/` (likely served via GitHub Pages)
- **PDF**: `public-html/GPSA-Rulebook.pdf` with custom GPSA-branded cover
- **ePub**: `public-html/GPSA-Rulebook.epub` with cover from `ePub_Cover.png`

### GPSA Branding

The PDF includes custom LaTeX styling (defined in `_quarto.yml`):
- Custom title page with GPSA logo (`gpsa_logo.png`)
- Navy blue section headings with red underlines
- Custom headers/footers with GPSA branding
- Chapters styled as numbered sections (no "Chapter" prefix)

Colors are defined in `_custom.scss` and referenced in LaTeX:
- `GPSANavy`: #002366
- `GPSARed`: #d9242b

## Content Files

All content is in Markdown format at the root level:
- `index.qmd` - Homepage (Quarto Markdown format)
- `definitions.md` - Key terms
- `eligibility-and-rosters.md` - Swimmer requirements
- `officials.md` - Official roles and certification
- `order-of-events.md` - Event structure and schedules
- `conduct-of-meets.md` - Meet procedures
- `scoring.md` - Point systems
- `awards.md` - Recognition and trophies
- `facilities.md` - Pool standards

## Common Tasks

### Changing Draft Status

Edit `_metadata.yml`:
```yaml
gpsa_draft: true   # Draft mode ON
gpsa_draft: false  # Production mode (no draft indicators)
```

Then rebuild: `quarto render`

### Modifying Styles

**HTML styling:**
- Edit `_custom.scss`
- Changes apply to website only

**PDF styling:**
- Edit LaTeX commands in `_quarto.yml` under `format.pdf.include-in-header`
- Or adjust geometry, colors, fonts in PDF format section

### Updating Chapter Order

Edit the `chapters` list in `_quarto.yml`, then rebuild.

### Troubleshooting Build Issues

**PDF won't build:**
- Ensure TinyTeX is installed: `quarto install tinytex`
- Check for LaTeX syntax errors in `_quarto.yml` header section

**HTML output location wrong:**
- Verify `output-dir: public-html` in `_quarto.yml`

**Draft indicators not appearing:**
- Check `gpsa_draft` value in `_metadata.yml`
- Ensure filters are listed in `_quarto.yml` filters section
- Rebuild with `quarto render`

**Changes not visible:**
- Clear cache: `quarto render --cache-refresh`
- Check you're editing source `.md` files, not generated output

## GitHub Pages Deployment

This repository is configured for automated deployment to `rulebook.gpsaswimming.org`.

### Configuration Files

- **`CNAME`** - Contains custom domain, copied to `docs/CNAME` by Quarto
- **`.nojekyll`** - Prevents Jekyll processing, copied to `docs/.nojekyll` by Quarto
- **`.github/workflows/publish.yml`** - GitHub Actions workflow for build and deploy

### Workflow Process

1. Push to `main` triggers the workflow
2. Workflow installs Quarto and TinyTeX
3. Runs `quarto render` to build all formats
4. Uploads `docs/` directory as GitHub Pages artifact
5. Deploys to GitHub Pages using `actions/deploy-pages@v4`

### GitHub Repository Settings

**Required setup** (one-time):
- Settings → Pages → Source: "GitHub Actions"
- Settings → Pages → Custom domain: `rulebook.gpsaswimming.org`
- Settings → Pages → Enforce HTTPS: enabled

**DNS Configuration:**
- CNAME record: `rulebook` → `<github-username>.github.io`
- Or A records pointing to GitHub Pages IPs (see GITHUB-PAGES-SETUP.md)

### Important Notes

- **Do not commit `docs/` directory** - GitHub Actions generates it
- **CNAME and .nojekyll** are automatically copied from root to `docs/` during build
- Draft mode (`gpsa_draft: true`) does not prevent deployment
- Build failures appear in the Actions tab on GitHub

## Key Differences from Standard Quarto

1. **Custom draft system** using `gpsa_draft` metadata field instead of Quarto's native `draft` (which breaks navigation)
2. **Lua filters** for draft watermark/banner injection
3. **Extensive LaTeX customization** in `_quarto.yml` for PDF branding
4. **Fixed header** CSS in `_custom.scss` to override Headroom.js scrolling behavior
5. **Automated GitHub Pages deployment** via GitHub Actions workflow
