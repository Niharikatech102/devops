# Stage 1: Builder
FROM python:3.9-slim as builder

WORKDIR /app

COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

# Stage 2: Runner
FROM python:3.9-slim

WORKDIR /app

# Create a non-root user
RUN adduser --disabled-password --gecos "" appuser

# Copy installed dependencies from builder
COPY --from=builder /root/.local /home/appuser/.local
COPY . .

# Update PATH
ENV PATH=/home/appuser/.local/bin:$PATH

# Switch to non-root user
USER appuser

# Expose port
EXPOSE 8000

# Run the application
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
