# podman build base
FROM docker.io/library/golang:1.12-alpine3.9 AS podmanbuildbase
RUN apk add --update --no-cache git make gcc pkgconf musl-dev \
	btrfs-progs btrfs-progs-dev libassuan-dev lvm2-dev device-mapper \
	glib-static libc-dev gpgme-dev protobuf-dev protobuf-c-dev \
	libseccomp-dev libselinux-dev ostree-dev openssl iptables bash \
	go-md2man

# conmon
# TODO: add systemd support
FROM podmanbuildbase AS conmon
ARG CONMON_VERSION=v2.0.0
RUN git clone --branch ${CONMON_VERSION} https://github.com/containers/conmon.git /conmon
WORKDIR /conmon
RUN set -eux; \
	rm /usr/lib/libglib-2.0.so* /usr/lib/libintl.so*; \
	make CFLAGS='-std=c99 -Os -Wall -Wextra -Werror -static' LDFLAGS='-static'; \
	install -D -m 755 bin/conmon /usr/libexec/podman/conmon
