# Containers for AI

## Порівняння Docker образів

| Метрика | Naive (`Dockerfile.naive`) | Multi-stage (`Dockerfile`) |
| :--- | :--- | :--- |
| **Image size** | 1.22 GB | 239 MB |
| **Build time** | 37.2s | 18.1s |
| **Rebuild after code change** | ~12s (кеш ламається) | ~1-2s (кешуються wheels) |
| **Cold start (до /health=ok)** | ~5s | ~5s |

**Висновок:** Multi-stage підхід зменшив розмір кінцевого образу майже в 5 разів. Це досягається завдяки збірці залежностей (`wheels`) в окремому шарі `builder` та використанню легковагового `python:3.11-slim` на фінальному етапі. Також додано `non-root` користувача для підвищення безпеки та `HEALTHCHECK` для контролю стану контейнера.
