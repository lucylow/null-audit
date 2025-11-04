import { createClient } from '@supabase/supabase-js';

// Build a robust URL: prefer VITE_SUPABASE_URL, otherwise derive from project id
const SUPABASE_URL =
  import.meta.env.VITE_SUPABASE_URL ||
  (import.meta.env.VITE_SUPABASE_PROJECT_ID
    ? `https://${import.meta.env.VITE_SUPABASE_PROJECT_ID}.supabase.co`
    : '');

const SUPABASE_PUBLISHABLE_KEY = import.meta.env.VITE_SUPABASE_PUBLISHABLE_KEY || '';

if (!SUPABASE_URL) {
  // Provide a helpful runtime hint for debugging
  // eslint-disable-next-line no-console
  console.error('Supabase URL missing. Ensure VITE_SUPABASE_URL or VITE_SUPABASE_PROJECT_ID is set.');
}
if (!SUPABASE_PUBLISHABLE_KEY) {
  // eslint-disable-next-line no-console
  console.error('Supabase anon key missing. Ensure VITE_SUPABASE_PUBLISHABLE_KEY is set.');
}

export const supabase = createClient(SUPABASE_URL, SUPABASE_PUBLISHABLE_KEY, {
  auth: {
    storage: localStorage,
    persistSession: true,
    autoRefreshToken: true,
  },
});
