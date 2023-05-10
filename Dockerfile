FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu20.04

# Set timezone:
RUN ln -snf /usr/share/zoneinfo/$CONTAINER_TIMEZONE /etc/localtime && echo $CONTAINER_TIMEZONE > /etc/timezone

# Set locales:
RUN apt-get update && apt-get install -y locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en

RUN apt-get -yq install \
    gdb \
    lcov \
    libbz2-dev \
    libffi-dev \
    libgdbm-dev \
    liblzma-dev \
    libncurses5-dev \
    libreadline6-dev \
    libsqlite3-dev \
    libssl-dev \
    lzma \
    lzma-dev \
    tk-dev \
    uuid-dev \
    xvfb \
    zlib1g-dev \
    wget \
    git \
    build-essential \
    r-base \
    r-base-dev \
    uuid-runtime



RUN useradd -m rstudio && chgrp rstudio /usr/local/lib/R/site-library

USER rstudio

WORKDIR /home/rstudio

RUN R -e 'install.packages(c("tensorflow", "reticulate", "keras"));library(reticulate);path_to_python <- install_python();virtualenv_create("r-reticulate", python = path_to_python);install.packages("keras");library(keras);install_keras(envname = "r-reticulate")'

USER root

RUN wget https://download2.rstudio.org/server/bionic/amd64/rstudio-server-2023.03.0-386-amd64.deb && apt-get install -y ./rstudio-server-2023.03.0-386-amd64.deb && rm rstudio-server-2023.03.0-386-amd64.deb

COPY startup.sh /usr/local/bin/startup.sh

RUN uuidgen -x | tr -d '-' > /etc/rstudio/secure-cookie-key && rm -f /etc/init.d/rstudio-server

CMD ["/bin/bash", "/usr/local/bin/startup.sh"]
