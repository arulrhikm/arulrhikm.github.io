#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

stage_cv() {
  test -f arul_rhik_mazumder_cv.pdf
  mkdir -p cv
  cp arul_rhik_mazumder_cv.pdf cv/cv.pdf

  built="$(date -u +%Y%m%d%H%M%S)"
  printf '{"built":"%s","source":"arul_rhik_mazumder_cv.tex"}\n' "$built" > cv/build-info.json
  echo "Wrote cv/cv.pdf and cv/build-info.json (built=$built)"
}

build_cv() {
  echo "Building CV from arul_rhik_mazumder_cv.tex ..."
  if command -v latexmk >/dev/null 2>&1; then
    latexmk -pdf -interaction=nonstopmode -file-line-error arul_rhik_mazumder_cv.tex
  elif command -v tectonic >/dev/null 2>&1; then
    tectonic -X compile arul_rhik_mazumder_cv.tex --outdir .
  else
    echo "Install latexmk or tectonic to build the CV." >&2
    exit 1
  fi

  stage_cv
}

if [[ "${1:-}" == "--stage-only" ]]; then
  stage_cv
elif [[ "${1:-}" == "--watch" ]]; then
  echo "Watching arul_rhik_mazumder_cv.tex — save the file to rebuild. Ctrl+C to stop."
  build_cv
  if command -v latexmk >/dev/null 2>&1; then
    latexmk -pdf -pvc -interaction=nonstopmode -file-line-error arul_rhik_mazumder_cv.tex &
    pid=$!
    trap 'kill "$pid" 2>/dev/null || true' EXIT
    while kill -0 "$pid" 2>/dev/null; do
      if [[ cv/cv.pdf -ot arul_rhik_mazumder_cv.pdf ]]; then
        stage_cv
      fi
      sleep 1
    done
  else
    while true; do
      inotifywait -e close_write -q "$ROOT/arul_rhik_mazumder_cv.tex" 2>/dev/null || sleep 2
      build_cv || true
    done
  fi
else
  build_cv
fi
