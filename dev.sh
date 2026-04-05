#!/usr/bin/env bash
#  dev.sh  —  Resume dev loop
#
#  Usage:  ./dev.sh
#
#  What it does:
#    1. Compiles main.tex → output/Daksh_Resume.pdf  (pdflatex)
#    2. Copies the PDF into docs/ so the viewer picks it up
#    3. Starts a local HTTP server at http://localhost:8000
#    4. Watches main.tex + resume.cls for saves → re-compiles
#
#  Requirements:  pdflatex  +  python3   (both usually pre-installed)
#  Optional:      inotifywait  (from inotify-tools, for live watch)

set -e

ROOT="$(cd "$(dirname "$0")" && pwd)"
TEX="$ROOT/main.tex"
OUT_DIR="$ROOT/output"
DOCS_DIR="$ROOT/docs"
PDF_NAME="Daksh_Resume.pdf"
PORT=8000

GREEN="\033[0;32m"
CYAN="\033[0;36m"
YELLOW="\033[1;33m"
RESET="\033[0m"

log()  { echo -e "${CYAN}[dev]${RESET} $*"; }
ok()   { echo -e "${GREEN}[ok]${RESET}  $*"; }
warn() { echo -e "${YELLOW}[warn]${RESET} $*"; }

compile() {
  log "Compiling LaTeX..."
  pdflatex -interaction=nonstopmode -output-directory="$OUT_DIR" "$TEX" \
    > "$OUT_DIR/compile.log" 2>&1 && ok "Compiled successfully" \
    || { warn "pdflatex errors — check output/compile.log"; return 1; }

  # copy into docs so the viewer is always fresh
  cp "$OUT_DIR/$PDF_NAME" "$DOCS_DIR/$PDF_NAME"
  ok "PDF → docs/$PDF_NAME"
}

if ! command -v pdflatex &>/dev/null; then
  echo -e "\n  pdflatex not found! Install with:\n    sudo apt install texlive-latex-base texlive-fonts-recommended\n"
  exit 1
fi

mkdir -p "$OUT_DIR"

# initial compile
compile

#  start server 
log "Starting HTTP server at ${GREEN}http://localhost:$PORT${RESET}"
(cd "$DOCS_DIR" && python3 -m http.server $PORT --bind 127.0.0.1 2>/dev/null) &
SERVER_PID=$!

# open browser (best-effort, non-blocking)
sleep 0.5
if command -v xdg-open &>/dev/null;      then xdg-open "http://localhost:$PORT" &>/dev/null &
elif command -v open &>/dev/null;        then open "http://localhost:$PORT" &>/dev/null &
fi

# watch loop
cleanup() {
  log "Stopping server..."
  kill "$SERVER_PID" 2>/dev/null || true
  exit 0
}
trap cleanup INT TERM

if command -v inotifywait &>/dev/null; then
  log "Watching main.tex and resume.cls for changes  (Ctrl-C to stop)"
  while inotifywait -q -e close_write "$ROOT/main.tex" "$ROOT/resume.cls"; do
    compile
  done
else
  warn "inotifywait not found — auto-watch disabled."
  warn "Install with:  sudo apt install inotify-tools"
  log  "Server running. Ctrl-C to stop. Re-run ./dev.sh after each edit."
  wait "$SERVER_PID"
fi

cleanup
