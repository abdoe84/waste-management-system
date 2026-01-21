# Deployment Guide

This guide explains how to deploy the Waste Management System to various hosting platforms.

## 📋 Pre-Deployment Checklist

- [ ] Update `config.js` with production Supabase credentials
- [ ] Run all SQL setup scripts in Supabase
- [ ] Create and configure Storage bucket (`ms_attachments`)
- [ ] Test all functionality locally
- [ ] Review security settings (RLS policies)

## 🚀 Deployment Options

### Option 1: GitHub Pages (Free & Easy)

1. **Prepare the Repository**
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git branch -M main
   git remote add origin https://github.com/yourusername/waste-management-system.git
   git push -u origin main
   ```

2. **Enable GitHub Pages**
   - Go to your repository on GitHub
   - Navigate to **Settings** → **Pages**
   - Under **Source**, select `main` branch
   - Select `/ (root)` folder
   - Click **Save**

3. **Access Your Site**
   - Your site will be available at: `https://yourusername.github.io/repository-name`
   - Note: GitHub Pages requires HTTPS, which is compatible with Supabase

4. **Important Notes**
   - ⚠️ Do NOT commit `config.js` with real credentials
   - Use `config.example.js` as template
   - Consider using GitHub Secrets for sensitive data (requires backend)

### Option 2: Netlify (Free & Easy)

1. **Via Git**
   - Sign up at [netlify.com](https://netlify.com)
   - Click "New site from Git"
   - Connect your GitHub repository
   - Build settings:
     - Build command: (leave empty)
     - Publish directory: `/` (root)
   - Click "Deploy site"

2. **Via Drag & Drop**
   - Zip your project folder
   - Go to Netlify dashboard
   - Drag and drop the zip file
   - Site will be deployed automatically

3. **Environment Variables** (Optional)
   - Go to Site settings → Environment variables
   - Add your Supabase credentials
   - Note: This requires modifying the code to read from environment variables

### Option 3: Vercel (Free & Easy)

1. **Via Git**
   - Sign up at [vercel.com](https://vercel.com)
   - Click "New Project"
   - Import your GitHub repository
   - Configure:
     - Framework Preset: Other
     - Root Directory: `./`
   - Click "Deploy"

2. **Environment Variables** (Optional)
   - Go to Project Settings → Environment Variables
   - Add your Supabase credentials

### Option 4: Traditional Web Hosting (cPanel, etc.)

1. **Upload Files**
   - Upload all files to your `public_html` folder via FTP/cPanel File Manager
   - Ensure `config.js` has correct credentials

2. **Configure Domain**
   - Point your domain to the hosting server
   - Ensure HTTPS is enabled (required for Supabase)

## 🔒 Security Considerations

### For Production Deployment

1. **Supabase Anon Key**
   - The anon key is designed to be public
   - RLS policies protect your data
   - Never expose the service role key

2. **Config.js**
   - Option A: Keep credentials in `config.js` (simplest for static hosting)
   - Option B: Use a backend API to serve credentials securely
   - Option C: Use environment variables (requires build process)

3. **HTTPS Required**
   - All hosting platforms should use HTTPS
   - Required for Supabase authentication and secure connections

4. **CORS Settings**
   - Configure CORS in Supabase Dashboard → Settings → API
   - Add your production domain to allowed origins

## 📝 Post-Deployment

1. **Test Everything**
   - Test user registration/login
   - Test request submission
   - Test file uploads
   - Test all user roles

2. **Monitor**
   - Check Supabase Dashboard for errors
   - Monitor storage usage
   - Review authentication logs

3. **Backup**
   - Regular database backups via Supabase
   - Keep SQL scripts for easy restoration

## 🐛 Troubleshooting

### Issue: "CORS Error"
- **Solution**: Add your domain to Supabase allowed origins in Settings → API

### Issue: "Authentication not working"
- **Solution**: Check that your domain is allowed in Supabase → Authentication → URL Configuration

### Issue: "Files not uploading"
- **Solution**: Verify Storage bucket exists and is Public
- Check Storage policies are set correctly

## 🔄 Updating Your Deployment

1. Make changes locally
2. Test thoroughly
3. Commit and push to Git
4. If using GitHub Pages/Netlify/Vercel, deployment is automatic
5. If using traditional hosting, upload files via FTP

---

**Need Help?** Open an issue on GitHub!
