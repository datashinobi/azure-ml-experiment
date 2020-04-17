FROM mcr.microsoft.com/azureml/base-gpu:openmpi3.1.2-cuda10.0-cudnn7-ubuntu18.04 as base
ENV DEBIAN_FRONTEND noninteractive
WORKDIR /opt
RUN apt update && \
    apt install curl -y && \
    apt-get -y install \
        zlib1g-dev \
        libssl-dev \
        libbz2-dev \
        liblzma-dev \
        && \   
    apt clean all && \
    rm -rf /var/lib/apt 
RUN curl -LO https://github.com/bazelbuild/bazelisk/releases/download/v1.1.0/bazelisk-linux-amd64 \
  && chmod +x bazelisk-linux-amd64 \
  && mv bazelisk-linux-amd64 /usr/local/bin/bazel

COPY . /opt
RUN bazel build //...
