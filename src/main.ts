import * as dotenv from 'dotenv';
import { Client } from 'discord.js';

dotenv.config();

console.log('Bot is starting...');

export const client = new Client({
  intents: []
});

await client.login(process.env.DISCORD_API_TOKEN);

console.log(`${client?.user?.username ?? 'bot user'} has logged in.`);
