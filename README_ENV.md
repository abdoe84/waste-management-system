# Configuration Files

## ملفات الإعدادات

### ملف `.env` (للتوثيق فقط)
ملف `.env` تم إنشاؤه لحفظ الإعدادات، لكن **لا يمكن استخدامه مباشرة في المتصفح**.

### ملف `config.js` (الملف الفعلي المستخدم)
يستخدم المشروع ملف `config.js` لحفظ إعدادات Supabase.

## كيفية تحديث الإعدادات:

1. افتح ملف `config.js`
2. غيّر القيم حسب الحاجة:
   ```javascript
   const CONFIG = {
       SUPABASE_URL: 'your_supabase_url',
       SUPABASE_ANON_KEY: 'your_supabase_key',
       PROJECT_NAME: 'Reviva MS Form',
       PROJECT_VERSION: '1.0.0'
   };
   ```

## ملاحظات:
- ملف `.env` موجود للتوثيق فقط
- ملف `config.js` هو الذي يتم استخدامه في الكود
- جميع الصفحات تستخدم `config.js` تلقائياً
