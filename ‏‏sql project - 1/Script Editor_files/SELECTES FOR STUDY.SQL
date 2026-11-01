-- ══════════════════════════════════════════════════════════════
-- CLOUD IAM SYSTEM - COMPLETE OPERATIONS MANUAL
-- دليل العمليات الشامل على قاعدة البيانات
-- Author: Mohammed Al-Hattami
-- ══════════════════════════════════════════════════════════════
-- هذا الملف يحتوي على كل الأوامر التي تحتاجها للعمل على قاعدة البيانات
-- يشمل: العرض، الإضافة، التعديل، الحذف، التقارير، والتحقق
-- ══════════════════════════════════════════════════════════════

-- ╔════════════════════════════════════════════════════════════╗
-- ║          القسم 1: أوامر العرض (SELECT)                    ║
-- ║          الاستخدام: لرؤية البيانات الموجودة                ║
-- ╚════════════════════════════════════════════════════════════╝

-- ──────────────────────────────────────────────────────────────
-- 1.1: عرض جميع المستخدمين
-- ──────────────────────────────────────────────────────────────
-- الاستخدام: لرؤية قائمة كل المستخدمين في النظام
-- مثال: "أريد أعرف كم مستخدم عندي ومن هم"
-- ──────────────────────────────────────────────────────────────
SELECT user_id, username, email, full_name, is_active, created_at
FROM "User"
ORDER BY user_id;

-- ──────────────────────────────────────────────────────────────
-- 1.2: عرض كلمات المرور المشفرة (إثبات التشفير)
-- ──────────────────────────────────────────────────────────────
-- الاستخدام: للتأكد أن كلمات المرور مشفرة وليست نصاً صريحاً
-- مثال: "أريد أثبت للدكتورة أن التشفير شغال"
-- ──────────────────────────────────────────────────────────────
SELECT username, password_hash, salt
FROM "User"
ORDER BY username;

-- ──────────────────────────────────────────────────────────────
-- 1.3: عرض المستخدمين النشطين فقط
-- ──────────────────────────────────────────────────────────────
-- الاستخدام: لفلترة المستخدمين المفعّلين
-- مثال: "أريد أشوف المستخدمين اللي يقدرون يدخلون النظام"
-- ──────────────────────────────────────────────────────────────
SELECT user_id, username, full_name, last_login
FROM "User"
WHERE is_active = 'Y';

-- ──────────────────────────────────────────────────────────────
-- 1.4: عرض جميع الأدوار
-- ──────────────────────────────────────────────────────────────
-- الاستخدام: لرؤية الأدوار المتاحة في النظام
-- مثال: "أريد أعرف كم دور عندي"
-- ──────────────────────────────────────────────────────────────
SELECT role_id, role_name, description, created_at
FROM ROLES
ORDER BY role_id;

-- ──────────────────────────────────────────────────────────────
-- 1.5: عرض جميع الصلاحيات
-- ──────────────────────────────────────────────────────────────
-- الاستخدام: لرؤية الصلاحيات المتاحة
-- مثال: "أريد أعرف كل الصلاحيات اللي في النظام"
-- ──────────────────────────────────────────────────────────────
SELECT permission_id, permission_code, description, resource_name, action
FROM PERMISSIONS
ORDER BY permission_id;

-- ──────────────────────────────────────────────────────────────
-- 1.6: عرض كل مستخدم مع أدواره
-- ──────────────────────────────────────────────────────────────
-- الاستخدام: لمعرفة من عنده أي دور
-- مثال: "أريد أعرف من هم المدراء في النظام"
-- ──────────────────────────────────────────────────────────────
SELECT 
    u.username,
    u.full_name,
    r.role_name,
    ur.assigned_at,
    (SELECT username FROM "User" WHERE user_id = ur.assigned_by) AS assigned_by_user
FROM "User" u
JOIN USER_ROLES ur ON u.user_id = ur.user_id
JOIN ROLES r ON ur.role_id = r.role_id
ORDER BY u.username, r.role_name;

-- ──────────────────────────────────────────────────────────────
-- 1.7: عرض كل دور مع صلاحياته
-- ──────────────────────────────────────────────────────────────
-- الاستخدام: لمعرفة ما يستطيع كل دور فعله
-- مثال: "أريد أعرف صلاحيات دور ADMIN"
-- ──────────────────────────────────────────────────────────────
SELECT 
    r.role_name,
    p.permission_code,
    p.resource_name,
    p.action
FROM ROLES r
JOIN ROLE_PERMISSIONS rp ON r.role_id = rp.role_id
JOIN PERMISSIONS p ON rp.permission_id = p.permission_id
WHERE r.role_name = 'ADMIN'
ORDER BY p.permission_code;

-- ──────────────────────────────────────────────────────────────
-- 1.8: عرض سجل الدخول (آخر 30 حدث)
-- ──────────────────────────────────────────────────────────────
-- الاستخدام: لمراجعة الأحداث الأمنية الأخيرة
-- مثال: "أريد أشوف آخر محاولات الدخول"
-- ──────────────────────────────────────────────────────────────
SELECT 
    a.log_id,
    u.username,
    a.action,
    a.status,
    a.ip_address,
    a.log_time,
    a.details
FROM ACCESS_LOGS a
LEFT JOIN "User" u ON a.user_id = u.user_id
ORDER BY a.log_time DESC
FETCH FIRST 30 ROWS ONLY;

-- ──────────────────────────────────────────────────────────────
-- 1.9: عرض الجلسات النشطة حالياً
-- ──────────────────────────────────────────────────────────────
-- الاستخدام: لمعرفة من هو متصل الآن
-- مثال: "أريد أعرف من المتصل حالياً بالنظام"
-- ──────────────────────────────────────────────────────────────
SELECT 
    s.session_id,
    u.username,
    u.full_name,
    s.ip_address,
    s.login_time,
    ROUND((SYSDATE - s.login_time) * 24, 2) AS hours_online
FROM SESSIONS s
JOIN "User" u ON s.user_id = u.user_id
WHERE s.is_active = 'Y'
ORDER BY s.login_time DESC;

-- ──────────────────────────────────────────────────────────────
-- 1.10: عرض السياسات الأمنية
-- ──────────────────────────────────────────────────────────────
-- الاستخدام: لرؤية القواعد الأمنية المطبقة
-- مثال: "أريد أعرف إيش السياسات الأمنية عندي"
-- ──────────────────────────────────────────────────────────────
SELECT policy_id, policy_name, condition_type, condition_value, is_active
FROM POLICIES
ORDER BY policy_id;

-- ──────────────────────────────────────────────────────────────
-- 1.11: عرض سجل التدقيق
-- ──────────────────────────────────────────────────────────────
-- الاستخدام: لمعرفة من عدّل ماذا ومتى
-- مثال: "أريد أعرف من عدّل في جدول المستخدمين"
-- ──────────────────────────────────────────────────────────────
SELECT 
    at.audit_id,
    u.username,
    at.table_name,
    at.action,
    at.new_value,
    at.changed_at,
    at.ip_address
FROM AUDIT_TRAIL at
LEFT JOIN "User" u ON at.user_id = u.user_id
ORDER BY at.changed_at DESC;

-- ──────────────────────────────────────────────────────────────
-- 1.12: عرض رموز MFA
-- ──────────────────────────────────────────────────────────────
-- الاستخدام: لرؤية رموز التحقق بخطوتين
-- مثال: "أريد أشوف رموز MFA للمستخدمين"
-- ──────────────────────────────────────────────────────────────
SELECT 
    m.token_id,
    u.username,
    m.token_code,
    m.expires_at,
    m.is_used
FROM MFA_TOKENS m
JOIN "User" u ON m.user_id = u.user_id
ORDER BY m.created_at DESC;

-- ╔════════════════════════════════════════════════════════════╗
-- ║       القسم 2: أوامر الإضافة (INSERT)                     ║
-- ║       الاستخدام: لإضافة بيانات جديدة                       ║
-- ╚════════════════════════════════════════════════════════════╝

-- ──────────────────────────────────────────────────────────────
-- 2.1: إضافة مستخدم جديد
-- ──────────────────────────────────────────────────────────────
-- الاستخدام: لإنشاء حساب مستخدم جديد
-- ملاحظة: الـ Trigger سيشفّر كلمة المرور تلقائياً
-- مثال: "أريد أضيف مستخدم جديد اسمه khalid"
-- ──────────────────────────────────────────────────────────────
INSERT INTO "User" (username, email, password_hash, full_name, is_active)
VALUES ('khalid', 'khalid@iam.com', 'khalid123', 'Khalid Al-Yemeni', 'Y');
COMMIT;

-- للتحقق:
SELECT user_id, username, password_hash FROM "User" WHERE username = 'khalid';

-- ──────────────────────────────────────────────────────────────
-- 2.2: إضافة دور جديد
-- ──────────────────────────────────────────────────────────────
-- الاستخدام: لإنشاء دور جديد في النظام
-- مثال: "أريد أضيف دور جديد اسمه SUPPORT"
-- ──────────────────────────────────────────────────────────────
INSERT INTO ROLES (role_name, description) 
VALUES ('SUPPORT', 'Technical support team');
COMMIT;

-- ──────────────────────────────────────────────────────────────
-- 2.3: إضافة صلاحية جديدة
-- ──────────────────────────────────────────────────────────────
-- الاستخدام: لإضافة صلاحية جديدة
-- مثال: "أريد أضيف صلاحية تصدير التقارير"
-- ──────────────────────────────────────────────────────────────
INSERT INTO PERMISSIONS (permission_code, description, resource_name, action)
VALUES ('REPORT_EXPORT', 'Export security reports', 'Reports', 'READ');
COMMIT;

-- ──────────────────────────────────────────────────────────────
-- 2.4: إسناد دور لمستخدم
-- ──────────────────────────────────────────────────────────────
-- الاستخدام: لإعطاء مستخدم دور معين
-- مثال: "أريد أعطي khalid دور VIEWER"
-- ──────────────────────────────────────────────────────────────
INSERT INTO USER_ROLES (user_id, role_id, assigned_by)
VALUES (
    (SELECT user_id FROM "User" WHERE username = 'khalid'),
    (SELECT role_id FROM ROLES WHERE role_name = 'VIEWER'),
    (SELECT user_id FROM "User" WHERE username = 'admin')
);
COMMIT;

-- ──────────────────────────────────────────────────────────────
-- 2.5: ربط صلاحية بدور
-- ──────────────────────────────────────────────────────────────
-- الاستخدام: لإعطاء دور معين صلاحية معينة
-- مثال: "أريد أعطي دور MANAGER صلاحية تصدير التقارير"
-- ──────────────────────────────────────────────────────────────
INSERT INTO ROLE_PERMISSIONS (role_id, permission_id)
VALUES (
    (SELECT role_id FROM ROLES WHERE role_name = 'MANAGER'),
    (SELECT permission_id FROM PERMISSIONS WHERE permission_code = 'REPORT_EXPORT')
);
COMMIT;

-- ──────────────────────────────────────────────────────────────
-- 2.6: إضافة سياسة أمنية
-- ──────────────────────────────────────────────────────────────
-- الاستخدام: لإضافة قاعدة أمنية جديدة
-- مثال: "أريد أضيف سياسة تمنع الدخول من خارج اليمن"
-- ──────────────────────────────────────────────────────────────
INSERT INTO POLICIES (policy_name, condition_type, condition_value, is_active)
VALUES ('Block Non-Yemen IPs', 'GEO_BLOCK', 'Non-Yemen', 'Y');
COMMIT;

-- ──────────────────────────────────────────────────────────────
-- 2.7: تسجيل حدث في ACCESS_LOGS
-- ──────────────────────────────────────────────────────────────
-- الاستخدام: لتسجيل محاولة دخول يدوياً
-- مثال: "أريد أسجل محاولة دخول ناجحة لـ admin"
-- ──────────────────────────────────────────────────────────────
INSERT INTO ACCESS_LOGS (user_id, action, status, ip_address, user_agent, details)
VALUES (
    (SELECT user_id FROM "User" WHERE username = 'admin'),
    'LOGIN',
    'SUCCESS',
    '192.168.1.100',
    'Chrome/120.0',
    'Manual test login'
);
COMMIT;

-- ╔════════════════════════════════════════════════════════════╗
-- ║       القسم 3: أوامر التعديل (UPDATE)                     ║
-- ║       الاستخدام: لتعديل البيانات الموجودة                  ║
-- ╚════════════════════════════════════════════════════════════╝

-- ──────────────────────────────────────────────────────────────
-- 3.1: تعديل اسم مستخدم
-- ──────────────────────────────────────────────────────────────
-- الاستخدام: لتغيير الاسم الكامل لمستخدم
-- مثال: "أريد أغيّر اسم khalid"
-- ──────────────────────────────────────────────────────────────
UPDATE "User"
SET full_name = 'Khalid Mohammed Al-Yemeni'
WHERE username = 'khalid';
COMMIT;

-- ──────────────────────────────────────────────────────────────
-- 3.2: تعطيل مستخدم
-- ──────────────────────────────────────────────────────────────
-- الاستخدام: لمنع مستخدم من الدخول
-- مثال: "أريد أعطّل حساب khalid"
-- ──────────────────────────────────────────────────────────────
UPDATE "User"
SET is_active = 'N'
WHERE username = 'khalid';
COMMIT;

-- ──────────────────────────────────────────────────────────────
-- 3.3: تفعيل مستخدم
-- ──────────────────────────────────────────────────────────────
-- الاستخدام: لإعادة تفعيل حساب معطّل
-- ──────────────────────────────────────────────────────────────
UPDATE "User"
SET is_active = 'Y'
WHERE username = 'khalid';
COMMIT;

-- ──────────────────────────────────────────────────────────────
-- 3.4: تغيير كلمة مرور مستخدم
-- ──────────────────────────────────────────────────────────────
-- الاستخدام: لتغيير كلمة مرور مستخدم
-- ملاحظة: ضع كلمة المرور الجديدة فقط، الـ Trigger سيشفّرها
-- ──────────────────────────────────────────────────────────────
UPDATE "User"
SET password_hash = 'newpassword123'
WHERE username = 'khalid';
COMMIT;

-- للتحقق من التشفير الجديد:
SELECT username, password_hash FROM "User" WHERE username = 'khalid';

-- ──────────────────────────────────────────────────────────────
-- 3.5: تعديل وصف دور
-- ──────────────────────────────────────────────────────────────
-- الاستخدام: لتحديث وصف دور موجود
-- ──────────────────────────────────────────────────────────────
UPDATE ROLES
SET description = 'Updated description for viewer role'
WHERE role_name = 'VIEWER';
COMMIT;

-- ──────────────────────────────────────────────────────────────
-- 3.6: تعديل سياسة أمنية (تفعيل/تعطيل)
-- ──────────────────────────────────────────────────────────────
-- الاستخدام: لتفعيل أو تعطيل سياسة
-- ──────────────────────────────────────────────────────────────
UPDATE POLICIES
SET is_active = 'N'
WHERE policy_name = 'Block Foreign IPs';
COMMIT;

-- ──────────────────────────────────────────────────────────────
-- 3.7: إنهاء جلسة نشطة
-- ──────────────────────────────────────────────────────────────
-- الاستخدام: لإنهاء جلسة مستخدم قسرياً
-- مثال: "أريد أقطع جلسة admin"
-- ──────────────────────────────────────────────────────────────
UPDATE SESSIONS
SET is_active = 'N', logout_time = SYSDATE
WHERE user_id = (SELECT user_id FROM "User" WHERE username = 'admin')
  AND is_active = 'Y';
COMMIT;

-- ──────────────────────────────────────────────────────────────
-- 3.8: تعليم رمز MFA كمستخدم
-- ──────────────────────────────────────────────────────────────
-- الاستخدام: لتعليم رمز OTP أنه تم استخدامه
-- ──────────────────────────────────────────────────────────────
UPDATE MFA_TOKENS
SET is_used = 'Y'
WHERE token_id = 1;
COMMIT;

-- ╔════════════════════════════════════════════════════════════╗
-- ║       القسم 4: أوامر الحذف (DELETE)                       ║
-- ║       الاستخدام: لحذف بيانات                                 ║
-- ║       ⚠️ تحذير: الحذف نهائي، تأكد قبل التنفيذ              ║
-- ╚════════════════════════════════════════════════════════════╝

-- ──────────────────────────────────────────────────────────────
-- 4.1: حذف دور من مستخدم
-- ──────────────────────────────────────────────────────────────
-- الاستخدام: لسحب دور من مستخدم
-- مثال: "أريد أشيل دور VIEWER من khalid"
-- ──────────────────────────────────────────────────────────────
DELETE FROM USER_ROLES
WHERE user_id = (SELECT user_id FROM "User" WHERE username = 'khalid')
  AND role_id = (SELECT role_id FROM ROLES WHERE role_name = 'VIEWER');
COMMIT;

-- ──────────────────────────────────────────────────────────────
-- 4.2: حذف صلاحية من دور
-- ──────────────────────────────────────────────────────────────
-- الاستخدام: لسحب صلاحية من دور
-- ──────────────────────────────────────────────────────────────
DELETE FROM ROLE_PERMISSIONS
WHERE role_id = (SELECT role_id FROM ROLES WHERE role_name = 'MANAGER')
  AND permission_id = (SELECT permission_id FROM PERMISSIONS WHERE permission_code = 'REPORT_EXPORT');
COMMIT;

-- ──────────────────────────────────────────────────────────────
-- 4.3: حذف سياسة أمنية
-- ──────────────────────────────────────────────────────────────
-- الاستخدام: لحذف سياسة نهائياً
-- ──────────────────────────────────────────────────────────────
DELETE FROM POLICIES
WHERE policy_name = 'Block Foreign IPs';
COMMIT;

-- ──────────────────────────────────────────────────────────────
-- 4.4: حذف سجلات دخول قديمة
-- ──────────────────────────────────────────────────────────────
-- الاستخدام: لتنظيف السجلات القديمة (أكثر من 30 يوم)
-- ──────────────────────────────────────────────────────────────
DELETE FROM ACCESS_LOGS
WHERE log_time < SYSDATE - 30;
COMMIT;

-- ──────────────────────────────────────────────────────────────
-- 4.5: حذف مستخدم (⚠️ حذر)
-- ──────────────────────────────────────────────────────────────
-- الاستخدام: لحذف مستخدم نهائياً (نادراً ما يُستخدم)
-- ملاحظة: يجب حذف أدواره أولاً
-- ──────────────────────────────────────────────────────────────
-- الخطوة 1: احذف أدواره
DELETE FROM USER_ROLES 
WHERE user_id = (SELECT user_id FROM "User" WHERE username = 'khalid');
COMMIT;

-- الخطوة 2: احذف المستخدم
DELETE FROM "User" WHERE username = 'khalid';
COMMIT;

-- ╔════════════════════════════════════════════════════════════╗
-- ║       القسم 5: تقارير أمنية جاهزة                          ║
-- ║       الاستخدام: للتحليل والمراجعة                          ║
-- ╚════════════════════════════════════════════════════════════╝

-- ──────────────────────────────────────────────────────────────
-- 5.1: تقرير النشاط الكامل (V_USER_ACCESS)
-- ──────────────────────────────────────────────────────────────
SELECT * FROM V_USER_ACCESS;

-- ──────────────────────────────────────────────────────────────
-- 5.2: تقرير محاولات الدخول الفاشلة (V_FAILED_LOGINS)
-- ──────────────────────────────────────────────────────────────
SELECT * FROM V_FAILED_LOGINS;

-- ──────────────────────────────────────────────────────────────
-- 5.3: تقرير الجلسات النشطة (V_ACTIVE_SESSIONS)
-- ──────────────────────────────────────────────────────────────
SELECT * FROM V_ACTIVE_SESSIONS;

-- ──────────────────────────────────────────────────────────────
-- 5.4: عدد المستخدمين في كل دور
-- ──────────────────────────────────────────────────────────────
SELECT 
    r.role_name,
    COUNT(ur.user_id) AS total_users
FROM ROLES r
LEFT JOIN USER_ROLES ur ON r.role_id = ur.role_id
GROUP BY r.role_name
ORDER BY total_users DESC;

-- ──────────────────────────────────────────────────────────────
-- 5.5: عدد الصلاحيات لكل دور
-- ──────────────────────────────────────────────────────────────
SELECT 
    r.role_name,
    COUNT(rp.permission_id) AS total_permissions
FROM ROLES r
LEFT JOIN ROLE_PERMISSIONS rp ON r.role_id = rp.role_id
GROUP BY r.role_name
ORDER BY total_permissions DESC;

-- ──────────────────────────────────────────────────────────────
-- 5.6: المستخدمين ذوو الصلاحيات العالية (أكثر من دور)
-- ──────────────────────────────────────────────────────────────
SELECT 
    u.username,
    u.full_name,
    COUNT(ur.role_id) AS total_roles,
    LISTAGG(r.role_name, ', ') WITHIN GROUP (ORDER BY r.role_name) AS roles
FROM "User" u
JOIN USER_ROLES ur ON u.user_id = ur.user_id
JOIN ROLES r ON ur.role_id = r.role_id
GROUP BY u.username, u.full_name
HAVING COUNT(ur.role_id) > 1
ORDER BY total_roles DESC;

-- ──────────────────────────────────────────────────────────────
-- 5.7: تحليل محاولات الدخول لكل مستخدم
-- ──────────────────────────────────────────────────────────────
SELECT 
    u.username,
    COUNT(a.log_id) AS total_attempts,
    SUM(CASE WHEN a.status = 'SUCCESS' THEN 1 ELSE 0 END) AS success_count,
    SUM(CASE WHEN a.status = 'FAILED' THEN 1 ELSE 0 END) AS failed_count
FROM "User" u
LEFT JOIN ACCESS_LOGS a ON u.user_id = a.user_id
WHERE a.action = 'LOGIN'
GROUP BY u.username
ORDER BY failed_count DESC;

-- ──────────────────────────────────────────────────────────────
-- 5.8: كشف الـ IPs المشبوهة
-- ──────────────────────────────────────────────────────────────
SELECT 
    ip_address,
    COUNT(log_id) AS total_events,
    SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) AS failed_count
FROM ACCESS_LOGS
GROUP BY ip_address
HAVING COUNT(log_id) >= 2
ORDER BY failed_count DESC;

-- ──────────────────────────────────────────────────────────────
-- 5.9: المستخدمين اللي ما دخلوا من فترة
-- ──────────────────────────────────────────────────────────────
SELECT 
    username,
    full_name,
    last_login,
    ROUND(SYSDATE - last_login, 0) AS days_since_login
FROM "User"
WHERE last_login IS NOT NULL
  AND SYSDATE - last_login > 30
ORDER BY last_login;

-- ──────────────────────────────────────────────────────────────
-- 5.10: سجل التدقيق لجدول معين
-- ──────────────────────────────────────────────────────────────
SELECT 
    at.audit_id,
    u.username AS changed_by,
    at.action,
    at.old_value,
    at.new_value,
    at.changed_at
FROM AUDIT_TRAIL at
LEFT JOIN "User" u ON at.user_id = u.user_id
WHERE at.table_name = 'User'
ORDER BY at.changed_at DESC;

-- ╔════════════════════════════════════════════════════════════╗
-- ║       القسم 6: أوامر التحقق (Verification)                ║
-- ║       الاستخدام: للتأكد أن كل شي شغال                       ║
-- ╚════════════════════════════════════════════════════════════╝

-- ──────────────────────────────────────────────────────────────
-- 6.1: التحقق من عدد الصفوف في كل جدول
-- ──────────────────────────────────────────────────────────────
SELECT 'Users: ' || COUNT(*) FROM "User"
UNION ALL SELECT 'Roles: ' || COUNT(*) FROM ROLES
UNION ALL SELECT 'Permissions: ' || COUNT(*) FROM PERMISSIONS
UNION ALL SELECT 'User_Roles: ' || COUNT(*) FROM USER_ROLES
UNION ALL SELECT 'Role_Permissions: ' || COUNT(*) FROM ROLE_PERMISSIONS
UNION ALL SELECT 'Policies: ' || COUNT(*) FROM POLICIES
UNION ALL SELECT 'Access_Logs: ' || COUNT(*) FROM ACCESS_LOGS
UNION ALL SELECT 'MFA_Tokens: ' || COUNT(*) FROM MFA_TOKENS
UNION ALL SELECT 'Sessions: ' || COUNT(*) FROM SESSIONS
UNION ALL SELECT 'Audit_Trail: ' || COUNT(*) FROM AUDIT_TRAIL;

-- ──────────────────────────────────────────────────────────────
-- 6.2: التحقق من وجود الجداول العشرة
-- ──────────────────────────────────────────────────────────────
SELECT table_name FROM user_tables
WHERE table_name IN ('User','ROLES','PERMISSIONS','USER_ROLES','ROLE_PERMISSIONS',
                     'POLICIES','ACCESS_LOGS','MFA_TOKENS','SESSIONS','AUDIT_TRAIL')
ORDER BY table_name;

-- ──────────────────────────────────────────────────────────────
-- 6.3: التحقق من وجود الـ Views
-- ──────────────────────────────────────────────────────────────
SELECT view_name FROM user_views
WHERE view_name IN ('V_USER_ACCESS','V_FAILED_LOGINS','V_ACTIVE_SESSIONS')
ORDER BY view_name;

-- ──────────────────────────────────────────────────────────────
-- 6.4: التحقق من وجود الـ Sequences
-- ──────────────────────────────────────────────────────────────
SELECT sequence_name, last_number, increment_by
FROM user_sequences
WHERE sequence_name LIKE 'SEQ_%'
ORDER BY sequence_name;

-- ──────────────────────────────────────────────────────────────
-- 6.5: التحقق من وجود الـ Triggers
-- ──────────────────────────────────────────────────────────────
SELECT trigger_name, status, table_name
FROM user_triggers
WHERE trigger_name IN ('TRG_HASH_PASSWORD','TRG_AUDIT_USER')
ORDER BY trigger_name;

-- ──────────────────────────────────────────────────────────────
-- 6.6: التحقق من التشفير (مهم جداً)
-- ──────────────────────────────────────────────────────────────
SELECT 
    username,
    password_hash,
    LENGTH(password_hash) AS hash_length,
    salt
FROM "User"
ORDER BY username;

-- ──────────────────────────────────────────────────────────────
-- 6.7: اختبار الـ Sequences
-- ──────────────────────────────────────────────────────────────
SELECT seq_users.NEXTVAL AS next_user_id FROM dual;
SELECT seq_roles.NEXTVAL AS next_role_id FROM dual;
SELECT seq_access_logs.NEXTVAL AS next_log_id FROM dual;

-- ──────────────────────────────────────────────────────────────
-- 6.8: عدد العلاقات في قاعدة البيانات
-- ──────────────────────────────────────────────────────────────
SELECT 
    constraint_name,
    constraint_type,
    table_name,
    r_constraint_name
FROM user_constraints
WHERE constraint_type = 'R'
  AND table_name IN ('USER_ROLES','ROLE_PERMISSIONS','ACCESS_LOGS','MFA_TOKENS','SESSIONS','AUDIT_TRAIL')
ORDER BY table_name;

-- ╔════════════════════════════════════════════════════════════╗
-- ║       القسم 7: سيناريوهات عملية جاهزة                     ║
-- ║       الاستخدام: تمثيل سيناريوهات حقيقية                    ║
-- ╚════════════════════════════════════════════════════════════╝

-- ──────────────────────────────────────────────────────────────
-- 7.1: سيناريو: إضافة موظف جديد وتعيينه كـ Analyst
-- ──────────────────────────────────────────────────────────────
-- الخطوة 1: أضف المستخدم
INSERT INTO "User" (username, email, password_hash, full_name)
VALUES ('newanalyst', 'new@iam.com', 'analyst@2026', 'New Analyst');
COMMIT;

-- الخطوة 2: أسند له دور SECURITY_ANALYST
INSERT INTO USER_ROLES (user_id, role_id, assigned_by)
VALUES (
    (SELECT user_id FROM "User" WHERE username = 'newanalyst'),
    (SELECT role_id FROM ROLES WHERE role_name = 'SECURITY_ANALYST'),
    (SELECT user_id FROM "User" WHERE username = 'admin')
);
COMMIT;

-- الخطوة 3: تحقق
SELECT u.username, r.role_name, ur.assigned_at
FROM "User" u
JOIN USER_ROLES ur ON u.user_id = ur.user_id
JOIN ROLES r ON ur.role_id = r.role_id
WHERE u.username = 'newanalyst';

-- ──────────────────────────────────────────────────────────────
-- 7.2: سيناريو: ترقية موظف من Viewer إلى Manager
-- ──────────────────────────────────────────────────────────────
-- الخطوة 1: احذف الدور القديم
DELETE FROM USER_ROLES
WHERE user_id = (SELECT user_id FROM "User" WHERE username = 'viewer1')
  AND role_id = (SELECT role_id FROM ROLES WHERE role_name = 'VIEWER');
COMMIT;

-- الخطوة 2: أضف الدور الجديد
INSERT INTO USER_ROLES (user_id, role_id, assigned_by)
VALUES (
    (SELECT user_id FROM "User" WHERE username = 'viewer1'),
    (SELECT role_id FROM ROLES WHERE role_name = 'MANAGER'),
    (SELECT user_id FROM "User" WHERE username = 'admin')
);
COMMIT;

-- الخطوة 3: تحقق
SELECT u.username, r.role_name
FROM "User" u
JOIN USER_ROLES ur ON u.user_id = ur.user_id
JOIN ROLES r ON ur.role_id = r.role_id
WHERE u.username = 'viewer1';

-- ──────────────────────────────────────────────────────────────
-- 7.3: سيناريو: تعطيل حساب موظف غادر الشركة
-- ──────────────────────────────────────────────────────────────
-- الخطوة 1: عطّل الحساب
UPDATE "User" SET is_active = 'N' WHERE username = 'guest1';
COMMIT;

-- الخطوة 2: أنهِ جلساته
UPDATE SESSIONS SET is_active = 'N', logout_time = SYSDATE
WHERE user_id = (SELECT user_id FROM "User" WHERE username = 'guest1')
  AND is_active = 'Y';
COMMIT;

-- الخطوة 3: تحقق
SELECT username, is_active FROM "User" WHERE username = 'guest1';
SELECT * FROM V_ACTIVE_SESSIONS WHERE username = 'guest1';

-- ──────────────────────────────────────────────────────────────
-- 7.4: سيناريو: التحقيق في محاولات دخول مشبوهة
-- ──────────────────────────────────────────────────────────────
-- عرض المحاولات الفاشلة من IP معين
SELECT 
    u.username,
    a.ip_address,
    a.log_time,
    a.user_agent,
    a.details
FROM ACCESS_LOGS a
JOIN "User" u ON a.user_id = u.user_id
WHERE a.status = 'FAILED'
ORDER BY a.log_time DESC;

-- ╔════════════════════════════════════════════════════════════╗
-- ║       القسم 8: الاستعلامات المعقدة                          ║
-- ║       الاستخدام: للتحليل المتقدم                            ║
-- ╚════════════════════════════════════════════════════════════╝

-- ──────────────────────────────────────────────────────────────
-- 8.1: تحليل نشاط المستخدمين مع الترتيب
-- ──────────────────────────────────────────────────────────────
SELECT 
    u.username,
    u.full_name,
    COUNT(a.log_id) AS total_activities,
    SUM(CASE WHEN a.status = 'SUCCESS' THEN 1 ELSE 0 END) AS success_count,
    SUM(CASE WHEN a.status = 'FAILED' THEN 1 ELSE 0 END) AS failed_count,
    ROUND((SUM(CASE WHEN a.status = 'SUCCESS' THEN 1 ELSE 0 END) * 100.0) / 
          NULLIF(COUNT(a.log_id), 0), 2) AS success_rate,
    DENSE_RANK() OVER (ORDER BY COUNT(a.log_id) DESC) AS activity_rank
FROM "User" u
LEFT JOIN ACCESS_LOGS a ON u.user_id = a.user_id
GROUP BY u.user_id, u.username, u.full_name
ORDER BY activity_rank;

-- ──────────────────────────────────────────────────────────────
-- 8.2: تحليل الأدوار والصلاحيات
-- ──────────────────────────────────────────────────────────────
SELECT 
    r.role_name,
    (SELECT COUNT(*) FROM ROLE_PERMISSIONS rp WHERE rp.role_id = r.role_id) AS total_permissions,
    (SELECT COUNT(*) FROM USER_ROLES ur WHERE ur.role_id = r.role_id) AS total_users,
    (SELECT LISTAGG(p.permission_code, ', ') WITHIN GROUP (ORDER BY p.permission_code)
     FROM ROLE_PERMISSIONS rp
     JOIN PERMISSIONS p ON rp.permission_id = p.permission_id
     WHERE rp.role_id = r.role_id) AS permission_list
FROM ROLES r
ORDER BY total_permissions DESC;

-- ──────────────────────────────────────────────────────────────
-- 8.3: كشف المستخدمين المشبوهين (CTE)
-- ──────────────────────────────────────────────────────────────
WITH UserActivity AS (
    SELECT u.user_id, u.username,
        COUNT(CASE WHEN a.status = 'FAILED' THEN 1 END) AS failed_count,
        COUNT(CASE WHEN a.status = 'SUCCESS' THEN 1 END) AS success_count
    FROM "User" u JOIN ACCESS_LOGS a ON u.user_id = a.user_id
    GROUP BY u.user_id, u.username
)
SELECT username, failed_count, success_count,
    CASE 
        WHEN failed_count >= 5 THEN 'HIGH RISK'
        WHEN failed_count >= 3 THEN 'MEDIUM RISK'
        ELSE 'LOW'
    END AS threat_level
FROM UserActivity
WHERE failed_count > success_count OR failed_count >= 3
ORDER BY failed_count DESC;

-- ──────────────────────────────────────────────────────────────
-- 8.4: التحليل الزمني (Brute Force Detection)
-- ──────────────────────────────────────────────────────────────
SELECT 
    u.username,
    a.status,
    a.log_time,
    LAG(a.log_time) OVER (PARTITION BY u.user_id ORDER BY a.log_time) AS previous_login,
    ROUND((a.log_time - LAG(a.log_time) OVER (PARTITION BY u.user_id ORDER BY a.log_time)) * 24 * 60, 2) AS minutes_since_last,
    CASE 
        WHEN a.status = 'FAILED' AND 
             (a.log_time - LAG(a.log_time) OVER (PARTITION BY u.user_id ORDER BY a.log_time)) * 24 * 60 < 2 
        THEN 'RAPID RETRY'
        ELSE 'Normal'
    END AS pattern
FROM ACCESS_LOGS a
JOIN "User" u ON a.user_id = u.user_id
WHERE a.action = 'LOGIN'
ORDER BY u.username, a.log_time DESC;

-- ══════════════════════════════════════════════════════════════
-- نهاية الملف
-- ══════════════════════════════════════════════════════════════