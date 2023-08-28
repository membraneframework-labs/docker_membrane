FROM ubuntu:22.04

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
 && asdf install erlang 25.2.3 \
 && asdf global erlang 25.2.3 \
 && rm -rf /tmp/*

# Elixir
RUN asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git \
 && asdf install elixir 1.14.3-otp-25 \
 && asdf global elixir 1.14.3-otp-25 \
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
 && asdf install rust 1.70.0 \
 && asdf global rust 1.70.0 \
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

# OpenGL dependencies - based on https://github.com/thewtex/docker-opengl
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    libgl1-mesa-dri \
    openbox \
    supervisor \
    x11-xserver-utils \
    xinit \
    xserver-xorg-video-dummy \
    python3-pip \
 && pip install git+https://github.com/coderanger/supervisor-stdout \
 && apt-get -y clean

# Protoc and elixir-protobuf plugin
# Installing protoc from a binary release to avoid ancient packages of ubuntu
RUN wget https://github.com/protocolbuffers/protobuf/releases/download/v24.2/protoc-24.2-linux-x86_64.zip -O protoc.zip \
  && mkdir -p ~/.local/protoc/ \
  && unzip protoc.zip -d $HOME/.local/protoc \
  && rm protoc.zip \
  && echo "export PATH='$PATH:$HOME/.local/protoc/bin'" >> $HOME/.bashrc \
  && mix escript.install hex protobuf --force \
  && asdf reshim

COPY etc /etc
COPY /etc/skel/.xinitrc /root/
COPY usr /usr

ENV DISPLAY :0
ENV XDG_RUNTIME_DIR /tmp

# Set the entrypoint
COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/bin/bash"]
