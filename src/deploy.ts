import { REST, RESTPostAPIChatInputApplicationCommandsJSONBody, Routes } from 'discord.js';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { Command } from './main.js';

export const deploy = async (token: string, clientId: string, testServer: string) => {
    const commands: RESTPostAPIChatInputApplicationCommandsJSONBody[] = [];

    const commandsPath = path.join(path.dirname(fileURLToPath(import.meta.url)), 'commands');
    const commandFiles = fs.readdirSync(commandsPath).filter(file => file.endsWith('.ts'));

    for (const file of commandFiles) {
        const filePath = path.join(commandsPath, file);

        const command = await import(filePath) as Command

        if ('data' in command && 'execute' in command) {
            commands.push(command.data.toJSON());
        } else {
            console.log(`Failed to load command at ${filePath}`);
        }
    }

    const rest = new REST({ version: '10' }).setToken(token);

    try {
        console.log('Registering / commands.');

        const data = await rest.put(
            Routes.applicationGuildCommands(clientId, testServer),
            { body: commands }
        );

        if (data && typeof data === 'object' && 'length' in data) {
            console.log(`Successfully registered ${String(data.length)} application commands.`);
        }
    } catch (error) {
        console.error(error);
    }
};
