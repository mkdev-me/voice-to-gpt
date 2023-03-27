# Use an official Python runtime as a parent image
FROM python:3.9-slim

USER root

# Set the working directory to /app
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y ffmpeg && \
    apt-get install -y wget git gcc libasound2-dev portaudio19-dev 

# Copy the current directory contents into the container at /app
COPY . .

# Install any needed packages specified in requirements.txt
RUN pip install --trusted-host pypi.python.org -r requirements.txt

RUN mkdir -p ~/.cache/whisper && \ 
    wget https://openaipublic.azureedge.net/main/whisper/models/25a8566e1d0c1e2231d1c762132cd20e0f96a85d16145c3a00adf5d1ac670ead/base.en.pt -O ~/.cache/whisper/base.en.pt && \
    wget https://openaipublic.azureedge.net/main/whisper/models/ed3a0b6b1c0edf879ad9b11b1af5a0e6ab5db9205f891f668f8b0e6c6326e34e/base.pt -O ~/.cache/whisper/base.pt

# Install Whisper
RUN pip install -U openai-whisper \
    && pip install git+https://github.com/openai/whisper.git \
    && pip install --upgrade --no-deps --force-reinstall git+https://github.com/openai/whisper.git

RUN pwd
RUN pip install Flask

# Make port 5000 available to the world outside this container
EXPOSE 5000

# Define environment variable
ENV FLASK_APP server.py
ENV FLASK_RUN_HOST 0.0.0.0

# Run app.py when the container launches
CMD ["flask", "run"]

