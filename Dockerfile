FROM ubuntu:focal

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8 TIMEZONE=Asia/Shanghai
ENV websocat_version=1.6.0
ENV just_version=0.7.1
ENV yq_version=3.3.2
ENV wasmtime_version=0.19.0
ENV watchexec_version=1.14.0
ENV s6overlay_version=2.0.0.1

ARG websocat_url=https://github.com/vi/websocat/releases/download/v${websocat_version}/websocat_amd64-linux-static
ARG s6overlay_url=https://github.com/just-containers/s6-overlay/releases/download/v${s6overlay_version}/s6-overlay-amd64.tar.gz
ARG just_url=https://github.com/casey/just/releases/download/v${just_version}/just-v${just_version}-x86_64-unknown-linux-musl.tar.gz
ARG yq_url=https://github.com/mikefarah/yq/releases/download/${yq_version}/yq_linux_amd64
ARG wasmtime_url=https://github.com/bytecodealliance/wasmtime/releases/download/v${wasmtime_version}/wasmtime-v${wasmtime_version}-x86_64-linux.tar.xz
ARG watchexec_url=https://github.com/watchexec/watchexec/releases/download/${watchexec_version}/watchexec-${watchexec_version}-x86_64-unknown-linux-musl.tar.xz

ENV DEV_DEPS \
        zsh neovim git mlocate \
        gnupg openssh-server openssh-client \
        pwgen curl rsync wget tcpdump \
        sudo procps tree unzip zstd \
        iproute2 net-tools inetutils-ping

COPY home /root/
RUN set -eux \
  ; apt-get update \
  ; apt-get upgrade -y \
  ; DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    tzdata \
    locales \
    xz-utils \
    $DEV_DEPS \
  \
  ; sed -i 's/^.*\(%sudo.*\)ALL$/\1NOPASSWD:ALL/g' /etc/sudoers \
  ; ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime \
  ; echo "$TIMEZONE" > /etc/timezone \
  ; sed -i /etc/locale.gen \
    -e 's/# \(en_US.UTF-8 UTF-8\)/\1/' \
    -e 's/# \(zh_CN.UTF-8 UTF-8\)/\1/' \
  ; locale-gen \
  \
  ; mkdir -p /var/run/sshd \
  ; sed -i /etc/ssh/sshd_config \
        -e 's!.*\(AuthorizedKeysFile\).*!\1 /etc/authorized_keys/%u!' \
        -e 's!.*\(GatewayPorts\).*!\1 yes!' \
        -e 's!.*\(PasswordAuthentication\).*yes!\1 no!' \
  \
  ; wget -O - https://openresty.org/package/pubkey.gpg | apt-key add - \
  ; echo "deb http://openresty.org/package/ubuntu focal main" \
      | tee /etc/apt/sources.list.d/openresty.list \
  ; apt-get update \
  ; apt-get -y install --no-install-recommends openresty openresty-opm \
  ; opm install ledgetech/lua-resty-http \
  ; mkdir -p /etc/openresty/conf.d \
  \
  ; wget -q -O /usr/local/bin/websocat ${websocat_url} \
    ; chmod a+x /usr/local/bin/websocat \
  ; wget -q -O- ${just_url} \
      | tar zxf - -C /usr/local/bin just \
  ; wget -q -O /usr/local/bin/yq ${yq_url} \
      ; chmod +x /usr/local/bin/yq \
  ; wget -O- ${wasmtime_url} | tar Jxf - --strip-components=1 -C /usr/local/bin \
      wasmtime-v${wasmtime_version}-x86_64-linux/wasmtime \
  ; wget -q -O- ${watchexec_url} \
      | tar Jxf - --strip-components=1 -C /usr/local/bin watchexec-${watchexec_version}-x86_64-unknown-linux-musl/watchexec \
  \
  ; curl --fail --silent -L ${s6overlay_url} > /tmp/s6overlay.tar.gz \
  ; tar xzf /tmp/s6overlay.tar.gz -C / --exclude="./bin" \
  ; tar xzf /tmp/s6overlay.tar.gz -C /usr ./bin \
  ; rm -f /tmp/s6overlay.tar.gz \
  \
  ; apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

COPY services.d /etc/services.d
COPY reload-nginx /usr/local/bin
COPY nginx.conf /etc/openresty
COPY nginx-site.conf /etc/openresty/conf.d/default.conf
WORKDIR /srv

VOLUME [ "/srv" ]
EXPOSE 80

ENTRYPOINT [ "/init" ]

ENV WEB_SERVERNAME=
ENV WEB_ROOT=
ENV WS_FIXED=