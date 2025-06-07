import { defineConfig } from "vite";

export default defineConfig({
  root: ".",
  base: "./",
  server: {
    host: true,
    port: 3000,
  },
  build: {
    outDir: "dist",
  },
  resolve: {
    alias: {},
  },
});
