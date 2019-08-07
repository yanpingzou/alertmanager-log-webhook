ARG ARCH="amd64"
ARG OS="linux"
FROM quay.io/prometheus/busybox-${OS}-${ARCH}:latest
LABEL maintainer="Authors <305518273@qq.com>"

ARG ARCH="amd64"
ARG OS="linux"
COPY build/${OS}/alertmanager-log-webhook        /bin/alertmanager-log-webhook
RUN mkdir -p /alertmanager-log-webhook /volumes_logs && \
    ln -s /volumes_logs /alertmanager-log-webhook/logs && \
    chown -R nobody:nogroup /alertmanager-log-webhook /volumes_logs
    
USER        nobody
EXPOSE      8061
VOLUME      ["/alertmanager-log-webhook"]
WORKDIR     /alertmanager-log-webhook
ENTRYPOINT  ["/bin/alertmanager-log-webhook"]
