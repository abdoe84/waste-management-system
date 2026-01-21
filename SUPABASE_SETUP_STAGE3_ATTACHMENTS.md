# إعداد مرفقات Stage 3 في Supabase

## الخطوات المطلوبة في منصة Supabase

### 1. إنشاء Storage Bucket (إن لم يكن موجوداً)

1. اذهب إلى **Storage** في القائمة الجانبية في Supabase Dashboard
2. إذا كان bucket `ms_attachments` غير موجود:
   - اضغط على **"New bucket"**
   - الاسم: `ms_attachments`
   - اختر **Public bucket** (لتمكين الوصول العام للملفات)
   - اضغط **"Create bucket"**

### 2. إنشاء جدول قاعدة البيانات

1. اذهب إلى **SQL Editor** في Supabase Dashboard
2. انسخ والصق محتوى الملف `setup_stage3_attachments.sql`
3. اضغط **"Run"** لتنفيذ الكود

هذا سينشئ:
- جدول `ms_stage3_attachments` لحفظ معلومات المرفقات
- الفهارس (Indexes) لتحسين الأداء
- سياسات Row Level Security (RLS)
- الصلاحيات المطلوبة

### 3. التحقق من الصلاحيات

تأكد من أن:
- ✅ Bucket `ms_attachments` موجود و **Public**
- ✅ جدول `ms_stage3_attachments` تم إنشاؤه
- ✅ السياسات (Policies) مفعلة وتسمح بـ:
  - INSERT (إدراج)
  - SELECT (قراءة)
  - UPDATE (تحديث)
  - DELETE (حذف)

### 4. اختبار النظام

1. سجل دخول كـ **Technical** user
2. اذهب إلى صفحة **Review Requests**
3. اختر طلباً بـ **Approved** status
4. اضغط **"Fill Stage 3 Data"**
5. املأ البيانات وارفع المرفقات
6. تأكد من أن المرفقات تظهر:
   - ✅ في صفحة **Manager Review** عند عرض تفاصيل الطلب
   - ✅ في صفحة **My Requests** للمستخدم بعد اعتماد المدير

## ملاحظات مهمة

- الملفات تُرفع إلى: `ms_attachments/stage3/form-{formId}/item-{itemId}/`
- كل ملف له رابط عام (Public URL) يمكن الوصول إليه
- معلومات المرفقات تُحفظ في جدول `ms_stage3_attachments`

## في حال وجود مشاكل

### خطأ "Bucket not found"
- تأكد من أن bucket `ms_attachments` موجود في Storage
- تأكد من أن الاسم صحيح تماماً

### خطأ "Permission denied"
- تأكد من أن bucket **Public**
- تحقق من سياسات RLS في جدول `ms_stage3_attachments`
- تأكد من تنفيذ جميع الأوامر في `setup_stage3_attachments.sql`

### المرفقات لا تظهر
- تحقق من Console في المتصفح للأخطاء
- تأكد من أن الملفات تم رفعها بنجاح في Storage
- تحقق من أن البيانات تم حفظها في جدول `ms_stage3_attachments`