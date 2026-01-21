// Configuration file for Supabase and project settings
// Copy this file to config.js and update with your Supabase credentials
//
// IMPORTANT: Never commit config.js with real credentials to version control!
// Use config.example.js as a template for your local config.js file

const CONFIG = {
    // Your Supabase project URL
    // Found in: Supabase Dashboard → Project Settings → API → Project URL
    SUPABASE_URL: 'https://your-project-id.supabase.co',
    
    // Your Supabase anonymous (public) key
    // Found in: Supabase Dashboard → Project Settings → API → Project API keys → anon public
    SUPABASE_ANON_KEY: 'your-supabase-anon-key-here',
    
    PROJECT_NAME: 'Reviva MS Form',
    PROJECT_VERSION: '1.0.0'
};

// Make config globally available
window.CONFIG = CONFIG;
