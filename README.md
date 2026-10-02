# RudeGuy Fabric Bot — real Fabric client

This project is intentionally different from the old Mineflayer bot: it launches an actual Minecraft 26.1.2 client under Fabric Loader and loads the supplied client mods plus a small Fabric client automation mod.

## Included supplied mods
- Create Fly 6.0.9-4 for 26.1.2
- Traveler's Backpack 11.2.11 for Fabric 26.1.2
- ForgeConfigAPIPort 26.1.5 for Minecraft 26.1.x

Fabric API 0.155.3+26.1.2 and Fabric Loader 0.19.3 are downloaded during the Docker build.

## Railway variables
Set:
MC_SERVER_HOST
MC_SERVER_PORT
MC_USERNAME

Optional:
BOT_LOGIN_COMMAND=login YOUR_PASSWORD
MC_MEMORY=1536M

Do NOT commit passwords or account credentials to GitHub.

## Important authentication note
This container is designed for servers that allow offline/cracked client connections. A normal online-mode Minecraft account requires a real authenticated session; do not put Microsoft passwords/tokens into this repository.

## Local test
Requires JDK 25 and Docker. Build:
  docker build -t rudeguy-fabric-bot .
Run:
  docker run --rm --env-file .env rudeguy-fabric-bot

## What proves the Fabric check passed?
Look in the server console for the actual player join. The previous Mineflayer message `Successfully spawned` is not sufficient. The server must no longer issue the Fabric Loader/Fabric API registry kick.
