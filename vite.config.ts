import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import path from 'path'

// https://vite.dev/config/
export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'),
    },
  },
  build: {
    outDir: 'dist',
    emptyOutDir: true,
  },
  server: {
    port: 8080,
    proxy: {
      '/api': {
        target: 'http://localhost:4943',
        changeOrigin: true,
      },
    },
  },
  define: {
    'process.env.DFX_NETWORK': JSON.stringify(process.env.DFX_NETWORK || 'local'),
    'process.env.ARBITRA_BACKEND_CANISTER_ID': JSON.stringify(process.env.ARBITRA_BACKEND_CANISTER_ID || ''),
    'process.env.EVIDENCE_MANAGER_CANISTER_ID': JSON.stringify(process.env.EVIDENCE_MANAGER_CANISTER_ID || ''),
    'process.env.AI_ANALYSIS_CANISTER_ID': JSON.stringify(process.env.AI_ANALYSIS_CANISTER_ID || ''),
    'process.env.BITCOIN_ESCROW_CANISTER_ID': JSON.stringify(process.env.BITCOIN_ESCROW_CANISTER_ID || ''),
    'process.env.INTERNET_IDENTITY_CANISTER_ID': JSON.stringify(process.env.INTERNET_IDENTITY_CANISTER_ID || 'rdmx6-jaaaa-aaaaa-aaadq-cai'),
  },
})
