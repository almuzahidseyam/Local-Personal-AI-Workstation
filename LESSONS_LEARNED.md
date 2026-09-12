# Lessons Learned

- Successful conversion does not mean accurate OCR.
- Structural text heuristics can miss fluent-looking OCR corruption.
- A local semantic judge improved routing decisions.
- Fast OCR is seconds; VLM OCR can be tens of minutes on 8 GB VRAM.
- `pypdfium2` solved a parser failure seen with the default Docling path.
- GPU support must exist in the exact Python environment doing the work.
- Large model caches should be managed deliberately.
- Auto-start services, not heavy models.
- Recovery documentation is part of the system, not an afterthought.
