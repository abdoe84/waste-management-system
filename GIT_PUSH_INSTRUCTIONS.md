# تعليمات حل مشكلة Git Push

## المشكلة
```
! [rejected]        main -> main (fetch first)
error: failed to push some refs
```

هذا يعني أن GitHub يحتوي على تغييرات ليست موجودة محلياً.

## الحل (الطريقة الآمنة - الموصى بها)

### الخطوة 1: سحب التغييرات من GitHub
```bash
git pull origin main --rebase
```

إذا ظهرت رسالة "Already up to date"، انتقل للخطوة 2.

### الخطوة 2: إذا ظهرت تعارضات (conflicts)
1. افتح الملفات التي تحتوي على تعارضات
2. حل التعارضات يدوياً
3. بعد حل التعارضات:
```bash
git add .
git rebase --continue
```

### الخطوة 3: دفع التغييرات
```bash
git push origin main
```

---

## الحل البديل (إذا لم تكن هناك تغييرات مهمة على GitHub)

إذا كنت متأكداً أن التغييرات على GitHub ليست مهمة وتريد استبدالها:

```bash
# سحب التغييرات مع دمج
git pull origin main

# إذا ظهرت تعارضات، حلّها ثم:
git add .
git commit -m "Merge remote changes"
git push origin main
```

---

## الحل السريع (إذا كنت متأكداً 100%)

⚠️ **تحذير:** هذا سيستبدل جميع الملفات على GitHub بملفاتك المحلية

```bash
git pull origin main --allow-unrelated-histories
git push origin main --force
```

**لا تستخدم `--force` إلا إذا كنت متأكداً تماماً!**

---

## الخطوات الموصى بها (خطوة بخطوة)

1. **افتح Terminal/Git Bash في مجلد المشروع**

2. **تحقق من حالة Git:**
```bash
git status
```

3. **سحب التغييرات:**
```bash
git pull origin main --rebase
```

4. **إذا نجح السحب بدون تعارضات:**
```bash
git push origin main
```

5. **إذا ظهرت تعارضات:**
   - افتح الملفات المذكورة
   - ابحث عن `<<<<<<<` و `>>>>>>>` و `=======`
   - اختر الكود الصحيح واحذف العلامات
   - احفظ الملفات
   - ثم:
```bash
git add .
git rebase --continue
git push origin main
```

---

## ملاحظات

- ✅ استخدم `--rebase` للحفاظ على تاريخ Git نظيف
- ✅ احتفظ بنسخة احتياطية قبل أي عملية
- ⚠️ لا تستخدم `--force` إلا في حالات خاصة
