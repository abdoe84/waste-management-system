// Utility functions for user roles and permissions

// Get Supabase configuration from CONFIG (loaded from config.js)
const SUPABASE_URL = (typeof CONFIG !== 'undefined' && CONFIG.SUPABASE_URL) 
    ? CONFIG.SUPABASE_URL 
    : 'https://gcxvaclwugxdzwqbwtlx.supabase.co';

const SUPABASE_ANON_KEY = (typeof CONFIG !== 'undefined' && CONFIG.SUPABASE_ANON_KEY)
    ? CONFIG.SUPABASE_ANON_KEY
    : 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdjeHZhY2x3dWd4ZHp3cWJ3dGx4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjU1NTQzNjYsImV4cCI6MjA4MTEzMDM2Nn0.jcRRo-oUjKp7pNvSzq8Rw7mJRk_htfN87VGG3j7TCBs';

// Initialize Supabase client (make it globally available)
if (typeof supabase !== 'undefined') {
    const supabaseClient = supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
    window.supabaseClient = supabaseClient; // Make it globally available
} else {
    console.error('Supabase library not loaded');
}

// User roles
const ROLES = {
    USER: 'user',
    TECHNICAL: 'technical',
    MANAGER: 'manager',
    ADMIN: 'admin'
};

// Get current user role (returns default if no user/session)
async function getUserRole(userId) {
    try {
        if (!userId) return ROLES.USER;

        if (!window.supabaseClient) {
            console.warn('Supabase client not initialized');
            return ROLES.USER;
        }
        
        const { data, error } = await window.supabaseClient
            .from('user_roles')
            .select('role')
            .eq('user_id', userId)
            .maybeSingle();

        if (error) {
            // Handle permission errors gracefully
            if (error.code === '42501' || error.code === 'PGRST301' || error.message?.includes('permission') || error.message?.includes('403')) {
                console.warn('Permission denied for user_roles, using default role');
                return ROLES.USER;
            }
            console.error('Error getting user role:', error);
            return ROLES.USER;
        }
        
        if (!data) {
            return ROLES.USER; // Default role if no record found
        }

        return data.role;
    } catch (error) {
        console.error('Error getting user role:', error);
        return ROLES.USER;
    }
}

// Get current user info with role
async function getCurrentUser() {
    try {
        if (!window.supabaseClient) {
            return null;
        }
        
        const { data: { session }, error: sessionError } = await window.supabaseClient.auth.getSession();
        
        if (sessionError) {
            console.warn('Session error:', sessionError);
            return null;
        }
        
        if (!session || !session.user) {
            return null;
        }

        const { user } = session;
        
        // Get role, but don't fail if it errors
        let role = ROLES.USER; // Default role
        try {
            role = await getUserRole(user.id);
        } catch (roleError) {
            // If getting role fails (e.g., 403), use default
            console.warn('Could not get user role, using default:', roleError);
            role = ROLES.USER;
        }

        return {
            ...user,
            role: role
        };
    } catch (error) {
        console.error('Error getting current user:', error);
        return null;
    }
}

// Check if user has required role
async function hasRole(requiredRoles) {
    const user = await getCurrentUser();
    if (!user) return false;
    
    if (Array.isArray(requiredRoles)) {
        return requiredRoles.includes(user.role);
    }
    
    return user.role === requiredRoles;
}

// Check if user is admin
async function isAdmin() {
    return await hasRole(ROLES.ADMIN);
}

// Check if user is manager or admin
async function isManagerOrAdmin() {
    return await hasRole([ROLES.MANAGER, ROLES.ADMIN]);
}

// Check if user is technical, manager or admin
async function isTechnicalOrAbove() {
    return await hasRole([ROLES.TECHNICAL, ROLES.MANAGER, ROLES.ADMIN]);
}

// Redirect based on user role
async function redirectBasedOnRole() {
    const user = await getCurrentUser();
    if (!user) {
        window.location.href = 'login.html';
        return;
    }

    const currentPath = window.location.pathname;
    const currentPage = currentPath.split('/').pop();

    // Define page access rules
    const userPages = ['request-form.html', 'dashboard.html'];
    const technicalPages = ['review.html', 'stage3.html', 'dashboard.html'];
    const managerPages = ['manager-review.html', 'dashboard.html'];
    const adminPages = ['admin.html', 'user-management.html', 'dashboard.html'];

    // Check access based on role
    if (user.role === ROLES.USER) {
        if (!userPages.includes(currentPage) && currentPage !== '' && currentPage !== 'dashboard.html') {
            window.location.href = 'dashboard.html';
        }
    } else if (user.role === ROLES.TECHNICAL) {
        if (!userPages.includes(currentPage) && !technicalPages.includes(currentPage) && currentPage !== '' && currentPage !== 'dashboard.html') {
            window.location.href = 'dashboard.html';
        }
    } else if (user.role === ROLES.MANAGER) {
        if (!userPages.includes(currentPage) && !technicalPages.includes(currentPage) && !managerPages.includes(currentPage) && currentPage !== '' && currentPage !== 'dashboard.html') {
            window.location.href = 'dashboard.html';
        }
    } else if (user.role === ROLES.ADMIN) {
        // Admin can access all pages
        return;
    }
}

// Require authentication and role
async function requireAuth(requiredRoles) {
    const user = await getCurrentUser();
    
    if (!user) {
        window.location.href = 'login.html';
        return false;
    }

    if (requiredRoles && !await hasRole(requiredRoles)) {
        alert('You do not have permission to access this page.');
        // Redirect to appropriate page based on role
        await redirectBasedOnRole();
        return false;
    }

    return true;
}

// Get role display name
function getRoleDisplayName(role) {
    const roleNames = {
        'user': 'User',
        'technical': 'Technical',
        'manager': 'Manager',
        'admin': 'Admin'
    };
    return roleNames[role] || 'User';
}

// Get role badge color
function getRoleBadgeColor(role) {
    const colors = {
        'user': '#6b7280',
        'technical': '#3b82f6',
        'manager': '#f59e0b',
        'admin': '#dc2626'
    };
    return colors[role] || '#6b7280';
}
