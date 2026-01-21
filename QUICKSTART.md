# Quick Start Guide

Get your Waste Management System up and running in 5 minutes!

## ⚡ Quick Setup

### Step 1: Get Supabase Credentials (2 minutes)

1. Go to [supabase.com](https://supabase.com) and sign up/login
2. Create a new project
3. Wait for project to be ready (1-2 minutes)
4. Go to **Project Settings** → **API**
5. Copy:
   - **Project URL** (looks like: `https://xxxxx.supabase.co`)
   - **anon public** key (long string under Project API keys)

### Step 2: Configure Project (1 minute)

1. Open `config.js` in your project
2. Replace:
   ```javascript
   SUPABASE_URL: 'https://your-project-id.supabase.co',
   SUPABASE_ANON_KEY: 'your-anon-key-here',
   ```
   with your actual credentials from Step 1

### Step 3: Set Up Database (2 minutes)

1. In Supabase Dashboard, go to **SQL Editor**
2. Open and run `supabase_setup.sql`
   - Click "Run" button
   - Wait for success message
3. Open and run `setup_stage3_attachments.sql`
   - Click "Run" button
   - Wait for success message

### Step 4: Set Up Storage (1 minute)

1. In Supabase Dashboard, go to **Storage**
2. Click **"New bucket"**
3. Name: `ms_attachments`
4. Make it **Public** ✅
5. Click **"Create bucket"**

### Step 5: Run Application

**Option A: Using VS Code Live Server**
- Install "Live Server" extension
- Right-click `index.html` → "Open with Live Server"
- Or just right-click anywhere and select "Open with Live Server"

**Option B: Using Python**
```bash
python -m http.server 8000
# Open http://localhost:8000 (index.html will load automatically)
```

**Option C: Using Node.js**
```bash
npx http-server -p 8000
# Open http://localhost:8000 (index.html will load automatically)
```

## ✅ Test It Works

1. Open `index.html` in browser (or just open the root URL)
2. You'll be redirected to login page
3. Click **"Sign Up"**
4. Create an account with role **"User"**
5. Login
6. Try submitting a request via **"New Request"**

## 🎉 Done!

Your system is now running! 

**Next Steps:**
- Create accounts for Technical and Manager roles (via signup)
- Or change role in database: `UPDATE user_roles SET role = 'technical' WHERE user_id = 'user-id';`

## 🐛 Something Not Working?

- **Can't connect?** → Check `config.js` has correct credentials
- **Permission errors?** → Make sure SQL scripts ran successfully
- **Attachments not working?** → Check Storage bucket exists and is Public
- **Users can't access pages?** → Check user roles in `user_roles` table

See `README.md` for detailed documentation!
