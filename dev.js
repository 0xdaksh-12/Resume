#!/usr/bin/env node
//  dev.js  —  Resume dev tooling (Node.js)
//
//  Usage:   npm run dev
//           node dev.js
//
//  Requires: node >= 18, pdflatex on PATH
//  Deps:     chokidar (npm install)

import { spawnSync, execSync } from "child_process";
import { createServer } from "http";
import { readFileSync, copyFileSync, mkdirSync, existsSync } from "fs";
import { extname, join, resolve } from "path";
import { fileURLToPath } from "url";
import chokidar from "chokidar";

const ROOT = resolve(fileURLToPath(import.meta.url), "..");
const TEX = join(ROOT, "main.tex");
const CLS = join(ROOT, "resume.cls");
const OUT_DIR = join(ROOT, "output");
const DOCS_DIR = join(ROOT, "docs");
const PDF_SRC = join(OUT_DIR, "Daksh_Resume.pdf");
const PDF_DEST = join(DOCS_DIR, "Daksh_Resume.pdf");
const PORT = 8000;

const C = {
  reset: "\x1b[0m",
  cyan: "\x1b[36m",
  green: "\x1b[32m",
  yellow: "\x1b[33m",
  red: "\x1b[31m",
};

const log = (...m) => console.log(`${C.cyan}[dev]${C.reset}`, ...m);
const ok = (...m) => console.log(`${C.green}[ok] ${C.reset}`, ...m);
const warn = (...m) => console.log(`${C.yellow}[warn]${C.reset}`, ...m);
const err = (...m) => console.error(`${C.red}[err] ${C.reset}`, ...m);

function checkPdflatex() {
  try {
    execSync("pdflatex --version", { stdio: "ignore" });
    return true;
  } catch {
    err("pdflatex not found!");
    err(
      "Install: sudo apt install texlive-latex-base texlive-fonts-recommended",
    );
    return false;
  }
}

let compiling = false;

function compile() {
  if (compiling) return;
  compiling = true;
  log("Compiling LaTeX...");

  mkdirSync(OUT_DIR, { recursive: true });

  const result = spawnSync(
    "pdflatex",
    ["-interaction=nonstopmode", `-output-directory=${OUT_DIR}`, TEX],
    { cwd: ROOT, encoding: "utf8" },
  );

  if (result.status !== 0) {
    warn("pdflatex reported errors — check output/Daksh_Resume.log");
  } else {
    ok("Compiled successfully");
  }

  if (existsSync(PDF_SRC)) {
    copyFileSync(PDF_SRC, PDF_DEST);
    ok(`PDF → docs/Daksh_Resume.pdf`);
  }

  compiling = false;
}

const MIME = {
  ".html": "text/html",
  ".css": "text/css",
  ".js": "text/javascript",
  ".pdf": "application/pdf",
  ".png": "image/png",
  ".jpg": "image/jpeg",
  ".ico": "image/x-icon",
};

function createStaticServer() {
  return createServer((req, res) => {
    let urlPath = req.url.split("?")[0];
    if (urlPath === "/" || urlPath === "") urlPath = "/index.html";

    const filePath = join(DOCS_DIR, urlPath);

    if (!filePath.startsWith(DOCS_DIR)) {
      res.writeHead(403);
      res.end("Forbidden");
      return;
    }

    try {
      const data = readFileSync(filePath);
      const mime = MIME[extname(filePath)] ?? "application/octet-stream";
      res.writeHead(200, {
        "Content-Type": mime,
        "Cache-Control": "no-store",
      });
      res.end(data);
    } catch {
      res.writeHead(404, { "Content-Type": "text/plain" });
      res.end("Not found");
    }
  });
}

function openBrowser(url) {
  const cmd =
    process.platform === "darwin"
      ? "open"
      : process.platform === "win32"
        ? "start"
        : "xdg-open";
  try {
    execSync(`${cmd} ${url}`, { stdio: "ignore" });
  } catch {
    /* ok */
  }
}

if (!checkPdflatex()) process.exit(1);

compile();

const server = createStaticServer();
server.listen(PORT, "127.0.0.1", () => {
  log(`Server →  http://localhost:${PORT}`);
  setTimeout(() => openBrowser(`http://localhost:${PORT}`), 300);
});

const watcher = chokidar.watch([TEX, CLS], {
  ignoreInitial: true,
  awaitWriteFinish: { stabilityThreshold: 300, pollInterval: 100 },
});

log("Watching main.tex and resume.cls for changes  (Ctrl-C to stop)");

watcher.on("change", (path) => {
  log(`Changed: ${path.replace(ROOT + "/", "")}`);
  compile();
});

function shutdown() {
  log("Stopping...");
  watcher.close();
  server.close();
  process.exit(0);
}
process.on("SIGINT", shutdown);
process.on("SIGTERM", shutdown);
