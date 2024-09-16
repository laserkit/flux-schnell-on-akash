FROM docker.io/library/python:3.10@sha256:08a49662edbfff8a296e2db2cb3235e117d1caeb09c32cba65011a2de0306440
RUN apt-get update && apt-get install -y fakeroot && mv /usr/bin/apt-get /usr/bin/.apt-get && echo '#!/usr/bin/env sh\nfakeroot /usr/bin/.apt-get $@' > /usr/bin/apt-get && chmod +x /usr/bin/apt-get && rm -rf /var/lib/apt/lists/* && useradd -m -u 1000 user
RUN apt-get update && apt-get install -y git git-lfs ffmpeg libsm6 libxext6 cmake rsync libgl1-mesa-glx && rm -rf /var/lib/apt/lists/* && git lfs install
WORKDIR /home/user/app
COPY --chown=1000:1000 app.py /home/user/app
COPY --chown=1000:1000 requirements.txt /home/user/app
RUN pip install --no-cache-dir pip==22.3.1 && pip install --no-cache-dir datasets "huggingface-hub>=0.19" "hf-transfer>=0.1.4" "protobuf<4" "click<8.1" "pydantic~=1.0"
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir gradio[oauth]==4.40.0 "uvicorn>=0.14.0" "fastapi<0.113.0"
CMD ["python", "app.py"]
