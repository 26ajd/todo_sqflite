# Project — todo_sqflite

**ملخص المشروع**
---
- اسم المشروع: todo_sqflite
- وصف مبسّط: تطبيق مهام (To‑Do) مبني بـ Flutter يستخدم SQLite (package: sqflite) لتخزين المهام محليًا. يدعم التطبيق إنشاء مهام مع عنوان، وصف، تاريخ استحقاق، أولوية، وفئة (category). يمكن إضافة فئات جديدة من واجهة إضافة المهمة، وتستخدم الفئات في فلترة القائمة الرئيسية.
---
هيكل المشروع (مُلخّص)

- lib/
  - main.dart — نقطة الدخول للتطبيق.
  - controllers/
    - task_controller.dart — منطق الأعمال (GetX) لإدارة المهام والفلاتر وقائمة الفئات.
  - db/
    - db_helper.dart — طبقة الوصول إلى البيانات (SQLite) — إنشاء الجداول الأساسية (`tasks`) ودعم جدول `categories`.
  - models/
    - task_model.dart — نموذج بيانات الـ Task وتحويله إلى/من JSON.
  - views/
    - home_screen.dart — الشاشة الرئيسية: قائمة المهام، شريط البحث، شريط الفلاتر، زر إضافة مهمة.
    - add_task_screen.dart — شاشة إضافة/تعديل مهمة، تتضمن اختيار/إضافة فئة جديدة.
    - task_detail_screen.dart — تفاصيل مهمة.
  - widgets/
    - input_field.dart — مكوّن إدخال مستخدم مخصص.
    - task_tile.dart — واجهة عرض صف المهمة في القائمة.
  - utils/
    - theme.dart — ألوان وأنماط الواجهات.


مهام وميزات أساسية

- تخزين المهام محليًا في SQLite.
- فلترة المهام حسب الفئة والأولوية.
- إضافة فئات جديدة من شاشة إضافة المهمة. الفئات تُخزّن في جدول `categories` في قاعدة البيانات.
- التصميم يستخدم GetX لإدارة الحالة والملاحة والسماحات السريعة (snackbars, dialogs).

قواعد البيانات

- ملف DB: `tasks.db` مخزّن في مجلد قواعد بيانات Flutter الافتراضي.
- الجداول:
  - `tasks`:
    - id INTEGER PRIMARY KEY AUTOINCREMENT
    - title TEXT
    - description TEXT
    - priority TEXT
    - dueDate TEXT
    - isCompleted INTEGER
    - category TEXT
    - createdAt TEXT
  - `categories`:
    - id INTEGER PRIMARY KEY AUTOINCREMENT
    - name TEXT UNIQUE


تشغيل المشروع محليًا

1. تثبيت الحزم:

```powershell
flutter pub get
```

2. تشغيل التطبيق على جهاز متصل أو محاكي:

```powershell
flutter run
```

### الصور
### 1
![1](screens/photo_1_2025-12-09_05-50-02.jpg)

### 2
![2](screens/photo_2_2025-12-09_05-50-02.jpg)

### 3
![4](screens/photo_3_2025-12-09_05-50-02.jpg)

