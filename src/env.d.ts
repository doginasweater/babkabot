export { };

declare global {
  namespace NodeJS {
    interface ProcessEnv {
      DISCORD_API_TOKEN: string;
      TEST_SERVER: string;
    }
  }
}
