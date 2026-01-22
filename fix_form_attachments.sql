-- إصلاح جدول ms_form_attachments - إضافة الأعمدة المفقودة
-- قم بتشغيل هذا الكود في SQL Editor في Supabase Dashboard

-- إضافة الأعمدة المفقودة
DO $$ 
BEGIN
    -- إضافة filename إذا لم يكن موجوداً
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'ms_form_attachments' AND column_name = 'filename'
    ) THEN
        ALTER TABLE ms_form_attachments ADD COLUMN filename VARCHAR(255);
        -- تحديث القيم الموجودة
        UPDATE ms_form_attachments SET filename = COALESCE(file_name, '') WHERE filename IS NULL;
        -- جعل العمود NOT NULL بعد التحديث
        ALTER TABLE ms_form_attachments ALTER COLUMN filename SET NOT NULL;
        RAISE NOTICE 'Added column: filename';
    END IF;
    
    -- إضافة file_name إذا لم يكن موجوداً
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'ms_form_attachments' AND column_name = 'file_name'
    ) THEN
        ALTER TABLE ms_form_attachments ADD COLUMN file_name VARCHAR(255);
        -- نسخ البيانات من filename إذا كان موجوداً
        UPDATE ms_form_attachments SET file_name = filename WHERE file_name IS NULL;
        RAISE NOTICE 'Added column: file_name';
    END IF;
    
    -- إضافة file_type إذا لم يكن موجوداً
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'ms_form_attachments' AND column_name = 'file_type'
    ) THEN
        ALTER TABLE ms_form_attachments ADD COLUMN file_type VARCHAR(100);
        RAISE NOTICE 'Added column: file_type';
    END IF;
    
    -- إضافة file_size إذا لم يكن موجوداً
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'ms_form_attachments' AND column_name = 'file_size'
    ) THEN
        ALTER TABLE ms_form_attachments ADD COLUMN file_size BIGINT;
        RAISE NOTICE 'Added column: file_size';
    END IF;
    
    -- إضافة file_url إذا لم يكن موجوداً
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'ms_form_attachments' AND column_name = 'file_url'
    ) THEN
        ALTER TABLE ms_form_attachments ADD COLUMN file_url TEXT;
        -- جعل العمود NOT NULL بعد إضافة القيم
        ALTER TABLE ms_form_attachments ALTER COLUMN file_url SET DEFAULT '';
        UPDATE ms_form_attachments SET file_url = '' WHERE file_url IS NULL;
        ALTER TABLE ms_form_attachments ALTER COLUMN file_url SET NOT NULL;
        RAISE NOTICE 'Added column: file_url';
    END IF;
    
    -- إضافة storage_path إذا لم يكن موجوداً
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'ms_form_attachments' AND column_name = 'storage_path'
    ) THEN
        ALTER TABLE ms_form_attachments ADD COLUMN storage_path TEXT;
        -- جعل العمود NOT NULL بعد إضافة القيم
        ALTER TABLE ms_form_attachments ALTER COLUMN storage_path SET DEFAULT '';
        UPDATE ms_form_attachments SET storage_path = '' WHERE storage_path IS NULL;
        ALTER TABLE ms_form_attachments ALTER COLUMN storage_path SET NOT NULL;
        RAISE NOTICE 'Added column: storage_path';
    END IF;
    
    -- إضافة uploaded_by إذا لم يكن موجوداً
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'ms_form_attachments' AND column_name = 'uploaded_by'
    ) THEN
        ALTER TABLE ms_form_attachments ADD COLUMN uploaded_by UUID REFERENCES auth.users(id) ON DELETE SET NULL;
        RAISE NOTICE 'Added column: uploaded_by';
    END IF;
    
    -- إضافة uploaded_at إذا لم يكن موجوداً
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'ms_form_attachments' AND column_name = 'uploaded_at'
    ) THEN
        ALTER TABLE ms_form_attachments ADD COLUMN uploaded_at TIMESTAMP WITH TIME ZONE DEFAULT NOW();
        RAISE NOTICE 'Added column: uploaded_at';
    END IF;
    
    -- إضافة created_at إذا لم يكن موجوداً
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'ms_form_attachments' AND column_name = 'created_at'
    ) THEN
        ALTER TABLE ms_form_attachments ADD COLUMN created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW();
        RAISE NOTICE 'Added column: created_at';
    END IF;
    
    RAISE NOTICE 'All columns checked and added if needed';
END $$;

-- التحقق من الأعمدة
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'ms_form_attachments'
ORDER BY ordinal_position;
