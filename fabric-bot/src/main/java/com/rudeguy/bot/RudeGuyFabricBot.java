package com.rudeguy.bot;

import net.fabricmc.api.ClientModInitializer;
import net.fabricmc.fabric.api.client.networking.v1.ClientPlayConnectionEvents;
import net.minecraft.client.Minecraft;
import net.minecraft.network.chat.Component;

import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

public final class RudeGuyFabricBot implements ClientModInitializer {
    private static final ScheduledExecutorService EXECUTOR = Executors.newSingleThreadScheduledExecutor(r -> {
        Thread t = new Thread(r, "rudeguy-bot");
        t.setDaemon(true);
        return t;
    });

    @Override
    public void onInitializeClient() {
        ClientPlayConnectionEvents.JOIN.register((handler, sender, client) -> {
            log("Joined server as " + (client.player == null ? "unknown" : client.player.getName().getString()));

            // Optional server login command. Leave BOT_LOGIN_COMMAND empty if the server needs no /login.
            String login = System.getenv().getOrDefault("BOT_LOGIN_COMMAND", "").trim();
            if (!login.isEmpty()) {
                EXECUTOR.schedule(() -> runOnClient(client, () -> sendChat(client, login)), 3, TimeUnit.SECONDS);
            }
        });

        ClientPlayConnectionEvents.DISCONNECT.register((handler, client) -> log("Disconnected from server"));
        log("RudeGuy Fabric Bot loaded");
    }

    private static void runOnClient(Minecraft client, Runnable action) {
        client.execute(action);
    }

    private static void sendChat(Minecraft client, String message) {
        if (client.player == null) return;
        String text = message.startsWith("/") ? message : "/" + message;
        client.player.connection.sendCommand(text.substring(1));
        log("Sent command: " + text);
    }

    private static void log(String message) {
        System.out.println("[RudeGuyFabricBot] " + message);
    }
}
