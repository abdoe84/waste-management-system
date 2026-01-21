// Configuration file for Supabase and project settings
// Note: In a browser environment, we can't use .env files directly
// This config.js file centralizes all configuration
//
// ⚠️ SECURITY WARNING: This file contains sensitive credentials
// For production, consider using environment variables or a backend service
//
// To use this project:
// 1. Copy config.example.js to config.js
// 2. Update SUPABASE_URL and SUPABASE_ANON_KEY with your credentials
// 3. Never commit config.js with real credentials to version control

const CONFIG = {
    // TODO: Replace with your Supabase project URL
    // Get it from: Supabase Dashboard → Project Settings → API → Project URL
    SUPABASE_URL: 'https://gcxvaclwugxdzwqbwtlx.supabase.co',
    
    // TODO: Replace with your Supabase anon key
    // Get it from: Supabase Dashboard → Project Settings → API → anon public key
    SUPABASE_ANON_KEY: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdjeHZhY2x3dWd4ZHp3cWJ3dGx4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjU1NTQzNjYsImV4cCI6MjA4MTEzMDM2Nn0.jcRRo-oUjKp7pNvSzq8Rw7mJRk_htfN87VGG3j7TCBs',
    
    PROJECT_NAME: 'Reviva MS Form',
    PROJECT_VERSION: '1.0.0'
};

// Make config globally available
window.CONFIG = CONFIG;
