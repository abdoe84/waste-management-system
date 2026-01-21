-- إعداد جدول مرفقات Stage 3 في Supabase
-- قم بتشغيل هذا الكود في SQL Editor في Supabase Dashboard

-- جدول مرفقات Stage 3
CREATE TABLE IF NOT EXISTS ms_stage3_attachments (
    id BIGSERIAL PRIMARY KEY,
    form_id BIGINT NOT NULL REFERENCES ms_forms(id) ON DELETE CASCADE,
    stage3_data_id BIGINT REFERENCES ms_stage3_data(id) ON DELETE CASCADE,
    item_id BIGINT REFERENCES ms_form_items(id) ON DELETE CASCADE,
    filename VARCHAR(255) NOT NULL,
    file_type VARCHAR(100),
    file_size BIGINT,
    file_url TEXT NOT NULL,
    storage_path TEXT NOT NULL,
    uploaded_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    uploaded_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- إنشاء فهرس لتحسين الأداء
CREATE INDEX IF NOT EXISTS idx_ms_stage3_attachments_form_id ON ms_stage3_attachments(form_id);
CREATE INDEX IF NOT EXISTS idx_ms_stage3_attachments_stage3_data_id ON ms_stage3_attachments(stage3_data_id);
CREATE INDEX IF NOT EXISTS idx_ms_stage3_attachments_item_id ON ms_stage3_attachments(item_id);

-- تفعيل Row Level Security (RLS)
ALTER TABLE ms_stage3_attachments ENABLE ROW LEVEL SECURITY;

-- إزالة السياسات القديمة إن وجدت
DROP POLICY IF EXISTS "Allow public insert on ms_stage3_attachments" ON ms_stage3_attachments;
DROP POLICY IF EXISTS "Allow public select on ms_stage3_attachments" ON ms_stage3_attachments;
DROP POLICY IF EXISTS "Allow public update on ms_stage3_attachments" ON ms_stage3_attachments;
DROP POLICY IF EXISTS "Allow public delete on ms_stage3_attachments" ON ms_stage3_attachments;

-- سياسة للسماح بالإدراج
CREATE POLICY "Allow public insert on ms_stage3_attachments" ON ms_stage3_attachments
    FOR INSERT 
    TO public
    WITH CHECK (true);

-- سياسة للسماح بالقراءة
CREATE POLICY "Allow public select on ms_stage3_attachments" ON ms_stage3_attachments
    FOR SELECT 
    TO public
    USING (true);

-- سياسة للسماح بالتحديث
CREATE POLICY "Allow public update on ms_stage3_attachments" ON ms_stage3_attachments
    FOR UPDATE 
    TO public
    USING (true)
    WITH CHECK (true);

-- سياسة للسماح بالحذف
CREATE POLICY "Allow public delete on ms_stage3_attachments" ON ms_stage3_attachments
    FOR DELETE 
    TO public
    USING (true);

-- منح الصلاحيات على التسلسل (Sequence)
GRANT USAGE, SELECT ON SEQUENCE ms_stage3_attachments_id_seq TO anon, authenticated;