FROM python:3.10-slim

# System deps for pdfplumber/PyPDF2 (some PDF parsing needs these)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Python deps first (better Docker layer caching)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Pre-download NLTK data at BUILD time, not first request
RUN python -m nltk.downloader punkt punkt_tab stopwords wordnet -d /usr/local/nltk_data
ENV NLTK_DATA=/usr/local/nltk_data
# Copy the rest of your app
COPY . .

# HF Spaces only exposes 7860
EXPOSE 7860

# Create uploads folder in case it's not committed
RUN mkdir -p uploads

CMD ["python", "app.py"]
