#!/bin/bash
set -euo pipefail

: "${MC_SERVER_HOST:?Set MC_SERVER_HOST}"
: "${MC_SERVER_PORT:?Set MC_SERVER_PORT}"

MC_DIR="${MC_DIR:-/opt/minecraft}"
MC_VERSION="${FABRIC_MC_VERSION:-26.1.2}"
LOADER_VERSION="${FABRIC_LOADER_VERSION:-0.19.2}"
API_VERSION="${FABRIC_API_VERSION:-0.154.0+26.1.2}"

mkdir -p "$MC_DIR/mods"

echo "=== RudeFabricBot: real Fabric client ==="
echo "Minecraft: $MC_VERSION"
echo "Fabric Loader: $LOADER_VERSION"
echo "Server: ${MC_SERVER_HOST}:${MC_SERVER_PORT}"

# Install Fabric client + matching vanilla client if not already installed.
if [ ! -f "$MC_DIR/versions/fabric-loader-${LOADER_VERSION}-${MC_VERSION}/fabric-loader-${LOADER_VERSION}-${MC_VERSION}.jar" ]; then
  echo "[Setup] Installing Fabric client..."
  curl -fL --retry 3 -o /tmp/fabric-installer.jar \
    "https://maven.fabricmc.net/net/fabricmc/fabric-installer/1.0.3/fabric-installer-1.0.3.jar"
  java -jar /tmp/fabric-installer.jar client \
    -mcversion "$MC_VERSION" \
    -loader "$LOADER_VERSION" \
    -dir "$MC_DIR"
fi

# Install Fabric API matching 26.1.2.
if [ ! -f "$MC_DIR/mods/fabric-api-${API_VERSION}.jar" ]; then
  echo "[Setup] Installing Fabric API ${API_VERSION}..."
  curl -fL --retry 3 -o "$MC_DIR/mods/fabric-api-${API_VERSION}.jar" \
    "https://maven.fabricmc.net/net/fabricmc/fabric-api/fabric-api/${API_VERSION}/fabric-api-${API_VERSION}.jar"
fi

# Copy the user's supplied mods.
cp -f /opt/app/mods/*.jar "$MC_DIR/mods/"

# Do not put credentials in the image. Railway environment variables are used.
#
# OFFLINE/LOCAL SERVER:
#   MC_AUTH_MODE=offline
#   MC_USERNAME=pampa
#
# ONLINE SERVER:
#   MC_AUTH_MODE=online
#   MC_USERNAME=...
#   MC_ACCESS_TOKEN=...
#   MC_UUID=...
#
# A real Microsoft account access token is required by an online-mode server.
AUTH_ARGS=()
if [ "${MC_AUTH_MODE:-offline}" = "online" ]; then
  : "${MC_ACCESS_TOKEN:?MC_ACCESS_TOKEN is required for online auth}"
  : "${MC_UUID:?MC_UUID is required for online auth}"
  : "${MC_USERNAME:?MC_USERNAME is required for online auth}"
  AUTH_ARGS+=(--username "$MC_USERNAME" --uuid "$MC_UUID" --accessToken "$MC_ACCESS_TOKEN")
else
  MC_USERNAME="${MC_USERNAME:-pampa}"
  AUTH_ARGS+=(--username "$MC_USERNAME" --uuid "${MC_UUID:-00000000-0000-0000-0000-000000000001}" --accessToken "${MC_ACCESS_TOKEN:-0}")
fi

# Launch the actual Fabric Minecraft client, not Mineflayer.
# Xvfb supplies a virtual display because Minecraft's client renderer is required.
cd "$MC_DIR"
exec xvfb-run -a -s "-screen 0 1280x720x24" \
  java -Xms512M -Xmx2G \
  -Djava.awt.headless=false \
  -jar "versions/fabric-loader-${LOADER_VERSION}-${MC_VERSION}/fabric-loader-${LOADER_VERSION}-${MC_VERSION}.jar" \
  "${AUTH_ARGS[@]}" \
  --version "fabric-loader-${LOADER_VERSION}-${MC_VERSION}" \
  --gameDir "$MC_DIR" \
  --assetsDir "$MC_DIR/assets" \
  --server "$MC_SERVER_HOST" \
  --port "$MC_SERVER_PORT"
