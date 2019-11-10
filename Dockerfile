# Based on Dockerfile from
# https://android.googlesource.com/platform/build/+/master/tools/docker/Dockerfile

# Use Debian 10 instead of Ubuntu 14.04 LTS because 14.04 is no longer supported.
FROM debian:buster-slim

# Adapted from
# https://source.android.com/setup/build/initializing#installing-required-packages-ubuntu-1404
# Android 8+ includes a prebuilt version of OpenJDK, so Java is not needed.
# Android 8+ no longer includes/recommends ccache, see
# https://android.googlesource.com/platform/build/+/7556703f0dfab14c91c03dab1a3c25f6386268d4
# Changes:
#  * added argument --no-install-recommends
#  * added additional dependencies
#    - repo: ca-certificates less python
#    - kernel build system: bc libssl-dev
#    - build environment: procps
#    - build makefile: rsync
#    - android-prepare-vendor: python-protobuf wget
#    - prebuilt clang: libncurses5
#    - prebuilt jdk: fontconfig
#    - art-apex-tester: python3
#  * added package locales to prevent error messages from perl
#  * added package eatmydata to optionally disable fsync in builds
#  * added package gosu to drop privileges in Docker entrypoint
#  * renamed git-core to git
RUN apt-get update \
  && apt-get install -y --no-install-recommends git gnupg flex bison gperf \
    build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 \
    lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev libgl1-mesa-dev \
    libxml2-utils xsltproc unzip ca-certificates less python bc libssl-dev \
    procps rsync python-protobuf wget libncurses5 fontconfig python3 locales \
    eatmydata gosu \
  && echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen \
  && locale-gen \
  && rm -rf /var/lib/apt/lists/*

# Debian packages repo, but instead we download the latest version.
ADD https://storage.googleapis.com/git-repo-downloads/repo /usr/local/bin/repo
RUN echo "d06f33115aea44e583c8669375b35aad397176a411de3461897444d247b6c220  /usr/local/bin/repo" \
  | sha256sum --strict -c - \
  && chmod 755 /usr/local/bin/repo

COPY gitconfig /etc/gitconfig

ENV USER=aosp UID=1000 GROUP=aosp GID=1000
ENTRYPOINT groupadd -g "$GID" "$GROUP" \
  && useradd -m -u "$UID" -g "$GID" "$USER" \
  && gosu "${UID}:${GID}" bash "$@"
