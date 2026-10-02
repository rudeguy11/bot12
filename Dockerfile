FROM eclipse-temurin:25-jdk

ENV DEBIAN_FRONTEND=noninteractive \
    MC_VERSION=26.1.2 \
    FABRIC_LOADER=0.19.3 \
    DISPLAY=:99 \
    JAVA_TOOL_OPTIONS="-Xmx2G -Xms512M"

RUN apt-get update && apt-get install -y --no-install-recommends curl unzip xvfb ca-certificates && rm -rf /var/lib/apt/lists/*
WORKDIR /app

COPY . /app

RUN chmod +x /app/entrypoint.sh
RUN mkdir -p /app/minecraft/mods /app/minecraft/natives

# Build the client-side bot mod. Fabric 26.1 uses unobfuscated Loom 1.15 and Java 25.
RUN curl -fsSL https://services.gradle.org/distributions/gradle-9.4-bin.zip -o /tmp/gradle.zip \
 && unzip -q /tmp/gradle.zip -d /opt \
 && ln -s /opt/gradle-9.4/bin/gradle /usr/local/bin/gradle \
 && cd /app \
 && gradle :fabric-bot:build --no-daemon \
 && cp /app/fabric-bot/build/libs/rudeguy-fabric-bot-1.0.0.jar /app/minecraft/mods/

# Fabric installer installs the official Minecraft client + Fabric Loader.
RUN curl -fsSL https://meta.fabricmc.net/v2/versions/installer -o /tmp/fabric-installer.json \
 && INSTALLER=$(grep -o '"url":"[^"]*"' /tmp/fabric-installer.json | head -1 | cut -d'"' -f4) \
 && curl -fsSL "$INSTALLER" -o /tmp/fabric-installer.jar \
 && java -jar /tmp/fabric-installer.jar client -mcversion ${MC_VERSION} -loader ${FABRIC_LOADER} -dir /app/minecraft -noprofile \
 && rm -f /tmp/fabric-installer.jar /tmp/fabric-installer.json /tmp/gradle.zip

COPY mods/*.jar /app/minecraft/mods/

ENTRYPOINT ["/app/entrypoint.sh"]
