# Architecture

```text
Open WebUI (:8080)
        │
        ├── chat / RAG
        ▼
Ollama (:11434)
 ├── local LLMs
 ├── embedding model
 └── OCR quality judge

PDF
 │
 ▼
OCR Router v1.3
 ├── native digital ──► Docling + pypdfium2 + no OCR
 └── scan/mixed ─────► RapidOCR
                           │
                           ▼
                    local qwen3:8b judge
                      ├── GOOD → accept
                      └── REVIEW/POOR → Qwen VLM MAX
                                             │
                                             ▼
                                      safe Markdown cleanup
                                             │
                                             ▼
                                  CleanMarkdown → Open WebUI RAG
```

Design principles: local-first, fast-first, non-destructive, quality-aware, recoverable.
