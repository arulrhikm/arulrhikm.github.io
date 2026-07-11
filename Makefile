.PHONY: cv cv-watch clean

cv:
	bash scripts/build-cv.sh

cv-watch:
	bash scripts/build-cv.sh --watch

clean:
	-if command -v latexmk >/dev/null 2>&1; then latexmk -c arul_rhik_mazumder_cv.tex; fi
	rm -f arul_rhik_mazumder_cv.pdf
