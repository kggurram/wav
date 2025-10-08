# WAVs

<!-- ![Example Output](example-image.png) -->

WAVs is a Flask-based serverless audio analysis service deployed on **Google Cloud Run**. It receives a `.wav` file stored in Firebase Storage and returns:

- **Transcription** via [OpenAI Whisper](https://github.com/openai/whisper)
- **Tempo & Key Detection** via [Librosa](https://librosa.org/)
- **Mood & Lyric Suggestion** via [OpenAI GPT-4](https://openai.com/)
- **Firebase Firestore Integration** for storing results per user

Ideal for use in mobile or web apps aimed at music creators, vocalists, or producers.

---

## Features

- Upload `.wav` files to Firebase Storage
- Automatic audio analysis and transcription
- Mood analysis & AI-generated lyric suggestion
- Saves results to Firestore under each user’s recordings
- Fast deployment on **Google Cloud Run** using Docker

---

## Tech Stack

| Layer     | Tech                          |
|-----------|-------------------------------|
| Backend   | Python, Flask                 |
| ML Models | OpenAI Whisper, GPT-4         |
| DSP       | Librosa, FFmpeg               |
| Storage   | Firebase Cloud Storage        |
| Database  | Firebase Firestore            |
| Hosting   | Google Cloud Run + Docker     |

---

## Endpoint

**POST `/analyze`**

```json
{
  "audio_url": "https://firebasestorage.googleapis.com/...",
  "userId": "abc123",
  "fileName": "WAV-XYZ.wav",
  "bucket": "your-bucket-name"
}
```

**Returns**

```json
{
  "status": "success",
  "tempo": 92,
  "key": "C#",
  "mood_ai": "Dreamy — 'Floating between thoughts, I forgot the ground'"
}
```

---

## Dockerfile

This project is fully containerized:

```Dockerfile
FROM python:3.10-slim
RUN apt-get update && apt-get install -y git ffmpeg libsndfile1 && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY . .
RUN pip install --upgrade pip
RUN pip install numpy==1.26.4
RUN pip install "scipy>=1.10.0"
RUN pip install git+https://github.com/openai/whisper.git
RUN pip install -r requirements.txt
EXPOSE 8080
CMD ["python", "app.py"]
```

---

## Project Structure

```
.
├── app.py              # Main Flask app
├── Dockerfile          # Container setup
├── requirements.txt    # Python dependencies
└── README.md           # You're here
```

---

## Example AI Output

> Mood: **Bittersweet**  
> Suggested lyric: *"I left my name where the silence grows"*  

---

## Todo

- [ ] Detect key using pitch instead of chroma
- [ ] Add scale (major/minor) estimation
- [ ] Transcription confidence scoring
- [ ] Optional image generation based on mood

---

<!-- ## Screenshot -->

<!-- Replace with real image -->
<!-- ![App Preview](example-image.png) -->
