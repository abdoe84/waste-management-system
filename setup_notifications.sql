-- إعداد جدول الإشعارات في Supabase
-- قم بتشغيل هذا الكود في SQL Editor في Supabase Dashboard

-- جدول الإشعارات
CREATE TABLE IF NOT EXISTS ms_notifications (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    form_id BIGINT REFERENCES ms_forms(id) ON DELETE CASCADE,
    type VARCHAR(50) NOT NULL, -- 'new_request', 'approved', 'rejected', 'review_needed', 'status_update'
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    action_url TEXT, -- URL للانتقال عند النقر على الإشعار
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- إنشاء فهرس لتحسين الأداء
CREATE INDEX IF NOT EXISTS idx_ms_notifications_user_id ON ms_notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_ms_notifications_form_id ON ms_notifications(form_id);
CREATE INDEX IF NOT EXISTS idx_ms_notifications_is_read ON ms_notifications(is_read);
CREATE INDEX IF NOT EXISTS idx_ms_notifications_created_at ON ms_notifications(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_ms_notifications_user_read ON ms_notifications(user_id, is_read);

-- تفعيل Row Level Security (RLS)
ALTER TABLE ms_notifications ENABLE ROW LEVEL SECURITY;

-- إزالة السياسات القديمة إن وجدت
DROP POLICY IF EXISTS "Users can view their own notifications" ON ms_notifications;
DROP POLICY IF EXISTS "Users can update their own notifications" ON ms_notifications;
DROP POLICY IF EXISTS "System can insert notifications" ON ms_notifications;
DROP POLICY IF EXISTS "Allow public select on ms_notifications" ON ms_notifications;
DROP POLICY IF EXISTS "Allow public update on ms_notifications" ON ms_notifications;
DROP POLICY IF EXISTS "Allow public insert on ms_notifications" ON ms_notifications;

-- سياسة للسماح بقراءة الإشعارات (الفلترة تتم في الكود حسب user_id)
CREATE POLICY "Allow public select on ms_notifications" ON ms_notifications
    FOR SELECT 
    TO public
    USING (true);

-- سياسة للسماح بتحديث الإشعارات
CREATE POLICY "Allow public update on ms_notifications" ON ms_notifications
    FOR UPDATE 
    TO public
    USING (true)
    WITH CHECK (true);

-- سياسة للسماح بإدراج الإشعارات
CREATE POLICY "Allow public insert on ms_notifications" ON ms_notifications
    FOR INSERT 
    TO public
    WITH CHECK (true);

-- منح الصلاحيات على التسلسل (Sequence)
GRANT USAGE, SELECT ON SEQUENCE ms_notifications_id_seq TO anon, authenticated, public;

-- منح الصلاحيات على الجدول
GRANT SELECT, INSERT, UPDATE ON TABLE ms_notifications TO anon, authenticated, public;

-- دالة لإنشاء إشعارات تلقائية عند تحديث حالة الطلب
CREATE OR REPLACE FUNCTION notify_on_status_change()
RETURNS TRIGGER AS $$
BEGIN
    -- إشعار للمستخدم عند تغيير حالة طلبه (فقط إذا كان user_id موجوداً)
    IF NEW.status != OLD.status AND NEW.user_id IS NOT NULL THEN
        INSERT INTO ms_notifications (user_id, form_id, type, title, message, action_url)
        VALUES (
            NEW.user_id,
            NEW.id,
            'status_update',
            'Status Updated',
            'Your request #' || NEW.id || ' status has been changed to ' || NEW.status,
            'my-requests.html?id=' || NEW.id
        );
        
        -- إشعار للمراجع عند وجود طلب جديد أو يحتاج مراجعة
        IF NEW.status = 'pending' OR NEW.status = 'under_review' THEN
            -- إشعار للمراجعين التقنيين
            INSERT INTO ms_notifications (user_id, form_id, type, title, message, action_url)
            SELECT 
                ur.user_id,
                NEW.id,
                'review_needed',
                'Review Required',
                'New request #' || NEW.id || ' from ' || NEW.name || ' needs review',
                'review.html?id=' || NEW.id
            FROM user_roles ur
            WHERE ur.role IN ('technical', 'manager', 'admin');
        END IF;
        
        -- إشعار للمدير عند الحاجة للموافقة النهائية
        IF NEW.status = 'pending_manager_approval' OR NEW.status = 'approved_review' THEN
            INSERT INTO ms_notifications (user_id, form_id, type, title, message, action_url)
            SELECT 
                ur.user_id,
                NEW.id,
                'approval_needed',
                'Manager Approval Required',
                'Request #' || NEW.id || ' from ' || NEW.name || ' needs manager approval',
                'manager-review.html?id=' || NEW.id
            FROM user_roles ur
            WHERE ur.role IN ('manager', 'admin');
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- إنشاء trigger لتشغيل الدالة عند تحديث حالة الطلب
DROP TRIGGER IF EXISTS trigger_notify_on_status_change ON ms_forms;
CREATE TRIGGER trigger_notify_on_status_change
    AFTER UPDATE OF status ON ms_forms
    FOR EACH ROW
    WHEN (OLD.status IS DISTINCT FROM NEW.status)
    EXECUTE FUNCTION notify_on_status_change();

-- دالة لإنشاء إشعار عند إنشاء طلب جديد
CREATE OR REPLACE FUNCTION notify_on_new_request()
RETURNS TRIGGER AS $$
BEGIN
    -- إشعار للمراجعين عند إنشاء طلب جديد
    INSERT INTO ms_notifications (user_id, form_id, type, title, message, action_url)
    SELECT 
        ur.user_id,
        NEW.id,
        'new_request',
        'New Request',
        'New request #' || NEW.id || ' from ' || NEW.name || ' (' || NEW.department || ')',
        'review.html?id=' || NEW.id
    FROM user_roles ur
    WHERE ur.role IN ('technical', 'manager', 'admin');
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- إنشاء trigger لتشغيل الدالة عند إنشاء طلب جديد
DROP TRIGGER IF EXISTS trigger_notify_on_new_request ON ms_forms;
CREATE TRIGGER trigger_notify_on_new_request
    AFTER INSERT ON ms_forms
    FOR EACH ROW
    EXECUTE FUNCTION notify_on_new_request();
