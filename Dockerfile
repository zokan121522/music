# Dockerfile for cmus with TXXX:comment patch
# 
# Purpose: Build specification & verification environment.
# The patch allows cmus to read ID3v2 TXXX:comment frames
# (used by ffmpeg/Lavf) as the standard %{comment} variable.
#
# Note: This builds a Linux cmus binary. For macOS, use
# scripts/build-patched-cmus.sh (native build with CoreAudio).
#
# Usage:
#   docker build -t cmus-patched .
#   docker run -it --rm \
#     -v ~/.config/cmus:/root/.config/cmus \
#     -v /path/to/music:/music:ro \
#     -e PULSE_SERVER=host.docker.internal \
#     cmus-patched

FROM ubuntu:22.04 AS builder

ENV DEBIAN_FRONTEND=noninteractive

# Install build dependencies (mirrors Homebrew deps)
RUN apt-get update && apt-get install -y \
    build-essential \
    pkg-config \
    curl \
    xz-utils \
    libmad0-dev \
    libid3tag0-dev \
    libflac-dev \
    libvorbis-dev \
    libopus-dev \
    libncursesw5-dev \
    libpulse-dev \
    libao-dev \
    libavformat-dev \
    libavcodec-dev \
    libavutil-dev \
    libswresample-dev \
    libfaad-dev \
    libmp4v2-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src

# Clone from our fork (TXXX:comment patch pre-applied on feat/txxx-comment)
RUN git clone --depth 1 --branch feat/txxx-comment https://github.com/zokan121522/cmus.git cmus-2.12.0
WORKDIR /src/cmus-2.12.0

# Download Debian patches (ffmpeg 8 compat, same as Homebrew)
RUN curl -sL https://deb.debian.org/debian/pool/main/c/cmus/cmus_2.12.0-2.debian.tar.xz | tar xJ

# Apply Debian patches
RUN for p in \
    patches/0003-ip-ffmpeg-more-precise-seeking.patch \
    patches/0004-ip-ffmpeg-skip-samples-only-when-needed.patch \
    patches/0005-ip-ffmpeg-remove-excessive-version-checks.patch \
    patches/0006-ip-ffmpeg-major-refactor.patch \
    patches/0007-Validate-sample-format-in-ip_open.patch \
    patches/0008-ip-ffmpeg-flush-swresample-buffer-when-seeking.patch \
    patches/0009-ip-ffmpeg-remember-swr_frame-s-capacity.patch \
    patches/0010-ip-ffmpeg-reset-swr_frame-start-when-seeking.patch \
    patches/0011-ip-ffmpeg-better-frame-skipping-logic.patch \
    patches/0012-ip-ffmpeg-don-t-process-empty-frames.patch \
    patches/0013-ip-ffmpeg-improve-readability.patch \
    patches/0014-ip-ffmpeg-fix-building-for-ffmpeg-8.0.patch \
    patches/0015-ip-ffmpeg-change-sample-format-conversions.patch; do \
    patch -p1 -s < "$p"; \
done

# TXXX:comment patch is already in the fork — no need for sed

# Build cmus
RUN ./configure \
    prefix=/usr/local \
    CONFIG_WAVPACK=n \
    CONFIG_MPC=n \
    CONFIG_AO=y \
    CONFIG_PULSE=y \
    && make -j$(nproc) \
    && make install DESTDIR=/install

# ---- Runtime stage ----
FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    libmad0 \
    libid3tag0 \
    libflac0 \
    libvorbis0a \
    libopus0 \
    libncursesw6 \
    libpulse0 \
    libao4 \
    libavformat59 \
    libavcodec59 \
    libavutil56 \
    libswresample4 \
    libfaad2 \
    libmp4v2-2 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /install/usr/local/ /usr/local/

# Create config directory
RUN mkdir -p /root/.config/cmus

# cmus needs a terminal
ENV TERM=xterm-256color

ENTRYPOINT ["cmus"]
