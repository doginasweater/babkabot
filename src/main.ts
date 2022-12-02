import * as dotenv from 'dotenv';
import { ChatInputCommandInteraction, Client, Collection, Events, REST, RESTPostAPIChatInputApplicationCommandsJSONBody, Routes, SlashCommandBuilder } from 'discord.js';
import { PrismaClient } from '@prisma/client';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { deploy } from './deploy.js';

export type Command = {
  data: SlashCommandBuilder;
  execute: (interaction: ChatInputCommandInteraction) => Promise<void>;
}

dotenv.config();

const { DISCORD_API_TOKEN, DISCORD_CLIENT_ID, TEST_SERVER } = process.env;

if (!DISCORD_API_TOKEN || !DISCORD_CLIENT_ID || !TEST_SERVER) {
  console.error("You must set your env variables correctly.");
  process.exit(1);
}

export const prisma = new PrismaClient();
export const client = new Client({
  intents: []
});

const commands = new Collection<string, Command>();

const commandsPath = path.join(path.dirname(fileURLToPath(import.meta.url)), 'commands');
const commandFiles = fs.readdirSync(commandsPath).filter(file => file.endsWith('.ts'));

for (const file of commandFiles) {
  const filePath = path.join(commandsPath, file);

  import(filePath).then((command: Command) => {
    if ('data' in command && 'execute' in command) {
      commands.set(command?.data.name, command);
    } else {
      console.log(`Failed to load command at ${filePath}`);
    }
  }).catch(console.error);
}

client.on(Events.InteractionCreate, async interaction => {
  if (!interaction.isChatInputCommand()) {
    return;
  }

  const command = commands.get(interaction.commandName);

  if (!command) {
    console.error(`No command matching ${interaction.commandName} was found.`);
    return;
  }

  try {
    await command.execute(interaction);
  } catch (error) {
    console.error(error);

    await interaction.reply({ content: 'There was an error while executing this command.', ephemeral: true });
  }
});

client.on(Events.ClientReady, client => {
  console.log('Attempting to deploy slash commands');

  deploy(DISCORD_API_TOKEN, DISCORD_CLIENT_ID, TEST_SERVER).catch(console.error);
});

try {
  console.log('Bot is starting...');

  await client.login(DISCORD_API_TOKEN);

  console.log(`${client?.user?.username ?? 'bot user'} has logged in.`);
} catch (err) {
  console.error(err);

  await prisma.$disconnect();
}

await prisma.$disconnect();
