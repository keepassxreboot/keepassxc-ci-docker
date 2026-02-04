# KeePassXC Node CI Build Dockerfile
# Copyright (C) 2017-2025 KeePassXC team <https://keepassxc.org/>
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

FROM node:lts

RUN set -x \
    && npx --yes playwright install-deps \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/

RUN set -x \
    && git clone https://github.com/ncopa/su-exec.git \
    && (cd su-exec; make) \
    && mv su-exec/su-exec /usr/bin/su-exec \
    && rm -rf su-exec

RUN set -x \
    && groupadd -g 1001 keepassxc \
    && useradd -u 1001 -g keepassxc -d /keepassxc -m -s /bin/bash keepassxc

# User 1000 already exists
#RUN set -x \
#     && groupmod -n keepassxc node \
#     && usermod -l keepassxc -g keepassxc -d /keepassxc -s /bin/bash node
#

# Ensure proper permissions of homedir and volume mounts
RUN set -x \
    && mkdir /keepassxc/src /keepassxc/out \
    && chown -R keepassxc:keepassxc /keepassxc

COPY docker-entrypoint.sh /docker-entrypoint.sh

VOLUME ["/keepassxc/src", "/keepassxc/out"]
WORKDIR /keepassxc
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["bashx"]

