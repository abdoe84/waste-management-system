-- إعداد جداول قاعدة البيانات لـ MS Form في Supabase
-- قم بتشغيل هذا الكود في SQL Editor في Supabase Dashboard

-- جدول النماذج الرئيسي
CREATE TABLE IF NOT EXISTS ms_forms (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    department VARCHAR(100) NOT NULL,
    location VARCHAR(100) NOT NULL,
    description TEXT,
    status VARCHAR(50) DEFAULT 'pending', -- pending, under_review, rejected, approved_review, stage3_filled, manager_approved, manager_rejected, team_approved, completed
    rejection_reason TEXT,
    reviewer_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    manager_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    reviewed_at TIMESTAMP WITH TIME ZONE,
    submitted_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- إضافة الأعمدة الجديدة إذا كانت غير موجودة
DO $$ 
BEGIN
    -- إضافة user_id
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'ms_forms' AND column_name = 'user_id'
    ) THEN
        ALTER TABLE ms_forms 
        ADD COLUMN user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL;
    END IF;
    
    -- إضافة rejection_reason
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'ms_forms' AND column_name = 'rejection_reason'
    ) THEN
        ALTER TABLE ms_forms 
        ADD COLUMN rejection_reason TEXT;
    END IF;
    
    -- إضافة reviewer_id
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'ms_forms' AND column_name = 'reviewer_id'
    ) THEN
        ALTER TABLE ms_forms 
        ADD COLUMN reviewer_id UUID REFERENCES auth.users(id) ON DELETE SET NULL;
    END IF;
    
    -- إضافة manager_id
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'ms_forms' AND column_name = 'manager_id'
    ) THEN
        ALTER TABLE ms_forms 
        ADD COLUMN manager_id UUID REFERENCES auth.users(id) ON DELETE SET NULL;
    END IF;
    
    -- إضافة reviewed_at
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'ms_forms' AND column_name = 'reviewed_at'
    ) THEN
        ALTER TABLE ms_forms 
        ADD COLUMN reviewed_at TIMESTAMP WITH TIME ZONE;
    END IF;
END $$;

-- جدول عناصر النفايات
CREATE TABLE IF NOT EXISTS ms_form_items (
    id BIGSERIAL PRIMARY KEY,
    form_id BIGINT NOT NULL REFERENCES ms_forms(id) ON DELETE CASCADE,
    waste_name VARCHAR(255) NOT NULL,
    waste_description TEXT,
    physical_state VARCHAR(50) NOT NULL,
    quantity DECIMAL(10, 2) NOT NULL,
    quantity_unit VARCHAR(50),
    packing_type VARCHAR(100),
    truck_type VARCHAR(100),
    supporting_document TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- جدول بيانات Stage 3 (Environmental Data)
CREATE TABLE IF NOT EXISTS ms_stage3_data (
    id BIGSERIAL PRIMARY KEY,
    form_id BIGINT NOT NULL REFERENCES ms_forms(id) ON DELETE CASCADE,
    item_id BIGINT REFERENCES ms_form_items(id) ON DELETE CASCADE,
    wap_number VARCHAR(100),
    hazardous_classification VARCHAR(50), -- Hazardous, Non-Hazardous
    treatment_codes TEXT[], -- Array of codes: T-01, T-02, etc.
    discharge_codes TEXT[], -- Array of codes: D-01, D-02, etc.
    recycle_codes TEXT[], -- Array of codes: R-01, R-02, etc.
    recovered_materials TEXT[], -- Array: Oil/Solvent, Acid, Batteries, etc.
    oil_percent DECIMAL(5, 2),
    water_percent DECIMAL(5, 2),
    sludge_percent DECIMAL(5, 2),
    solvent_percent DECIMAL(5, 2),
    recovery_percent DECIMAL(5, 2),
    landfill_percent DECIMAL(5, 2),
    evaporation_pond_percent DECIMAL(5, 2),
    filled_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    filled_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- جدول المراجعات والتعليقات
CREATE TABLE IF NOT EXISTS ms_reviews (
    id BIGSERIAL PRIMARY KEY,
    form_id BIGINT NOT NULL REFERENCES ms_forms(id) ON DELETE CASCADE,
    reviewer_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    review_type VARCHAR(50), -- technician_review, manager_review, team_review
    action VARCHAR(50), -- approve, reject, request_revision
    comments TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- إنشاء فهرس لتحسين الأداء
CREATE INDEX IF NOT EXISTS idx_ms_forms_user_id ON ms_forms(user_id);
CREATE INDEX IF NOT EXISTS idx_ms_forms_reviewer_id ON ms_forms(reviewer_id);
CREATE INDEX IF NOT EXISTS idx_ms_forms_manager_id ON ms_forms(manager_id);
CREATE INDEX IF NOT EXISTS idx_ms_forms_email ON ms_forms(email);
CREATE INDEX IF NOT EXISTS idx_ms_forms_status ON ms_forms(status);
CREATE INDEX IF NOT EXISTS idx_ms_forms_submitted_at ON ms_forms(submitted_at);
CREATE INDEX IF NOT EXISTS idx_ms_form_items_form_id ON ms_form_items(form_id);
CREATE INDEX IF NOT EXISTS idx_ms_stage3_data_form_id ON ms_stage3_data(form_id);
CREATE INDEX IF NOT EXISTS idx_ms_stage3_data_item_id ON ms_stage3_data(item_id);
CREATE INDEX IF NOT EXISTS idx_ms_reviews_form_id ON ms_reviews(form_id);
CREATE INDEX IF NOT EXISTS idx_ms_reviews_reviewer_id ON ms_reviews(reviewer_id);

-- تفعيل Row Level Security (RLS) - اختياري
ALTER TABLE ms_forms ENABLE ROW LEVEL SECURITY;
ALTER TABLE ms_form_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE ms_stage3_data ENABLE ROW LEVEL SECURITY;
ALTER TABLE ms_reviews ENABLE ROW LEVEL SECURITY;

-- إزالة السياسات القديمة إن وجدت (لتجنب التعارض)
DROP POLICY IF EXISTS "Allow public insert on ms_forms" ON ms_forms;
DROP POLICY IF EXISTS "Allow public insert on ms_form_items" ON ms_form_items;
DROP POLICY IF EXISTS "Allow public insert on ms_stage3_data" ON ms_stage3_data;
DROP POLICY IF EXISTS "Allow public insert on ms_reviews" ON ms_reviews;
DROP POLICY IF EXISTS "Allow public select on ms_forms" ON ms_forms;
DROP POLICY IF EXISTS "Allow public select on ms_form_items" ON ms_form_items;
DROP POLICY IF EXISTS "Allow public select on ms_stage3_data" ON ms_stage3_data;
DROP POLICY IF EXISTS "Allow public select on ms_reviews" ON ms_reviews;
DROP POLICY IF EXISTS "Allow public update on ms_forms" ON ms_forms;
DROP POLICY IF EXISTS "Allow public update on ms_stage3_data" ON ms_stage3_data;

-- سياسة للسماح بالإدراج (يمكنك تعديلها حسب احتياجاتك)
CREATE POLICY "Allow public insert on ms_forms" ON ms_forms
    FOR INSERT 
    WITH CHECK (true);

CREATE POLICY "Allow public insert on ms_form_items" ON ms_form_items
    FOR INSERT 
    WITH CHECK (true);

CREATE POLICY "Allow public insert on ms_stage3_data" ON ms_stage3_data
    FOR INSERT 
    WITH CHECK (true);

CREATE POLICY "Allow public insert on ms_reviews" ON ms_reviews
    FOR INSERT 
    WITH CHECK (true);

-- سياسة للسماح بالقراءة (يمكنك تعديلها حسب احتياجاتك)
CREATE POLICY "Allow public select on ms_forms" 
ON ms_forms
FOR SELECT 
TO public
USING (true);

CREATE POLICY "Allow public select on ms_form_items" 
ON ms_form_items
FOR SELECT 
TO public
USING (true);

CREATE POLICY "Allow public select on ms_stage3_data" ON ms_stage3_data
    FOR SELECT 
    USING (true);

CREATE POLICY "Allow public select on ms_reviews" ON ms_reviews
    FOR SELECT 
    USING (true);

-- سياسة للسماح بالتحديث
CREATE POLICY "Allow public update on ms_forms" 
ON ms_forms
FOR UPDATE 
TO public
USING (true)
WITH CHECK (true);

CREATE POLICY "Allow public update on ms_stage3_data" ON ms_stage3_data
    FOR UPDATE 
    USING (true)
    WITH CHECK (true);

-- جدول أدوار المستخدمين
CREATE TABLE IF NOT EXISTS user_roles (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    role VARCHAR(50) NOT NULL DEFAULT 'user', -- user, technical, manager, admin
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id)
);

-- إنشاء فهرس لأدوار المستخدمين
CREATE INDEX IF NOT EXISTS idx_user_roles_user_id ON user_roles(user_id);
CREATE INDEX IF NOT EXISTS idx_user_roles_role ON user_roles(role);

-- تفعيل Row Level Security لجدول الأدوار
ALTER TABLE user_roles ENABLE ROW LEVEL SECURITY;

-- سياسات جدول الأدوار
DROP POLICY IF EXISTS "Allow public insert on user_roles" ON user_roles;
DROP POLICY IF EXISTS "Allow public select on user_roles" ON user_roles;
DROP POLICY IF EXISTS "Allow public update on user_roles" ON user_roles;

-- السماح بإدراج الأدوار
CREATE POLICY "Allow public insert on user_roles" 
ON user_roles
FOR INSERT 
TO authenticated, anon
WITH CHECK (true);

-- السماح بقراءة الأدوار
CREATE POLICY "Allow public select on user_roles" 
ON user_roles
FOR SELECT 
TO authenticated, anon
USING (true);

-- السماح بتحديث الأدوار
CREATE POLICY "Allow public update on user_roles" 
ON user_roles
FOR UPDATE 
TO authenticated, anon
USING (true)
WITH CHECK (true);

-- دالة لإضافة دور افتراضي عند إنشاء مستخدم جديد
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.user_roles (user_id, role)
    VALUES (NEW.id, 'user');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- إنشاء trigger لإضافة دور افتراضي للمستخدمين الجدد
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
