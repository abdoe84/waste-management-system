# دليل حل مشاكل المرفقات

## المشاكل الشائعة والحلول

### 1. خطأ: "Storage bucket 'ms_attachments' not found"

**السبب:** الـ bucket غير موجود في Supabase Storage

**الحل:**
1. اذهب إلى Supabase Dashboard > Storage
2. اضغط "New bucket"
3. اسم الـ bucket: `ms_attachments`
4. اختر "Public bucket" (مهم جداً!)
5. اضغط "Create bucket"

### 2. خطأ: "Table ms_form_attachments does not exist"

**السبب:** الجدول غير موجود في قاعدة البيانات

**الحل:**
1. اذهب إلى Supabase Dashboard > SQL Editor
2. افتح ملف `setup_form_attachments.sql`
3. انسخ المحتوى والصقه في SQL Editor
4. اضغط "Run" لتنفيذ الكود

### 3. خطأ: "Permission denied" أو "row-level security"

**السبب:** مشكلة في الصلاحيات (RLS Policies)

**الحل:**
1. تأكد من أنك شغّلت `setup_form_attachments.sql` (يحتوي على Policies)
2. اذهب إلى Supabase Dashboard > Storage > Policies
3. تأكد من وجود Policies للسماح بـ:
   - INSERT (لرفع الملفات)
   - SELECT (لقراءة الملفات)

### 4. الملفات تُرفع لكن لا تظهر في قاعدة البيانات

**السبب:** فشل في حفظ البيانات في الجدول

**الحل:**
1. افتح Console (F12) وابحث عن `[Upload] Database insert error`
2. تحقق من رسالة الخطأ
3. إذا كان الخطأ عن الجدول، شغّل `setup_form_attachments.sql`
4. إذا كان الخطأ عن الصلاحيات، تحقق من RLS Policies

## خطوات التحقق من أن كل شيء يعمل

### 1. التحقق من الـ Bucket
```
Supabase Dashboard > Storage > Buckets
- يجب أن ترى bucket باسم "ms_attachments"
- يجب أن يكون PUBLIC
```

### 2. التحقق من الجدول
```sql
-- في SQL Editor
SELECT * FROM ms_form_attachments LIMIT 5;
```
إذا ظهر خطأ، شغّل `setup_form_attachments.sql`

### 3. التحقق من الصلاحيات
```sql
-- في SQL Editor
SELECT * FROM pg_policies WHERE tablename = 'ms_form_attachments';
```
يجب أن ترى 4 policies على الأقل (INSERT, SELECT, UPDATE, DELETE)

### 4. اختبار الرفع
1. افتح `request-form.html`
2. املأ الفورم وأضف عنصر مع مرفق
3. أرسل الفورم
4. افتح Console (F12)
5. ابحث عن:
   - `[Upload] ✅ File uploaded to storage successfully`
   - `[Upload] ✅ Attachment metadata saved to database successfully`
   - `[Submit] Successfully uploaded: 1`

### 5. التحقق من الملفات في Storage
```
Supabase Dashboard > Storage > ms_attachments
- يجب أن ترى مجلد "form"
- داخل "form" يجب أن ترى "form-{formId}"
- داخل "form-{formId}" يجب أن ترى "item-{itemId}"
- داخل "item-{itemId}" يجب أن ترى الملفات
```

### 6. التحقق من البيانات في قاعدة البيانات
```sql
-- في SQL Editor
SELECT 
    id,
    form_id,
    item_id,
    filename,
    file_url,
    storage_path,
    created_at
FROM ms_form_attachments
ORDER BY created_at DESC
LIMIT 10;
```

## هيكل المجلدات المتوقع

```
ms_attachments/
├── form/
│   └── form-{formId}/
│       └── item-{itemId}/
│           └── {timestamp}-{random}-{filename}
└── stage3/
    └── form-{formId}/
        └── item-{itemId}/
            └── {timestamp}-{filename}
```

## رسائل Console المتوقعة عند النجاح

```
[Submit] ========== Starting form submission ==========
[Submit] Total items: 1
[Submit] Item 1: {hasDocument: true, fileName: "file.pdf"}
[Submit] Form created with ID: 32
[Submit] Items inserted: 1
[Submit] ========== Starting attachments upload ==========
[Upload] ========== Starting upload ==========
[Upload] File: file.pdf
[Upload] Size: 123.45 KB
[Upload] Storage path: form/form-32/item-12/1234567890-abc123-file.pdf
[Upload] ✅ File uploaded to storage successfully
[Upload] ✅ Public URL: https://...
[Upload] ✅ Attachment metadata saved to database successfully
[Submit] ✅ Attachment uploaded successfully for item 12
[Submit] Successfully uploaded: 1
```

## إذا استمرت المشكلة

1. افتح Console (F12) وانسخ جميع الرسائل
2. تحقق من:
   - هل الـ bucket موجود؟
   - هل الجدول موجود؟
   - هل الصلاحيات صحيحة؟
3. أرسل رسائل Console للمساعدة في التشخيص
