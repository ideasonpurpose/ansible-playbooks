FROM python:3.7-slim

WORKDIR /usr/app

RUN apt update \
  && apt install -y openssh-server software-properties-common \
  && pip install ansible

