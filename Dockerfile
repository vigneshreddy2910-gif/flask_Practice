# -----------------------------
# Base Image
# -----------------------------
FROM python:3.12-slim

# -----------------------------
# Working Directory
# -----------------------------
WORKDIR /app

# -----------------------------
# Install Dependencies
# -----------------------------
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# -----------------------------
# Copy Application
# -----------------------------
COPY . .

# -----------------------------
# Flask Configuration
# -----------------------------
ENV FLASK_APP=app.py

EXPOSE 5000

# -----------------------------
# Start Application
# -----------------------------
CMD ["python", "app.py"]