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
   cmake \
   clang-format \
   curl \
   gcc-9 \
   git \
   git-core \
   libass-dev \
   libffi-dev \
   libfreetype6-dev \
   libglib2.0-dev \
   libgnutls28-dev \
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
   texinfo \
   unzip \
   wget \
   yasm \
   zlib1g-dev \
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
   && asdf install erlang 27.0 \
   && asdf global erlang 27.0 \
   && rm -rf /tmp/*

# Elixir
RUN asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git \
   && asdf install elixir 1.17.2-otp-27 \
   && asdf global elixir 1.17.2-otp-27 \
   && mix local.hex --force \
   && mix local.rebar --force \
   && rm -rf /tmp/*

# Node.js
RUN asdf plugin-add nodejs \
   && asdf install nodejs 18.17.1 \
   && asdf global nodejs 18.17.1 \
   && rm -rf /tmp/*

# Rust
RUN asdf plugin-add rust \
   && asdf install rust 1.70.0 \
   && asdf global rust 1.70.0 \
   && rm -rf /tmp/*

# Multimedia libraries
RUN apt-get update \
   && apt-get install -y \
   libflac-dev \
   libmad0-dev \
   libopus-dev \
   libsdl2-dev \
   portaudio19-dev \
   libsrtp2-dev \
   libmp3lame-dev \
   libva-dev \
   libvdpau-dev \
   libvorbis-dev \
   libxcb1-dev \
   libxcb-shm0-dev \
   libxcb-xfixes0-dev \
   libx264-dev \
   libfreetype-dev \
   libx265-dev \
   && rm -rf /var/lib/apt/lists/* \
   # fdk-aac
   && cd /tmp/ \
   && wget https://downloads.sourceforge.net/opencore-amr/fdk-aac-2.0.0.tar.gz \
   && tar -xf fdk-aac-2.0.0.tar.gz && cd fdk-aac-2.0.0 \
   && ./configure --prefix=/usr --disable-static \
   && make && make install \
   && cd / \
   && rm -rf /tmp/*

# FFmpeg
RUN asdf plugin add ffmpeg \
   && export ASDF_FFMPEG_OPTIONS_EXTRA="--disable-debug \
   --disable-doc \
   --enable-ffplay \
   --enable-fontconfig \
   --enable-gpl \
   --enable-libass \
   --enable-libfdk_aac \
   --enable-libmp3lame \
   --enable-libopus \
   --enable-libx264 \
   --enable-libx265 \
   --enable-libfreetype \
   --enable-libharfbuzz \
   --enable-nonfree \
   --enable-openssl \
   --enable-postproc \
   --enable-shared \
   --enable-small \
   --enable-version3 \
   --extra-libs=-ldl \
   --extra-libs=-lpthread" \
   && asdf install ffmpeg 6.1.1 \
   && asdf global ffmpeg 6.1.1 \
   && cp -r /root/.asdf/installs/ffmpeg/6.1.1/lib/* /usr/lib

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
