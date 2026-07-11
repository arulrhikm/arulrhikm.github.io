# arulrhikm.github.io

Personal site of [Arul Rhik Mazumder](https://arulrhikm.github.io).

## Structure

- **About** (`index.html`) — bio, news, selected papers
- **Publications** (`publications.html`) — full publication list and quantum projects
- **CV** (`cv/`) — PDF built from LaTeX on every deploy

## Updating your CV

1. Edit [`arul_rhik_mazumder_cv.tex`](arul_rhik_mazumder_cv.tex)
2. Push to `main`
3. GitHub Actions compiles the PDF and deploys the site

The live PDF is served at `cv/cv.pdf`.

### Local preview

```bash
make cv
```

Requires a LaTeX distribution with XeLaTeX and `latexmk`.

### One-time GitHub setup

In **Settings → Pages**, set the source to **GitHub Actions** (not “Deploy from branch”).

## Updating publications

Sync [`publications.html`](publications.html) and the Selected Papers section on the About page when you add entries to the CV publications section.

Legacy pages (`courses.html`, `blog.html`) are kept on disk but not linked from the nav.
