# كيفية تحديث الملفات على GitHub

## السيناريو 1: المشروع موجود على GitHub وتريد تحديثه

### الخطوات:

1. **افتح Terminal/Command Prompt في مجلد المشروع**

2. **تحقق من حالة Git:**
```bash
git status
```

3. **أضف جميع الملفات الجديدة والمحدثة:**
```bash
git add .
```

4. **احفظ التغييرات (Commit):**
```bash
git commit -m "Update: Add index.html and improve project structure"
```

5. **ارفع التغييرات إلى GitHub:**
```bash
git push origin main
```

**إذا ظهرت رسالة خطأ "branch diverged" أو مشاكل أخرى:**

```bash
# سحب التغييرات من GitHub أولاً
git pull origin main --rebase

# إذا كان هناك تعارضات، حلّها ثم:
git add .
git commit -m "Update project files"
git push origin main
```

## السيناريو 2: استبدال كامل للمشروع (إذا كنت تريد حذف القديم وإضافة الجديد)

### ⚠️ تحذير: هذه الطريقة تحذف كل الملفات القديمة وتستبدلها بالجديدة

```bash
# إزالة جميع الملفات من Git (لكن لا تحذفها من جهازك)
git rm -r --cached .

# إضافة جميع الملفات الجديدة
git add .

# حفظ التغييرات
git commit -m "Complete project update"

# رفع التغييرات
git push origin main --force
```

## السيناريو 3: نسخ المجلد بالكامل (إذا كان لديك نسخة قديمة في مكان آخر)

### الطريقة الآمنة:

1. **احتفظ بنسخة احتياطية من المجلد القديم**

2. **انسخ جميع الملفات الجديدة إلى المجلد القديم:**
   - انسخ جميع الملفات من المجلد الجديد
   - الصقها في المجلد القديم (استبدل الملفات القديمة)

3. **بعد الاستبدال، اذهب إلى المجلد في Terminal:**
```bash
cd path/to/your/project
git add .
git commit -m "Replace old files with new version"
git push origin main
```

## السيناريو 4: إنشاء مستودع جديد على GitHub

إذا كنت تريد بدء مشروع جديد:

```bash
# في مجلد المشروع
git init
git add .
git commit -m "Initial commit: Complete Waste Management System"

# أنشئ مستودع جديد على GitHub ثم:
git remote add origin https://github.com/yourusername/your-repo-name.git
git branch -M main
git push -u origin main
```

## ملاحظات مهمة:

- ✅ **احتفظ بنسخة احتياطية** قبل أي عملية استبدال
- ✅ **تأكد من تحديث `config.js`** بمفاتيح Supabase الخاصة بك
- ✅ **راجع `.gitignore`** للتأكد من عدم رفع ملفات حساسة
- ⚠️ **لا تستخدم `--force`** إلا إذا كنت متأكداً تماماً
