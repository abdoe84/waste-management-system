-- إصلاح صلاحيات جدول الإشعارات
-- قم بتشغيل هذا الكود في SQL Editor في Supabase Dashboard

-- إزالة السياسات القديمة
DROP POLICY IF EXISTS "Users can view their own notifications" ON ms_notifications;
DROP POLICY IF EXISTS "Users can update their own notifications" ON ms_notifications;
DROP POLICY IF EXISTS "System can insert notifications" ON ms_notifications;
DROP POLICY IF EXISTS "Allow public select on ms_notifications" ON ms_notifications;
DROP POLICY IF EXISTS "Allow public update on ms_notifications" ON ms_notifications;
DROP POLICY IF EXISTS "Allow public insert on ms_notifications" ON ms_notifications;

-- سياسة للسماح بقراءة الإشعارات (الفلترة تتم في الكود)
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

-- منح الصلاحيات على الجدول
GRANT SELECT, INSERT, UPDATE ON TABLE ms_notifications TO anon, authenticated, public;

-- منح الصلاحيات على التسلسل
GRANT USAGE, SELECT ON SEQUENCE ms_notifications_id_seq TO anon, authenticated, public;

-- التحقق من السياسات
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual
FROM pg_policies
WHERE tablename = 'ms_notifications';
