<div align="center">

# 🚀 Local Personal AI Workstation for Windows

[![Windows Support](https://img.shields.io/badge/OS-Windows_10%2B-blue?style=for-the-badge&logo=windows)](https://microsoft.com)
[![Ollama](https://img.shields.io/badge/Powered_by-Ollama-black?style=for-the-badge&logo=ollama)](https://ollama.ai)
[![Python](https://img.shields.io/badge/Python-3.11%2B-yellow?style=for-the-badge&logo=python)](https://python.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

*A local-first AI workstation combining private LLM chat, document RAG, OCR routing, and GPU-accelerated document processing on a consumer Windows PC.*

</div>

---


## Highlights
- Ollama for local model serving
- Open WebUI for chat and RAG
- Docling + RapidOCR for ordinary PDFs/scans
- local semantic OCR quality checking
- conditional escalation of difficult documents to a vision-language model
- Python/PowerShell automation for startup, health checks and recovery
- local-first architecture designed to keep private documents off cloud services when possible

## Document pipeline
```text
PDF
 â†“
text-layer inspection
 â”œâ”€ digital â†’ native extraction
 â””â”€ scan/mixed â†’ RapidOCR
                    â†“
              local quality judge
               â”œâ”€ GOOD â†’ accept
               â””â”€ REVIEW/POOR â†’ VLM MAX
                                  â†“
                              cleanup
                                  â†“
                            RAG-ready Markdown
```

## Development hardware
- AMD Ryzen 9 3900X
- 32 GB RAM
- NVIDIA GeForce RTX 2060 SUPER (8 GB)

## What this project demonstrates
- local LLM deployment/integration
- RAG/document AI architecture
- OCR/VLM routing
- GPU environment troubleshooting
- automation/recovery design
- practical evaluation of quality vs latency

## Limitations
- OCR depends on source quality.
- VLM OCR can be slow on 8 GB VRAM.
- cleanup must not silently invent uncertain source content.
- page-level VLM routing is a planned optimization.

## Repository policy
This public repo should contain only sanitized code, diagrams and sample data. Secrets, personal documents and machine-private recovery details belong in a separate private repo.

