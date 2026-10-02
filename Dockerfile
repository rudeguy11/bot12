FROM eclipse-temurin:25-jre-jammy

ENV DEBIAN_FRONTEND=noninteractive \
    FABRIC_MC_VERSION=26.1.2 \
    FABRIC_LOADER_VERSION=0.19.2 \
    FABRIC_API_VERSION=0.154.0+26.1.2 \
    MC_DIR=/opt/minecraft

RUN apt-get update \
 && apt-get install -y --no-install-recommends curl ca-certificates xvfb libxi6 libxrender1 libxtst6 libxext6 libgl1 libglx0 \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/app
COPY . /opt/app/

RUN chmod +x /opt/app/entrypoint.sh \
 && mkdir -p "${MC_DIR}/mods"

EXPOSE 8080

ENTRYPOINT ["/opt/app/entrypoint.sh"]
