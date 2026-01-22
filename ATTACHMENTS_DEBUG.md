# دليل تصحيح مشكلة المرفقات

## المشكلة
المرفقات من الفورم لا تُخزن في قاعدة البيانات أو Storage.

## خطوات التحقق

### 1. التحقق من Console في المتصفح
1. افتح صفحة `request-form.html`
2. اضغط F12 لفتح Developer Tools
3. اذهب إلى تبويب Console
4. املأ الفورم وأضف عنصر مع مرفق
5. أرسل الفورم
6. ابحث عن الرسائل التي تبدأ بـ `[Submit]` و `[Upload]`

### 2. التحقق من وجود Bucket
- تأكد من وجود bucket باسم `ms_attachments` في Supabase Storage
- تأكد من أن Bucket هو PUBLIC
- تأكد من وجود Policies للسماح بالرفع

### 3. التحقق من وجود الجدول
- اذهب إلى Supabase Dashboard > SQL Editor
- شغّل الاستعلام التالي:
```sql
SELECT * FROM ms_form_attachments ORDER BY created_at DESC LIMIT 10;
```

إذا ظهر خطأ "relation does not exist"، شغّل ملف `setup_form_attachments.sql`

### 4. التحقق من Storage Policies
في Supabase Dashboard > Storage > Policies:
- تأكد من وجود Policy للسماح بـ INSERT
- تأكد من وجود Policy للسماح بـ SELECT

### 5. رسائل الخطأ الشائعة

#### "Bucket not found"
- الحل: أنشئ bucket باسم `ms_attachments` في Supabase Storage

#### "Table does not exist"
- الحل: شغّل `setup_form_attachments.sql` في SQL Editor

#### "Permission denied"
- الحل: تحقق من Storage Policies و RLS Policies

#### "File not found in state"
- الحل: تأكد من اختيار الملف قبل إضافة العنصر

## اختبار سريع

1. افتح `request-form.html`
2. املأ البيانات الأساسية
3. أضف عنصر واحد مع مرفق (اختر ملف)
4. تأكد من ظهور الملف في قائمة العناصر
5. أرسل الفورم
6. افتح Console وابحث عن:
   - `[Submit] Total items: 1`
   - `[Submit] Item 1: hasDocument: true`
   - `[Upload] Uploading file: ...`
   - `[Upload] ✅ Attachment saved to database`

إذا لم تظهر هذه الرسائل، تحقق من:
- هل الملف تم اختياره؟
- هل العنصر تم إضافته قبل الإرسال؟
- هل هناك أخطاء في Console؟
