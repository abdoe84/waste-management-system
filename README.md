# Waste Management System (MS Form)

A comprehensive waste management request system built with HTML, CSS, JavaScript, and Supabase. This system allows users to submit waste management requests, which go through a multi-stage review process involving technical staff and managers.

## 🚀 Features

- **User Authentication**: Secure login and signup with role-based access control
- **Role-Based Access**: Four user roles (User, Technical, Manager, Admin)
- **Request Management**: Submit, review, and approve waste management requests
- **Multi-Stage Workflow**: 
  - User submits request
  - Technical staff reviews and approves/rejects
  - Stage 3 data entry by technical staff
  - Manager review and approval
  - Final approval
- **File Attachments**: Support for Stage 3 attachments (multiple files per item)
- **Dashboard**: Role-specific dashboards with statistics and charts
- **My Requests**: Users can track their submitted requests
- **Notifications**: Users receive updates on their request status

## 📋 Prerequisites

Before you begin, ensure you have:

- A Supabase account ([sign up here](https://supabase.com))
- A Supabase project created
- A modern web browser (Chrome, Firefox, Edge, Safari)

## 🛠️ Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/waste-management-system.git
cd waste-management-system
```

### 2. Configure Supabase

1. Create a new Supabase project at [supabase.com](https://supabase.com)
2. Copy your project URL and anon key from Project Settings → API

### 3. Update Configuration

1. Open `config.js`
2. Replace the values with your Supabase credentials:

```javascript
const CONFIG = {
    SUPABASE_URL: 'your-supabase-project-url',
    SUPABASE_ANON_KEY: 'your-supabase-anon-key',
    PROJECT_NAME: 'Reviva MS Form',
    PROJECT_VERSION: '1.0.0'
};
```

### 4. Set Up Database

1. Go to your Supabase Dashboard → SQL Editor
2. Run `supabase_setup.sql` to create all necessary tables, policies, and triggers
3. Run `setup_stage3_attachments.sql` to set up Stage 3 attachments table

### 5. Set Up Storage

1. Go to Supabase Dashboard → Storage
2. Create a new bucket named `ms_attachments`
3. Make it **Public** (required for file access)

**Storage Policies:**
Run the following SQL in SQL Editor to set up storage policies:

```sql
-- Allow public uploads
CREATE POLICY "Allow public uploads"
ON storage.objects FOR INSERT
TO public
WITH CHECK (bucket_id = 'ms_attachments');

-- Allow public downloads
CREATE POLICY "Allow public downloads"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'ms_attachments');
```

### 6. Run the Application

You can run the application using one of these methods:

**Option 1: Local Server (Recommended)**
```bash
# Using Python 3
python -m http.server 8000

# Using Node.js (if you have http-server installed)
npx http-server -p 8000

# Using PHP
php -S localhost:8000
```

Then open `http://localhost:8000` in your browser.

**Option 2: VS Code Live Server**
- Install the "Live Server" extension in VS Code
- Right-click on `index.html` and select "Open with Live Server"
- Or just right-click anywhere and select "Open with Live Server"

**Option 3: GitHub Pages**
- Push your code to GitHub
- Go to Repository Settings → Pages
- Select your branch and `/ (root)` folder
- Your site will be available at `https://yourusername.github.io/repository-name`
- The `index.html` file will automatically serve as the entry point

## 📁 Project Structure

```
├── config.js                          # Supabase configuration
├── utils.js                           # Utility functions (auth, roles, etc.)
├── Logo.png                           # Application logo
│
├── login.html                         # Login page
├── signup.html                        # Registration page
├── dashboard.html                     # Main dashboard (role-based)
├── request-form.html                  # Submit new request
├── review.html                        # Technical review page
├── stage3.html                        # Stage 3 data entry
├── manager-review.html                # Manager review page
├── my-requests.html                   # User's submitted requests
├── user-management.html               # Admin user management
│
├── supabase_setup.sql                 # Main database setup script
├── setup_stage3_attachments.sql       # Stage 3 attachments setup
│
├── README.md                          # This file
├── README_ENV.md                      # Environment configuration guide
└── SUPABASE_SETUP_STAGE3_ATTACHMENTS.md  # Stage 3 attachments guide
```

## 👥 User Roles

- **User**: Submit waste management requests and track their status
- **Technical**: Review requests, approve/reject, and fill Stage 3 data
- **Manager**: Review Stage 3 data and approve/reject requests
- **Admin**: Full access including user management

## 🔐 Security Notes

⚠️ **Important**: The `config.js` file contains your Supabase credentials. 

- **For Development**: Keep `config.js` with your credentials locally (make sure it's in `.gitignore` if not already)
- **For Production**: Consider using environment variables or a backend service to manage credentials securely
- The **anon key** is designed to be public, but ensure Row Level Security (RLS) policies are properly configured
- Never commit your **service role key** to the repository

## 📝 Workflow

1. **User** submits a request via `request-form.html`
2. **Technical** user reviews the request in `review.html`
   - Can approve → moves to Stage 3
   - Can reject → returns to user with reason
3. **Technical** user fills Stage 3 data in `stage3.html`
   - Includes environmental data and attachments
4. **Manager** reviews Stage 3 data in `manager-review.html`
   - Can approve → request completed
   - Can reject → returns to technical with reason
5. **User** can view their requests and final results in `my-requests.html`

## 🐛 Troubleshooting

### Issue: "Permission denied" errors
- **Solution**: Ensure RLS policies are set up correctly in `supabase_setup.sql`
- Check that sequences have proper permissions
- Verify user is authenticated

### Issue: Attachments not uploading
- **Solution**: 
  - Ensure `ms_attachments` bucket exists and is Public
  - Check storage policies are set correctly
  - Check browser console for detailed error messages
  - See `SUPABASE_SETUP_STAGE3_ATTACHMENTS.md` for detailed setup

### Issue: Users can't access certain pages
- **Solution**: Check user roles in `user_roles` table
- Ensure `utils.js` functions are working correctly
- Check browser console for authentication errors

## 📚 Documentation

- `README_ENV.md` - Configuration guide
- `SUPABASE_SETUP_STAGE3_ATTACHMENTS.md` - Stage 3 attachments setup guide

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License.

## 👨‍💻 Support

For issues, questions, or contributions, please open an issue on GitHub.

---

**Note**: Make sure to update `config.js` with your own Supabase credentials before deploying!
