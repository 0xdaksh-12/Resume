# Daksha Jha — Resume

> Software Engineer · Distributed Systems & Full-Stack

[![PDF](https://img.shields.io/badge/Resume-PDF-blue?logo=adobeacrobatreader&logoColor=white)](https://raw.githubusercontent.com/0xflame-7/Resume/main/output/Daksh_Resume.pdf)
[![GitHub Pages](https://img.shields.io/badge/Live-GitHub%20Pages-success?logo=github)](https://0xflame-7.github.io/Resume/)
[![Build Status](https://github.com/0xflame-7/Resume/actions/workflows/build-resume.yml/badge.svg)](https://github.com/0xflame-7/Resume/actions)

---

## 📄 Download

| Format | Link |
|--------|------|
| PDF (latest) | [Daksh_Resume.pdf](output/Daksh_Resume.pdf) |
| Raw download | [Direct link](https://raw.githubusercontent.com/0xflame-7/Resume/main/output/Daksh_Resume.pdf) |
| Live site | [0xflame-7.github.io/Resume](https://0xflame-7.github.io/Resume/) |

---

## 🧑‍💻 About

Backend-focused software engineer with a strong interest in distributed systems, developer tooling, and high-performance infrastructure. Currently pursuing B.Tech in CS at ITM University Gwalior (2022–2026).

**Primary:** Java, TypeScript  
**Backend:** NestJS, Go (Gin), FastAPI  
**Frontend:** React.js, Next.js, Zustand, TanStack  
**Infra:** Docker, Kubernetes, GitHub Actions, AWS  
**Data:** PostgreSQL, MongoDB, Redis, RabbitMQ  
**Concepts:** Distributed Systems, gRPC, OS, Computer Networks  

---

## 🚀 Featured Projects

| Project | Stack | Links |
|---------|-------|-------|
| **FluxTerm** — VS Code shell notebook | TS, React, VS Code API | [GitHub](https://github.com/0xflame-7/Flow) · [Marketplace](https://marketplace.visualstudio.com/items?itemName=0xflame-7.fluxterm) |
| **fluxly** — Distributed URL shortener | NestJS, Go, gRPC, Kubernetes | [GitHub](https://github.com/0xflame-7/fluxly) · [Live](https://fluxly.render.com/) |
| **Forge** — Self-hosted CI/CD engine | Go, Docker, Kubernetes | [GitHub](https://github.com/0xflame-7/Forge) |

---

## 🏆 Achievements

- **Codeforces** — Expert (max rating: 1805)
- **LeetCode** — Knight; 200+ problems solved
- **HackerRank** — 5★ in C++, Problem Solving, SQL, Linux Shell

---

## 🔧 How It Works

Push any change to `main.tex` or `resume.cls` and GitHub Actions automatically compiles the PDF via [`xu-cheng/latex-action`](https://github.com/xu-cheng/latex-action) and commits the result back to the repo.

**For local preview**, open `main.tex` in VS Code with the [LaTeX Workshop](https://marketplace.visualstudio.com/items?itemName=James-Yu.latex-workshop) extension — it compiles and previews the PDF inline on save (requires a local TeX installation such as `texlive-full` or `MiKTeX`).

---

## 📁 Repository Structure

```
Resume/
├── main.tex                  # LaTeX resume source
├── resume.cls                # Custom resume class
├── output/
│   └── Daksh_Resume.pdf      # Compiled PDF (auto-updated by CI)
├── docs/
│   ├── index.html            # GitHub Pages landing site
│   ├── styles.css
│   └── Daksh_Resume.pdf      # PDF served via Pages
├── .github/
│   └── workflows/
│       └── build-resume.yml  # CI: compile + commit PDF
├── CHANGELOG.md
└── README.md
```

---

*Resume auto-compiled via [GitHub Actions](https://github.com/0xflame-7/Resume/actions) · Hosted on [GitHub Pages](https://0xflame-7.github.io/Resume/)*
