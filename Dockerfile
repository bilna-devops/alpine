# Pull base image
FROM python:3.6-alpine
LABEL maintainer="Muhammad Fahrizal Rahman riesal[at]gmail[dot]com"

# System env variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1
ARG TRNS_CRYPT
ENV TRNS_CRYPT=$TRNS_CRYPT

# System dependencies    
RUN apk update && \
    apk add --no-cache libc6-compat curl net-tools libxml2-dev libxslt-dev wget drill vim bash openssh-client && \
    apk-add --no-cache mariadb-dev build-base jpeg-dev postgresql-libs zlib-dev curl-dev python3-dev libressl-dev && \
    apk-add --no-cache openssl util-linux git && \
    apk add --no-cache --virtual .build-deps gcc linux-headers musl-dev postgresql-dev postgresql-libs

WORKDIR /mnt
RUN git clone https://github.com/elasticdog/transcrypt.git
RUN ln -s /mnt/transcrypt/transcrypt /usr/local/bin/transcrypt

# Change workdir
WORKDIR /app

# Add git providers to known_hosts
RUN mkdir /root/.ssh
RUN touch /root/.ssh/known_hosts
RUN ssh-keyscan bitbucket.org >> /root/.ssh/known_hosts
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts
RUN ssh-keyscan gitlab.com >> /root/.ssh/known_hosts

# Project dependencies
COPY . /app
WORKDIR /app

# RUN git checkout Dockerfile
RUN git status
RUN echo "$TRNS_CRYPT"
RUN transcrypt -p "$TRNS_CRYPT" -y
#RUN bash -c transcrypt -p "$TRNS_CRYPT" -y

COPY requirements.txt /app
RUN pip install -r requirements.txt
RUN pip install -U pip && apk --purge del .build-deps
