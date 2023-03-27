import torch
import pyaudio
import wave
import time
import whisper
import openai
import audioop
import os

openai.api_key = os.environ.get("OPENAI_API_KEY")

def transcribe_audio(file):
    device = "cuda" if torch.cuda.is_available() else "cpu"
    model = whisper.load_model("base").to(device)

    audio = whisper.load_audio(file)
    audio = whisper.pad_or_trim(audio)

    mel = whisper.log_mel_spectrogram(audio).to(model.device)
    
    _, probs = model.detect_language(mel)
    print(f"Detected language: {max(probs, key=probs.get)}")

    options = whisper.DecodingOptions(fp16=False)
    result = whisper.decode(model, mel, options)

    print(result.text)
    return result.text

def ask_gpt(prompt, max_tokens=300):
    prompt = f"Conversación con un asistente AI:\n{prompt}"
    response = openai.Completion.create(
        engine="text-davinci-003",
        prompt=prompt,
        max_tokens=max_tokens,
        n=1,
        stop=None,
        temperature=0.2,
    )

    print (response.choices[0].text.strip())
    return response.choices[0].text.strip()

