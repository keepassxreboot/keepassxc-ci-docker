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

ARG LLVM_VERSION=20
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
        fluxbox \
        fuse3 \
        gcovr \
        git \
        libbotan-2-dev \
        libclang-rt-${LLVM_VERSION}-dev \
        libgl1-mesa-dev \
        libgcrypt-dev \
        libomp-${LLVM_VERSION}-dev \
        libqrencode-dev \
        libreadline-dev \
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
        llvm-${LLVM_VERSION}-dev \
        locales \
        ninja-build \
        openssh-client \
        qt6-base-dev \
        qt6-base-private-dev \
        qt6-tools-dev \
        qt6-tools-dev-tools \
        qt6-base-dev-tools \
        qt6-image-formats-plugins \
        qt6-svg-dev \
        qt6-translations-l10n \
        qt6-websockets-dev \
        qt6-wayland \
        shared-mime-info \
        xclip \
        xvfb \
        zlib1g-dev \
    && apt-get autoremove --purge \
    && rm -rf /var/lib/apt/lists/*

# Replace Noble's libbrotli-1.1.0 with 1.1.1 to patch CVE-2026-111497.
RUN set -x \
    && curl -fL https://github.com/google/brotli/archive/refs/tags/v1.1.1.tar.gz -o /tmp/brotli.tar.gz \
    && echo "1a84dfaa740994d19254bf78aa7d74a4a8040d1638f3d5f2cdecb188fd520da8  /tmp/brotli.tar.gz" | sha256sum -c - \
    && tar -xzf /tmp/brotli.tar.gz -C /tmp \
    && brotli_libdir="/usr/lib/$(dpkg-architecture -qDEB_HOST_MULTIARCH)" \
    && cmake -S /tmp/brotli-1.1.1 -B /tmp/brotli-build \
        -DCMAKE_BUILD_TYPE=Release \
        -DBUILD_SHARED_LIBS=ON \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DCMAKE_INSTALL_LIBDIR="${brotli_libdir}" \
    && cmake --build /tmp/brotli-build --parallel "$(nproc)" \
    && ctest --test-dir /tmp/brotli-build --output-on-failure \
    && cmake --install /tmp/brotli-build \
    && rm -f "${brotli_libdir}/libbrotlicommon.so.1.1.0" \
        "${brotli_libdir}/libbrotlidec.so.1.1.0" \
        "${brotli_libdir}/libbrotlienc.so.1.1.0" \
    && ldconfig \
    && rm -rf /tmp/brotli.tar.gz /tmp/brotli-1.1.1 /tmp/brotli-build

RUN set -x \
    && git clone https://github.com/ncopa/su-exec.git \
    && (cd su-exec; make) \
    && mv su-exec/su-exec /usr/bin/su-exec \
    && rm -rf su-exec

RUN set -x && locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

ARG TARGETARCH

RUN set -x \
    && case "${TARGETARCH}" in \
        amd64) appimage_arch=x86_64; codecov_platform=linux ;; \
        arm64) appimage_arch=aarch64; codecov_platform=linux-arm64 ;; \
        *) echo "Unsupported target architecture: ${TARGETARCH}" >&2; exit 1 ;; \
    esac \
    && curl -fL "https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-${appimage_arch}.AppImage" > /usr/local/bin/linuxdeploy \
    && curl -fL "https://github.com/linuxdeploy/linuxdeploy-plugin-qt/releases/download/continuous/linuxdeploy-plugin-qt-${appimage_arch}.AppImage" > /usr/local/bin/linuxdeploy-plugin-qt \
    && curl -fL "https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-${appimage_arch}.AppImage" > /usr/local/bin/appimagetool \
    && curl -fL "https://cli.codecov.io/latest/${codecov_platform}/codecov" > /usr/local/bin/codecov \
    && chmod +x /usr/local/bin/linuxdeploy \
    && chmod +x /usr/local/bin/linuxdeploy-plugin-qt \
    && chmod +x /usr/local/bin/appimagetool \
    && chmod +x /usr/local/bin/codecov
#
# Config for linuxdeploy-plugin-qt
ENV EXTRA_QT_PLUGINS="waylandcompositor;svg"
ENV EXTRA_PLATFORM_PLUGINS="libqwayland-egl.so;libqwayland-generic.so"

#RUN set -x \
#    && groupadd -g 1000 keepassxc \
#    && useradd -u 1000 -g keepassxc -d /keepassxc -m -s /bin/bash keepassxc

# User 1000 already exists in newer base images
RUN set -x \
     && groupmod -n keepassxc ubuntu \
     && usermod -l keepassxc -g keepassxc -d /keepassxc -m -s /bin/bash ubuntu

# Ensure proper permissions of homedir and volume mounts
RUN set -x \
    && mkdir /keepassxc/src /keepassxc/out \
    && chown -R keepassxc:keepassxc /keepassxc

COPY docker-entrypoint.sh /docker-entrypoint.sh

VOLUME ["/keepassxc/src", "/keepassxc/out"]
WORKDIR /keepassxc
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["bashx"]
