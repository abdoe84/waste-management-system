-- إعداد جدول مرفقات الفورم الأساسي في Supabase
-- قم بتشغيل هذا الكود في SQL Editor في Supabase Dashboard

-- جدول مرفقات الفورم الأساسي
CREATE TABLE IF NOT EXISTS ms_form_attachments (
    id BIGSERIAL PRIMARY KEY,
    form_id BIGINT NOT NULL REFERENCES ms_forms(id) ON DELETE CASCADE,
    item_id BIGINT REFERENCES ms_form_items(id) ON DELETE CASCADE,
    filename VARCHAR(255) NOT NULL,
    file_name VARCHAR(255),
    file_type VARCHAR(100),
    file_size BIGINT,
    file_url TEXT NOT NULL,
    storage_path TEXT NOT NULL,
    uploaded_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    uploaded_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- إضافة الأعمدة المفقودة إذا كان الجدول موجوداً مسبقاً
DO $$ 
BEGIN
    -- إضافة filename إذا لم يكن موجوداً
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'ms_form_attachments' AND column_name = 'filename'
    ) THEN
        ALTER TABLE ms_form_attachments ADD COLUMN filename VARCHAR(255) NOT NULL DEFAULT '';
    END IF;
    
    -- إضافة file_name إذا لم يكن موجوداً
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'ms_form_attachments' AND column_name = 'file_name'
    ) THEN
        ALTER TABLE ms_form_attachments ADD COLUMN file_name VARCHAR(255);
    END IF;
    
    -- إضافة file_type إذا لم يكن موجوداً
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'ms_form_attachments' AND column_name = 'file_type'
    ) THEN
        ALTER TABLE ms_form_attachments ADD COLUMN file_type VARCHAR(100);
    END IF;
    
    -- إضافة file_size إذا لم يكن موجوداً
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'ms_form_attachments' AND column_name = 'file_size'
    ) THEN
        ALTER TABLE ms_form_attachments ADD COLUMN file_size BIGINT;
    END IF;
    
    -- إضافة file_url إذا لم يكن موجوداً
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'ms_form_attachments' AND column_name = 'file_url'
    ) THEN
        ALTER TABLE ms_form_attachments ADD COLUMN file_url TEXT NOT NULL DEFAULT '';
    END IF;
    
    -- إضافة storage_path إذا لم يكن موجوداً
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'ms_form_attachments' AND column_name = 'storage_path'
    ) THEN
        ALTER TABLE ms_form_attachments ADD COLUMN storage_path TEXT NOT NULL DEFAULT '';
    END IF;
    
    -- إضافة uploaded_by إذا لم يكن موجوداً
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'ms_form_attachments' AND column_name = 'uploaded_by'
    ) THEN
        ALTER TABLE ms_form_attachments ADD COLUMN uploaded_by UUID REFERENCES auth.users(id) ON DELETE SET NULL;
    END IF;
    
    -- إضافة uploaded_at إذا لم يكن موجوداً
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'ms_form_attachments' AND column_name = 'uploaded_at'
    ) THEN
        ALTER TABLE ms_form_attachments ADD COLUMN uploaded_at TIMESTAMP WITH TIME ZONE DEFAULT NOW();
    END IF;
    
    -- إضافة created_at إذا لم يكن موجوداً
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'ms_form_attachments' AND column_name = 'created_at'
    ) THEN
        ALTER TABLE ms_form_attachments ADD COLUMN created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW();
    END IF;
END $$;

-- إنشاء فهرس لتحسين الأداء
CREATE INDEX IF NOT EXISTS idx_ms_form_attachments_form_id ON ms_form_attachments(form_id);
CREATE INDEX IF NOT EXISTS idx_ms_form_attachments_item_id ON ms_form_attachments(item_id);

-- تفعيل Row Level Security (RLS)
ALTER TABLE ms_form_attachments ENABLE ROW LEVEL SECURITY;

-- إزالة السياسات القديمة إن وجدت
DROP POLICY IF EXISTS "Allow public insert on ms_form_attachments" ON ms_form_attachments;
DROP POLICY IF EXISTS "Allow public select on ms_form_attachments" ON ms_form_attachments;
DROP POLICY IF EXISTS "Allow public update on ms_form_attachments" ON ms_form_attachments;
DROP POLICY IF EXISTS "Allow public delete on ms_form_attachments" ON ms_form_attachments;

-- سياسة للسماح بالإدراج
CREATE POLICY "Allow public insert on ms_form_attachments" ON ms_form_attachments
    FOR INSERT 
    TO public
    WITH CHECK (true);

-- سياسة للسماح بالقراءة
CREATE POLICY "Allow public select on ms_form_attachments" ON ms_form_attachments
    FOR SELECT 
    TO public
    USING (true);

-- سياسة للسماح بالتحديث
CREATE POLICY "Allow public update on ms_form_attachments" ON ms_form_attachments
    FOR UPDATE 
    TO public
    USING (true)
    WITH CHECK (true);

-- سياسة للسماح بالحذف
CREATE POLICY "Allow public delete on ms_form_attachments" ON ms_form_attachments
    FOR DELETE 
    TO public
    USING (true);

-- منح الصلاحيات على التسلسل (Sequence)
GRANT USAGE, SELECT ON SEQUENCE ms_form_attachments_id_seq TO anon, authenticated;
