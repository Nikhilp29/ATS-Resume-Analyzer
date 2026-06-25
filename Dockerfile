FROM python:3.10-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Pre-download NLTK data at build time (covers both punkt and newer punkt_tab)
RUN python -m nltk.downloader punkt punkt_tab stopwords wordnet -d /usr/local/nltk_data
ENV NLTK_DATA=/usr/local/nltk_data

COPY . .

RUN mkdir -p uploads

EXPOSE 7860

CMD ["python", "app.py"]
