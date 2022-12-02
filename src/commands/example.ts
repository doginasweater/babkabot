import { ChatInputCommandInteraction, SlashCommandBuilder } from "discord.js";

export const data =
  new SlashCommandBuilder()
    .setName('example')
    .setDescription('An example slash command...?');

export const execute = async (interaction: ChatInputCommandInteraction) => {
  if (interaction.member && 'joinedAt' in interaction.member) {
    await interaction.reply(`This command was run by ${interaction.user.username}, who joined on ${interaction.member.joinedAt?.toString() ?? '???'}.`);
  } else {
    await interaction.reply(`This command was run by ${interaction.user.username}.`);
  }
}
