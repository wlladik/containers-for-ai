# === Етап 1: Builder ===
FROM python:3.11-slim as builder

WORKDIR /code

COPY app/requirements.txt .
RUN pip wheel --no-cache-dir --no-deps --wheel-dir /code/wheels -r requirements.txt

# === Етап 2: Final ===
FROM python:3.11-slim

WORKDIR /code

# Створюємо non-root користувача
RUN useradd -m -u 1000 appuser && \
    chown -R appuser:appuser /code

# Забираємо зібрані пакети з першого етапу
COPY --from=builder /code/wheels /wheels
COPY --from=builder /code/requirements.txt .
RUN pip install --no-cache /wheels/* && \
    rm -rf /wheels

# Копіюємо код
COPY --chown=appuser:appuser . .

USER appuser

# Healthcheck
HEALTHCHECK --interval=10s --timeout=5s --start-period=5s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/health')" || exit 1

EXPOSE 8000

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]