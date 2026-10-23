# Xray (VLESS + WS) for container platforms where TLS is terminated at the
# platform edge (e.g. the *.up.railway.app domain Railway gives you).
# The public endpoint is wss://<your-domain>:443/<WS_PATH> — TLS outside,
# plain WS inside the container.
FROM alpine:3.20

RUN apk add --no-cache ca-certificates curl unzip tzdata \
 && curl -fsSL -o /tmp/xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip \
 && mkdir -p /usr/local/xray \
 && unzip -o /tmp/xray.zip -d /usr/local/xray \
 && chmod +x /usr/local/xray/xray \
 && rm /tmp/xray.zip

COPY config.template.json /usr/local/xray/config.template.json
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
