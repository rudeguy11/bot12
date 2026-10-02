#!/usr/bin/env bash
set -euo pipefail

: "${MC_SERVER_HOST:?Set MC_SERVER_HOST}"
: "${MC_SERVER_PORT:?Set MC_SERVER_PORT}"
: "${MC_USERNAME:?Set MC_USERNAME}"

mkdir -p /app/minecraft/logs

# The vanilla client still needs a session for online-mode servers. This package is intended
# for servers that permit offline/cracked client connections. For online-mode, use a real
# authenticated launcher/session rather than putting account credentials in GitHub variables.
XVFB_WHD=${XVFB_WHD:-1280x720x24}
export DISPLAY=:99
Xvfb :99 -screen 0 "$XVFB_WHD" -nolisten tcp >/app/xvfb.log 2>&1 &

SERVER_ARGS=(--server "$MC_SERVER_HOST" --port "$MC_SERVER_PORT" --username "$MC_USERNAME")

if [[ -n "${BOT_UUID:-}" ]]; then SERVER_ARGS+=(--uuid "$BOT_UUID"); fi

exec java -Xmx${MC_MEMORY:-1536M} -Xms${MC_MIN_MEMORY:-512M} \
  -Djava.awt.headless=true \
  -Dfabric.log.level=${FABRIC_LOG_LEVEL:-INFO} \
  -jar /app/minecraft/fabric-loader-${FABRIC_LOADER}-${MC_VERSION}.jar \
  "${SERVER_ARGS[@]}"
