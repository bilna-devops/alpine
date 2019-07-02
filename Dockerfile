# Pull base image
FROM python:3.6-alpine
LABEL maintainer="Muhammad Fahrizal Rahman riesal[at]gmail[dot]com"

# System env variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# System dependencies    
RUN apk update && \
    apk add --no-cache libc6-compat curl net-tools libxml2-dev libxslt-dev wget drill vim bash openssh-client && \
    apk add --no-cache mariadb-dev build-base jpeg-dev postgresql-libs zlib-dev curl-dev python3-dev libressl-dev && \
    apk add --no-cache openssl util-linux git && \
    apk add --no-cache --virtual .build-deps gcc linux-headers musl-dev postgresql-dev postgresql-libs

# Transcrypt Newest Version has bug ==> Make it fixed version
WORKDIR /mnt
RUN git clone https://github.com/elasticdog/transcrypt.git
WORKDIR /mnt/transcrypt
RUN git checkout dd62d87e0a9bb96e0b7e1ecb576e63de8e85591d
RUN ln -s /mnt/transcrypt/transcrypt /usr/local/bin/transcrypt

# Add git providers to known_hosts
RUN mkdir /root/.ssh
RUN touch /root/.ssh/known_hosts
RUN ssh-keyscan bitbucket.org >> /root/.ssh/known_hosts
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts
RUN ssh-keyscan gitlab.com >> /root/.ssh/known_hosts

# upgrade python package
RUN pip install -U pip
