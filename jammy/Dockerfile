# Install ASDF with golang
FROM golang:1.24-alpine AS asdf_builder

RUN go install github.com/asdf-vm/asdf/cmd/asdf@v0.18.0

FROM ubuntu:22.04

# We are using bash because ASDF prefers it.
SHELL ["/bin/bash", "-c"]

# ASDF
COPY --from=asdf_builder /go/bin/asdf /usr/local/bin/asdf

# Add ASDF to PATH
ENV PATH=/root/.asdf/bin:/root/.asdf/shims:$PATH

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
   && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

# ASDF
#ARG ASDF_VERSION=v0.18.0
#ARG ASDF_TARBALL=asdf-${ASDF_VERSION}-linux-386.tar.gz

#RUN \ 
    #git clone https://github.com/asdf-vm/asdf.git -b v0.18.0 \
    #&& make -C asdf \
    #&& mv bin/asdf /usr/local/bin/ \
    #&& rm -rf asdf

#RUN \
    #wget "https://github.com/asdf-vm/asdf/releases/download/${ASDF_VERSION}/${ASDF_TARBALL}" \
    #&& wget "https://github.com/asdf-vm/asdf/releases/download/${ASDF_VERSION}/${ASDF_TARBALL}.md5" \
    #&& DOWNLOADED_MD5="$(cat ${ASDF_TARBALL}.md5)" \
    #&& CALCULATED_MD5="$(md5sum '${ASDF_TARBALL}' | awk '{print $1}')" \
    #&& [ "$DOWNLOADED_MD5" != "$CALCULATED_MD5" ] \
    #&& tar -xvzf ${ASDF_TARBALL} \
    #&& mv asdf /usr/local/bin \
    #&& rm "${ASDF_TARBALL}" \
    #&& rm "${ASDF_TARBALL}.md5"

ENV LANG=en_US.utf8


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
   && rm -rf /var/lib/apt/lists/*

RUN asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git \
   && asdf install erlang 28.1 \
   && asdf set -u erlang 28.1

# Elixir
RUN asdf plugin add elixir https://github.com/asdf-vm/asdf-elixir.git \
   && asdf install elixir 1.19.3-otp-28 \
   && asdf set -u elixir 1.19.3-otp-28 \
   && mix local.hex --force \
   && mix local.rebar --force

# Node.js
RUN asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git \
   && asdf install nodejs 24.11.1 \
   && asdf set -u nodejs 24.11.1

# Rust
RUN asdf plugin add rust https://github.com/asdf-community/asdf-rust.git \
   && asdf install rust 1.91.1 \
   && asdf set -u rust 1.91.1

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
   libsrt-openssl-dev \
   srt-tools \
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
   && asdf install ffmpeg 7.1.3 \
   && asdf set -u ffmpeg 7.1.3 \
   && cp -r /root/.asdf/installs/ffmpeg/7.1.3/lib/* /usr/lib

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

ENV DISPLAY=:0
ENV XDG_RUNTIME_DIR=/tmp

# Set the entrypoint
COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/bin/bash"]
