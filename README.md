# RudeFabricBot — Railway Fabric Client

This package is intentionally different from the earlier Mineflayer-only build.

## What it does

It launches a **real Minecraft Java client** using:

- Minecraft 26.1.2
- Fabric Loader 0.19.2
- Fabric API for 26.1.2
- Create (your supplied JAR)
- Traveler's Backpack (your supplied JAR)
- ForgeConfigAPIPort (your supplied JAR)

The client then connects directly to the server with Minecraft's normal client connection.

This is necessary because a Mineflayer process does not load Fabric mods merely because their JARs are present in a `mods` folder.

## Railway variables

Set these in Railway:

```text
MC_SERVER_HOST=your-server-host
MC_SERVER_PORT=25565
MC_AUTH_MODE=offline
MC_USERNAME=pampa
```

Use `MC_AUTH_MODE=offline` only when the server itself permits offline authentication.

For an online-mode server, the client needs a valid Minecraft/Microsoft authentication token. Do not put account passwords in this repository.

## Local Docker test

```powershell
docker build -t rudefabricbot .
docker run --rm --env-file .env rudefabricbot
```

## Important limitation

This is a real Fabric client runner. It is **not a Mineflayer API bridge**. The existing Node.js Mineflayer command modules from the old project are kept in the repository for reference, but they do not control the Fabric client.

If you want the Fabric client itself to perform AFK movement, chat commands, reconnect logic, etc., that behavior must be implemented as a Fabric client mod or another controller that talks to the running client.

## Mods

The three JARs in `mods/` are the exact JARs supplied by you. Fabric API is downloaded during image startup for Minecraft 26.1.2.
