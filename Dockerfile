FROM ubuntu:latest

SHELL ["/bin/bash", "-euf", "-o", "pipefail", "-c"]

# Disable interactive frontend
ENV DEBIAN_FRONTEND=noninteractive

# From the docs: https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#run :
# Always combine RUN apt-get update with apt-get install in the same RUN statement, for example
#   RUN apt-get update && apt-get install -y package-bar
# 
# (...)
# 
# Using apt-get update alone in a RUN statement causes caching issues and subsequent apt-get install instructions fail.
#
# (...)
# 
# Using RUN apt-get update && apt-get install -y ensures your Dockerfile installs 
# the latest package versions with no further coding or manual intervention. This technique is known as “cache busting”.

# update and install dependencies
RUN apt-get update \ 
      && apt-get install -y apt-utils \
      # set up build env
      && apt-get install -y g++ \
      && apt-get install -y build-essential      

# set locales
RUN apt-get update && apt-get install -y locales \ 
      && rm -rf /var/lib/apt/lists/* \
      && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG en_US.utf8

WORKDIR /apps

COPY . ./