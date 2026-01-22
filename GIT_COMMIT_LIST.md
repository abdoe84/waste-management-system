# قائمة الملفات للنقل إلى GitHub

## الملفات الجديدة (يجب إضافتها)

### ملفات SQL لإعداد قاعدة البيانات:
1. **setup_form_attachments.sql** - إعداد جدول مرفقات الفورم الأساسي
2. **fix_form_attachments.sql** - إصلاح جدول مرفقات الفورم (إضافة الأعمدة المفقودة)
3. **setup_notifications.sql** - إعداد جدول الإشعارات والـ Triggers
4. **fix_notifications_permissions.sql** - إصلاح صلاحيات جدول الإشعارات

### ملفات التوثيق:
5. **ATTACHMENTS_DEBUG.md** - دليل تصحيح مشاكل المرفقات
6. **ATTACHMENTS_TROUBLESHOOTING.md** - دليل حل مشاكل المرفقات
7. **NOTIFICATIONS_SETUP.md** - دليل إعداد نظام الإشعارات (إن وجد)

## الملفات المعدلة (يجب تحديثها)

### صفحات HTML:
1. **dashboard.html**
   - إضافة نظام الإشعارات الكامل
   - استبدال شارت "Requests by Status" بشارت "Waste Types"
   - إضافة زر Dashboard في Header
   - تحسين عرض المرفقات

2. **request-form.html**
   - إضافة وظيفة رفع المرفقات وحفظها في قاعدة البيانات
   - إضافة زر Dashboard
   - تحسين معالجة الأخطاء

3. **review.html**
   - إضافة عرض المرفقات لكل عنصر
   - إضافة زر Dashboard
   - إزالة زر "Back to Form"

4. **stage3.html**
   - تحسين زر Dashboard
   - إزالة زر "Back to Reviews"

5. **my-requests.html**
   - تحسين زر Dashboard

6. **manager-review.html**
   - تحسين زر Dashboard

7. **user-management.html**
   - إضافة زر Dashboard

## ملخص التغييرات الرئيسية

### 1. نظام المرفقات
- ✅ رفع الملفات إلى Supabase Storage
- ✅ حفظ معلومات الملفات في قاعدة البيانات
- ✅ عرض المرفقات في صفحات المراجعة
- ✅ تنظيم الملفات في مجلدات منفصلة (form/ و stage3/)

### 2. نظام الإشعارات
- ✅ جدول الإشعارات في قاعدة البيانات
- ✅ Triggers تلقائية لإنشاء الإشعارات
- ✅ واجهة عرض الإشعارات في Dashboard
- ✅ تحديث تلقائي كل 30 ثانية

### 3. تحسينات الواجهة
- ✅ إضافة أزرار Dashboard في جميع الصفحات
- ✅ استبدال شارت Status بشارت Waste Types
- ✅ تحسين عرض المرفقات

## أوامر Git المقترحة

```bash
# إضافة الملفات الجديدة
git add setup_form_attachments.sql
git add fix_form_attachments.sql
git add setup_notifications.sql
git add fix_notifications_permissions.sql
git add ATTACHMENTS_DEBUG.md
git add ATTACHMENTS_TROUBLESHOOTING.md
git add GIT_COMMIT_LIST.md

# تحديث الملفات المعدلة
git add dashboard.html
git add request-form.html
git add review.html
git add stage3.html
git add my-requests.html
git add manager-review.html
git add user-management.html

# Commit
git commit -m "Add attachments system, notifications system, and UI improvements

- Add form attachments upload and storage functionality
- Add notifications system with automatic triggers
- Replace status chart with waste types chart
- Add Dashboard navigation buttons to all pages
- Improve attachments display in review pages
- Add SQL setup files for attachments and notifications"

# Push
git push origin main
```

## ملاحظات مهمة

⚠️ **لا تنقل:**
- `config.js` - يحتوي على مفاتيح API الحساسة
- `.gitignore` - يجب أن يكون موجوداً بالفعل

✅ **تأكد من:**
- أن جميع ملفات SQL جاهزة للاستخدام
- أن ملفات التوثيق محدثة
- أن جميع الصفحات تعمل بشكل صحيح
