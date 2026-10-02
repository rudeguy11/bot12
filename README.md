# RudeFabricBot — Railway 26.1.2

## Deploy
1. Push the CONTENTS of this folder to a GitHub repository (Dockerfile must be in the repository root).
2. In Railway choose Deploy from GitHub and select the repository.
3. Railway will detect the root `Dockerfile` and build it.
4. Add these Railway Variables:
   - `MC_HOST` = your Minecraft server address
   - `MC_PORT` = your server port
   - `MC_VERSION` = `26.1`
   - `BOT_USERNAME` = bot username
   - `BOT_AUTH` = `offline` for an offline-mode server
   - `AUTH_PASSWORD` = server `/login` or `/register` password, if applicable
5. Deploy.

## Important limitation
This package updates the Mineflayer side to Minecraft 26.1 and is Railway/Docker ready.
The `mods/` folder contains the Create, Traveler's Backpack, and ForgeConfigAPIPort
JARs you supplied, but Mineflayer does NOT execute Fabric JARs.

If the server kick is the Fabric Registry Sync message:
"This server requires Fabric Loader and Fabric API installed on your client"
then simply having these JARs in the container will NOT satisfy the server. That
requires a genuine Fabric Minecraft client. Do not expect this Mineflayer package
to bypass that client-mod requirement.

## Local test
Node 24+:
npm install
npm start
