FROM python:3.12-slim

WORKDIR /opt/app

# app deps
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# gcloud
RUN apt-get update && \
    apt-get install -y apt-transport-https ca-certificates gnupg curl && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    apt-get update && apt-get -y install google-cloud-cli

# app
COPY . .

## fastapi
EXPOSE 8080
CMD uvicorn project.main:app --port 8080 --host 0.0.0.0
