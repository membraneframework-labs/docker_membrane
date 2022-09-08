FROM ubuntu:20.04

# We are using bash because ASDF prefers it.
SHELL ["/bin/bash", "-c"]

# Common tools and dependencies, GCC, ASDF
# Note: We setup locales using the snippet from `ubuntu` image readme.
RUN apt-get update \
 && apt-get install -y software-properties-common \
 && add-apt-repository ppa:ubuntu-toolchain-r/test -y \
 && apt-get update \
 && apt-get install -y \
    autoconf \
    automake \
    build-essential \
    clang-format \
    curl \
    gcc-9 \
    git \
    libffi-dev \
    libglib2.0-dev \
    libncurses-dev \
    libreadline-dev \
    libssl-dev \
    libtool \
    libxslt-dev \
    libyaml-dev \
    locales \
    meson \
    ninja-build \
    unixodbc-dev \
    unzip \
    wget \
 && rm -rf /var/lib/apt/lists/* \
 && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
 && git clone https://github.com/asdf-vm/asdf.git /root/.asdf -b v0.8.0

# libnice
# Building from source has been choosen because of potential bug described in
# https://gitlab.freedesktop.org/libnice/libnice/-/issues/120. Even after fixing it the new version
# will not probably be available in apt repositories for some time.
RUN git clone https://github.com/libnice/libnice.git \
 && cd libnice/ \
 && git checkout 833c1aa4cc442f2e25216dc411651a674d36c09a \
 && meson builddir \
 && ninja -C builddir \
 && ninja -C builddir test \
 && ninja -C builddir install \
 && cd /

ENV LANG en_US.utf8

# Add ASDF to PATH
# Note: This is essentialy an intersection of what the asdf init script does and what
# we need during container build phase. The init script does check whether these paths
# are present in PATH variable before adding new ones. We are going to fully initialise
# asdf in the entrypoint script.
ENV PATH /root/.asdf/bin:/root/.asdf/shims:$PATH

# Erlang
RUN apt-get update \
 # This invocation causes `keyboard-configuration` package to be installed,
 # which seems to assume interactivity during Docker build. Setting DEBIAN_FRONTEND
 # helps for this issue, although this is not recommended in general.
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    autoconf \
    build-essential \
    fop \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    libncurses5-dev \
    libpng-dev \
    libssh-dev \
    libwxgtk3.0-gtk3-dev \
    m4 \
    unixodbc-dev \
    xsltproc \
 && rm -rf /var/lib/apt/lists/* \
 && asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git \
 && asdf install erlang 25.0.3 \
 && asdf global erlang 25.0.3 \
 && rm -rf /tmp/*

# Elixir
RUN asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git \
 && asdf install elixir 1.13.0 \
 && asdf global elixir 1.13.0 \
 && mix local.hex --force \
 && mix local.rebar --force \
 && rm -rf /tmp/*
 
 # Node.js
 RUN asdf plugin-add nodejs \
   && asdf install nodejs 16.17.0 \
   && asdf global nodejs 16.17.0 \
   && rm -rf /tmp/*

 # Rust
 RUN asdf plugin-add rust \
   && asdf install rust 1.63.0 \
   && asdf global rust 1.63.0 \
   && rm -rf /tmp/*

# Multimedia libraries
RUN apt-get update \
 && apt-get install -y \
    ffmpeg \
    libavcodec-dev \
    libavdevice-dev \
    libavfilter-dev \
    libavformat-dev \
    libavformat-dev \
    libavresample-dev \
    libavutil-dev \
    libflac-dev \
    libmad0-dev \
    libopus-dev \
    libpostproc-dev \
    libsdl2-dev \
    libswresample-dev \
    libswscale-dev \
    portaudio19-dev \
    libsrtp2-dev \
    libmp3lame-dev \
 && rm -rf /var/lib/apt/lists/* \
 # fdk-aac
 && cd /tmp/ \
 && wget https://downloads.sourceforge.net/opencore-amr/fdk-aac-2.0.0.tar.gz \
 && tar -xf fdk-aac-2.0.0.tar.gz && cd fdk-aac-2.0.0 \
 && ./configure --prefix=/usr --disable-static \
 && make && make install \
 && cd / \
 && rm -rf /tmp/*

# Dockerize
RUN wget https://github.com/jwilder/dockerize/releases/download/v0.6.1/dockerize-linux-amd64-v0.6.1.tar.gz \
 && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-v0.6.1.tar.gz \
 && rm dockerize-linux-amd64-v0.6.1.tar.gz

# Set the entrypoint
COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/bin/bash"]
