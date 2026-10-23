#!/bin/sh
# Renders the Xray config from environment variables, then runs Xray.
#   PORT     listen port inside the container (Railway injects this)
#   UUID     VLESS user id. If unset, one is generated and printed to the
#            log — set it explicitly so your subscription survives restarts.
#   WS_PATH  websocket path secret (default: a fixed random-looking string;
#            set your own)
set -eu

PORT="${PORT:-8080}"
WS_PATH="${WS_PATH:-8f3ka92jd71hf}"

if [ -z "${UUID:-}" ]; then
  UUID="$(cat /proc/sys/kernel/random/uuid)"
  echo "[xray-kit] WARNING: UUID not set, generated one for this run: $UUID"
  echo "[xray-kit] Set the UUID env var to this value to keep it stable."
fi
export PORT UUID WS_PATH

sed -e "s/__PORT__/${PORT}/g" \
    -e "s/__UUID__/${UUID}/g" \
    -e "s|__WS_PATH__|${WS_PATH}|g" \
    /usr/local/xray/config.template.json > /usr/local/xray/config.json

echo "[xray-kit] starting xray: port=${PORT} path=/${WS_PATH}"
exec /usr/local/xray/xray run -config /usr/local/xray/config.json
