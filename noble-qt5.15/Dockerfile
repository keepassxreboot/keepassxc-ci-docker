# KeePassXC Linux CI Build Dockerfile
# Copyright (C) 2017-2022 KeePassXC team <https://keepassxc.org/>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 or (at your option)
# version 3 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

FROM ubuntu:24.04

ARG LLVM_VERSION=18
ARG DEBIAN_FRONTEND=noninteractive

ENV PATH="/usr/lib/llvm-${LLVM_VERSION}/bin:${PATH}"

RUN set -x \
    && apt-get update -y \
    && apt-get -y install --no-install-recommends \
        apt-transport-https \
        gpg-agent \
        ca-certificates \
        software-properties-common \
    && add-apt-repository ppa:phoerious/keepassxc \
    && apt-get update -y \
    && apt-get upgrade -y \
    && apt-get install --no-install-recommends -y \
        asciidoctor \
        build-essential \
        catch2 \
        clang-${LLVM_VERSION} \
        clang-format-${LLVM_VERSION} \
        cmake \
        curl \
        dbus \
        devscripts \
        dh-autoreconf \
        dh-make \
        fakeroot \
        file \
        fluxbox \
        fuse \
        gcovr \
        git \
        libargon2-dev \
        libbotan-2-dev \
        libclang-rt-${LLVM_VERSION}-dev \
        libgl1-mesa-dev \
        libgcrypt-dev \
        libomp-${LLVM_VERSION}-dev \
        libqrencode-dev \
        libqt5svg5-dev \
        libqt5x11extras5-dev \
        libquazip5-dev \
        libreadline-dev \
        libsodium-dev \
        libxi-dev \
        libxtst-dev \
        libyubikey-dev \
        libykpers-1-dev \
        libusb-1.0-0-dev \
        libpcsclite-dev \
        libminizip-dev \
        libkeyutils-dev \
        libxkbcommon-dev \
        libzxcvbn-dev \
        libpoppler-cpp-dev \
        llvm-${LLVM_VERSION}-dev \
        locales \
        metacity \
        ninja-build \
        qtbase5-dev \
        qt5-image-formats-plugins \
        qtbase5-private-dev \
        qttools5-dev \
        qttools5-dev-tools \
        qttranslations5-l10n \
        qtwayland5 \
        xclip \
        xvfb \
        zlib1g-dev \
        openssh-client \
    && apt-get autoremove --purge \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/
    
RUN set -x \
    && git clone https://github.com/ncopa/su-exec.git \
    && (cd su-exec; make) \
    && mv su-exec/su-exec /usr/bin/su-exec \
    && rm -rf su-exec

RUN set -x && locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN set -x \
    && curl -fL "https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage" > /usr/local/bin/linuxdeploy \
    && curl -fL "https://github.com/linuxdeploy/linuxdeploy-plugin-qt/releases/download/continuous/linuxdeploy-plugin-qt-x86_64.AppImage" > /usr/local/bin/linuxdeploy-plugin-qt \
    && curl -fL "https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage" > /usr/local/bin/appimagetool \
    && curl -fL https://uploader.codecov.io/latest/linux/codecov > /usr/local/bin/codecov \
    && chmod +x /usr/local/bin/linuxdeploy \
    && chmod +x /usr/local/bin/linuxdeploy-plugin-qt \
    && chmod +x /usr/local/bin/appimagetool \
    && chmod +x /usr/local/bin/codecov
#
# Config for linuxdeploy-plugin-qt
ENV EXTRA_QT_PLUGINS="waylandcompositor;svg"
ENV EXTRA_PLATFORM_PLUGINS="libqwayland-egl.so;libqwayland-generic.so"

RUN set -x \
    && groupadd -g 1001 keepassxc \
    && useradd -u 1001 -g keepassxc -d /keepassxc -m -s /bin/bash keepassxc

# User 1000 already exists in newer base images
#RUN set -x \
#     && groupmod -n keepassxc ubuntu \
#     && usermod -l keepassxc -g keepassxc -d /keepassxc -s /bin/bash ubuntu

# Ensure proper permissions of homedir and volume mounts
RUN set -x \
    && mkdir /keepassxc/src /keepassxc/out \
    && chown -R keepassxc:keepassxc /keepassxc

COPY docker-entrypoint.sh /docker-entrypoint.sh

VOLUME ["/keepassxc/src", "/keepassxc/out"]
WORKDIR /keepassxc
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["bashx"]

