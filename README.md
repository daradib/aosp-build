# aosp-build

Minimal Docker image for building Android 8+ from Android Open Source Project (AOSP)
source, as well as derivatives including [GrapheneOS](https://grapheneos.org/)
and [android-prepare-vendor](https://github.com/anestisb/android-prepare-vendor).

## Usage

Start an interactive shell to work on an AOSP source tree at `~/src`,
which is accessible from `/src` in the Docker container:

    $ docker run -it -v ~/src:/src --rm aosp-build
    aosp@feee598fb872:/$ cd /src
    aosp@feee598fb872:/src$ repo init -u [...]

If your files are not owned by UID 1000 and GID 1000, correct them by passing
environment variables to `docker run` with the `-e` option:

    $ docker run -it -v ~/src:/src -e "USER=$(whoami)" -e "UID=$(id -u)" -e "GID=$(id -g)" --rm aosp-build

As with any Docker container, you can track CPU, memory, and I/O:

    $ docker stats

## Similar projects

 * [Dockerfile](https://android.googlesource.com/platform/build/+/master/tools/docker)
 included with Android build system - useful for building Android versions 5 to 7
 * [docker-aosp](https://github.com/kylemanna/docker-aosp)
