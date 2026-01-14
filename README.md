# GPSA Rulebook - Quarto Build System

This directory contains the source files and build system for the GPSA Rulebook, which is published in both **PDF** and **HTML** formats using [Quarto](https://quarto.org).

## Directory Structure

```
rulebook/
├── _quarto.yml             # Quarto configuration (main settings)
├── _metadata.yml           # Document metadata (DRAFT STATUS HERE!)
├── _custom.scss            # GPSA brand styling (navy #002366, red #d9242b)
├── .github/
│   └── workflows/
│       └── publish.yml     # GitHub Actions workflow for auto-deployment
├── filters/                # Lua filters for draft mode
│   ├── draft-watermark.lua
│   └── draft-banner.lua
├── index.qmd               # Homepage (Quarto markdown)
├── definitions.md          # Markdown source files (edit these!)
├── eligibility-and-rosters.md
├── officials.md
├── order-of-events.md
├── conduct-of-meets.md
├── scoring.md
├── awards.md
├── facilities.md
├── CNAME                   # Custom domain configuration
├── .nojekyll               # GitHub Pages configuration
└── build-quarto.sh         # Build script for both PDF and HTML

# Output directory (auto-generated):
docs/                        # HTML, PDF, ePub output (served by GitHub Pages)
├── *.html                  # HTML pages
├── GPSA-Rulebook.pdf       # PDF output
├── GPSA-Rulebook.epub      # ePub output
└── CNAME                   # Custom domain (copied from root)
```

## 🚨 Draft Mode

**IMPORTANT:** The draft status is controlled by `_metadata.yml`:

```yaml
gpsa_draft: true   # Document is a DRAFT (shows banner, blocks merge to main)
gpsa_draft: false  # Document is FINAL (no banner, ready for production)
```

### How Draft Mode Works

**When `draft: true`:**

- ✅ HTML: Automatic draft banner at top of every page
- ✅ GitHub Actions: Prevents merging to `main` branch
- ✅ Clear visual indicator that content is not final

**When `draft: false`:**

- ✅ No draft banners
- ✅ Can merge to `main` branch
- ✅ Production-ready

### Changing Draft Status

**To mark as draft:**

```bash
# Edit _metadata.yml
draft: true
```

**To mark as final:**

```bash
# Edit _metadata.yml
draft: false
```

**That's it!** Quarto handles everything else automatically.

## Quick Start

### Prerequisites

**Install Quarto:**

**macOS (Homebrew):**

```bash
brew install quarto
```

**Alternative:**
Download from https://quarto.org/docs/get-started/

**Install TinyTeX (for PDF):**

```bash
quarto install tinytex
```

**Verify installation:**

```bash
quarto --version
```

### Building Both Formats

Run the build script:

```bash
./build-quarto.sh
```

This single command will:

1. ✅ Generate PDF → `docs/GPSA-Rulebook.pdf`
2. ✅ Build HTML website → `docs/`
3. ✅ Generate ePub → `docs/GPSA-Rulebook.epub`

**Or build manually:**

```bash
quarto render
```

### Building Individual Formats

**PDF only:**

```bash
quarto render --to pdf
```

**HTML only:**

```bash
quarto render --to html
```

**ePub only:**

```bash
quarto render --to epub
```

## Development Workflow

### Editing Content

1. **Edit Markdown files** (`.md` files in the repository root)
2. Preview changes locally (see below)
3. Commit and push to `main` branch
4. GitHub Actions automatically builds and deploys to `rulebook.gpsaswimming.org`

### Preview While Editing

**Live preview with auto-reload:**

```bash
quarto preview
```

This opens a browser window that automatically updates when you save changes. Press `Ctrl+C` to stop.

### Deployment

**Automatic deployment:**
- Push to `main` branch triggers GitHub Actions
- Workflow builds all formats and deploys to GitHub Pages
- Site updates at `https://rulebook.gpsaswimming.org` in ~3-5 minutes

**Manual deployment:**
- Go to **Actions** tab on GitHub
- Select **Build and Deploy Rulebook**
- Click **Run workflow**

See [GITHUB-PAGES-SETUP.md](GITHUB-PAGES-SETUP.md) for detailed deployment configuration.

### Making Changes

**Local development:**
1. Edit Markdown files
2. Run `quarto preview` to see changes live
3. Run `quarto render` to build final outputs

**Deploy to production:**
1. Commit your changes: `git add . && git commit -m "Update content"`
2. Push to main: `git push origin main`
3. GitHub Actions automatically builds and deploys

## Configuration

### Book Metadata

Edit `_quarto.yml` to change:

- Title, subtitle, author, date
- Chapter order
- Theme settings
- Headers and footers

### Draft Status

Edit `_metadata.yml`:

```yaml
draft: true   # or false
```

### Styling

**GPSA Brand Colors** (defined in `_custom.scss`):

- **Navy Blue:** `#002366` (primary color, headings)
- **Light Blue:** `#0033a0` (links)
- **Red:** `#d9242b` (secondary/accent)
- **Dark Red:** `#b81e24` (hover states)

**To customize styling:**

- Edit `_custom.scss` for global changes
- HTML themes: Set in `_quarto.yml` under `format.html.theme`
- PDF layout: Set in `_quarto.yml` under `format.pdf`

### Chapter Order

Chapters are listed in `_quarto.yml` under `book.chapters`:

```yaml
chapters:
  - index.md
  - docs/definitions.md
  - docs/eligibility-and-rosters.md
  # ... etc
```

To add a new chapter:

1. Create `.md` file in `docs/`
2. Add to `chapters` list in `_quarto.yml`
3. Run `quarto render`

## Output Details

### HTML Website

- **Location:** `docs/` (served by GitHub Pages at `rulebook.gpsaswimming.org`)
- **Theme:** Cosmo (light) with GPSA customization
- **Features:**
   - Responsive navigation
   - Automatic table of contents
   - Full-text search
   - Mobile-friendly
   - Sticky header
   - GPSA branded colors throughout

### PDF Document

- **Location:** `docs/GPSA-Rulebook.pdf`
- **Format:** Letter size, report class, single-sided
- **Features:**
   - Custom GPSA-branded cover page with logo
   - Numbered sections (no "Chapter" labels)
   - Navy blue section headings with red underlines
   - Professional headers and footers
   - GPSA colors throughout
   - Optimized for digital viewing and printing

### ePub Document

- **Location:** `docs/GPSA-Rulebook.epub`
- **Format:** ePub3 for e-readers
- **Features:**
   - Custom cover image
   - Numbered sections
   - Optimized for e-readers and mobile devices

## GitHub Actions

A workflow (`.github/workflows/publish.yml`) automatically:

- ✅ Triggers on push to `main` branch
- ✅ Installs Quarto and TinyTeX
- ✅ Renders all formats (HTML, PDF, ePub)
- ✅ Deploys to GitHub Pages
- ✅ Site goes live at `https://rulebook.gpsaswimming.org`

**Deployment process:**

1. Edit and commit changes locally
2. Push to `main` branch
3. GitHub Actions builds and deploys automatically
4. Check **Actions** tab to monitor progress
5. Site updates in ~3-5 minutes

**Note:** Draft mode (`gpsa_draft: true` in `_metadata.yml`) adds visual indicators but does not prevent deployment. Use branches or PRs for review workflows.

## Troubleshooting

**Quarto not found:**

- Install Quarto: `brew install quarto` (macOS)
- Or download: https://quarto.org/docs/get-started/

**PDF won't build:**

- Ensure TinyTeX is installed: `quarto install tinytex`
- Check for LaTeX errors in console output

**HTML output location wrong:**

- Check `output-dir` in `_quarto.yml`
- Should be: `docs`

**Changes not appearing:**

- Clear cache: `quarto render --cache-refresh`
- Check you're editing source `.md` files in the root, not files in `docs/` output directory
- For deployed site, check GitHub Actions for build failures

**Styling issues:**

- Check `_custom.scss` for syntax errors
- Verify SCSS variables are defined before use

**Draft banner not appearing:**

- Check `_metadata.yml` has `draft: true`
- Rebuild with `quarto render`

**Can't merge to main:**

- Check `_metadata.yml` - must be `draft: false`
- GitHub Actions will block merge if draft is true

## GitHub Pages Integration

The site is hosted at `https://rulebook.gpsaswimming.org` via GitHub Pages.

**How it works:**

1. Push to `main` triggers GitHub Actions workflow
2. Workflow builds the site with Quarto
3. Generated files in `docs/` are deployed to GitHub Pages
4. Site is live at the custom domain

**Initial setup required** (one-time):

1. Enable GitHub Pages in repository settings
2. Set source to "GitHub Actions"
3. Configure custom domain: `rulebook.gpsaswimming.org`
4. Configure DNS at your domain registrar (see [GITHUB-PAGES-SETUP.md](GITHUB-PAGES-SETUP.md))

**Custom domain:**
- The `CNAME` file in the root contains `rulebook.gpsaswimming.org`
- Quarto automatically copies it to `docs/CNAME` during builds
- The `.nojekyll` file prevents Jekyll processing

For detailed setup instructions, see [GITHUB-PAGES-SETUP.md](GITHUB-PAGES-SETUP.md).

## Advantages Over MkDocs+Pandoc

**Simpler:**

- ✅ One config file instead of multiple
- ✅ One build command instead of chained scripts
- ✅ No assembly step needed
- ✅ Native multi-file support

**More Powerful:**

- ✅ Better cross-references: `@sec-officials` syntax
- ✅ Native callouts: `:::{.callout-note}` for important info
- ✅ Built-in draft mode
- ✅ Code execution support (if needed for calculations)
- ✅ Publication-quality PDF by default
- ✅ Better table handling

**Easier Maintenance:**

- ✅ Single source of truth
- ✅ Industry-standard tool (used by RStudio, Observable, academic publishers)
- ✅ Active development and community support
- ✅ Native draft/production workflow

## Questions?

**Quarto Documentation:** https://quarto.org/docs/guide/
**Quarto Books:** https://quarto.org/docs/books/
**Draft Mode:** https://quarto.org/docs/websites/website-tools.html#draft-content
**GPSA Webmaster:** Contact through your GPSA Representative
