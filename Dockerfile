FROM ubuntu:20.04

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update && apt-get install -y --no-install-recommends wget apt-transport-https gnupg ca-certificates && \
    wget --no-check-certificate -qO- "https://get.helm.sh/helm-v3.8.1-linux-amd64.tar.gz" | tar --strip-components=1 -xz -C /usr/local/bin linux-amd64/helm && \
    wget  --no-check-certificate  -P /tmp https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg && \
    apt-key add /tmp/apt-key.gpg && \
    sh -c 'echo deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main > /etc/apt/sources.list.d/kubernetes.list' && \
    apt-get update && apt-get install -y --no-install-recommends \
    build-essential kubectl && \
    apt-get remove --purge -y && \
    rm -rf /var/lib/apt/lists/*
RUN apt-get -y update && DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata
RUN apt-get -y update && apt-get -y install sudo && apt-get install python3.8 -y && \
	sudo apt-get update -y && sudo apt-get install -y python3.8-dbg

COPY requirements.txt /requirements.txt

COPY Dockerfile /Dockerfile

RUN apt-get update && apt-get install -y python3-pip git vim --fix-missing && python3.8 -m pip install -U pip setuptools

RUN python3.8 -m pip install --no-cache-dir -r /requirements.txt

RUN wget https://go.dev/dl/go1.18.4.linux-amd64.tar.gz && tar -C /usr/local -xzf go1.18.4.linux-amd64.tar.gz
ENV PATH $PATH:/usr/local/go/bin

WORKDIR /root