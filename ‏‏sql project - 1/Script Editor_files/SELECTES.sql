-- ==========================================================
-- CLOUD IAM SYSTEM - COMPLETE QUERIES COLLECTION
-- Author: Mohammed Al-Hattami
-- Course: Database Systems
-- Year: 2026
-- ==========================================================
-- هذا الملف يحتوي على جميع استعلامات المشروع:
-- 1. استعلامات أساسية (Basic Queries)
-- 2. استعلامات الربط (JOIN Queries)
-- 3. استعلامات التجميع (Aggregation Queries)
-- 4. استعلامات Views
-- 5. استعلامات معقدة (Complex Queries)
-- ==========================================================

-- ══════════════════════════════════════════════════════════
-- 🔹 القسم 1: استعلامات أساسية (Basic Queries)
-- ══════════════════════════════════════════════════════════

-- ─────────────────────────────────────────────────────────
-- 📊 الاستعلام 1: عرض جميع المستخدمين
-- ─────────────────────────────────────────────────────────
-- الفائدة: عرض قائمة كاملة بجميع المستخدمين في النظام.
-- كيف يشتغل: SELECT * يجلب كل الأعمدة من جدول "User".
-- ملاحظة: كلمة "User" بين علامتي تنصيص لأنها محجوزة في Oracle.
-- ─────────────────────────────────────────────────────────
SELECT * FROM "User";

-- ─────────────────────────────────────────────────────────
-- 📊 الاستعلام 2: عرض المستخدمين النشطين فقط
-- ─────────────────────────────────────────────────────────
-- الفائدة: تصفية المستخدمين النشطين (is_active = 'Y').
-- كيف يشتغل: WHERE يفلتر الصفوف حسب الشرط.
-- ─────────────────────────────────────────────────────────
SELECT user_id, username, email, full_name, is_active
FROM "User"
WHERE is_active = 'Y';

-- ─────────────────────────────────────────────────────────
-- 📊 الاستعلام 3: عرض كلمات المرور المشفرة (إثبات التشفير)
-- ─────────────────────────────────────────────────────────
-- الفائدة: إثبات أن كلمات المرور مشفرة (Hashed) وليست نصاً صريحاً.
-- كيف يشتغل: نعرض username و password_hash و salt.
-- النتيجة: كلمة المرور تظهر كنص طويل (Hex) غير مقروء.
-- ─────────────────────────────────────────────────────────
SELECT username, password_hash, salt
FROM "User"
ORDER BY username;

-- ─────────────────────────────────────────────────────────
-- 📊 الاستعلام 4: عرض الأدوار والصلاحيات
-- ─────────────────────────────────────────────────────────
-- الفائدة: عرض قائمة الأدوار والصلاحيات في النظام.
-- كيف يشتغل: SELECT بسيط من الجدولين.
-- ─────────────────────────────────────────────────────────
SELECT * FROM ROLES;
SELECT * FROM PERMISSIONS;

-- ─────────────────────────────────────────────────────────
-- 📊 الاستعلام 5: عرض سجل الوصول (آخر 20 حدث)
-- ─────────────────────────────────────────────────────────
-- الفائدة: مراجعة آخر الأحداث الأمنية.
-- كيف يشتغل: ORDER BY DESC + FETCH FIRST 20 ROWS.
-- ─────────────────────────────────────────────────────────
SELECT log_id, user_id, action, status, ip_address, log_time, details
FROM ACCESS_LOGS
ORDER BY log_time DESC
FETCH FIRST 20 ROWS ONLY;

-- ─────────────────────────────────────────────────────────
-- 📊 الاستعلام 6: عرض الجلسات النشطة
-- ─────────────────────────────────────────────────────────
-- الفائدة: معرفة من هو متصل الآن بالنظام.
-- كيف يشتغل: WHERE is_active = 'Y'.
-- ─────────────────────────────────────────────────────────
SELECT session_id, user_id, session_token, ip_address, login_time
FROM SESSIONS
WHERE is_active = 'Y';

-- ─────────────────────────────────────────────────────────
-- 📊 الاستعلام 7: عرض السياسات الأمنية النشطة
-- ─────────────────────────────────────────────────────────
-- الفائدة: عرض السياسات الأمنية المفعّلة حالياً.
-- كيف يشتغل: WHERE is_active = 'Y'.
-- ─────────────────────────────────────────────────────────
SELECT policy_id, policy_name, condition_type, condition_value
FROM POLICIES
WHERE is_active = 'Y';

-- ─────────────────────────────────────────────────────────
-- 📊 الاستعلام 8: عرض رموز MFA غير المستخدمة
-- ─────────────────────────────────────────────────────────
-- الفائدة: عرض رموز التحقق بخطوتين التي لم تُستخدم بعد.
-- كيف يشتغل: WHERE is_used = 'N'.
-- ─────────────────────────────────────────────────────────
SELECT token_id, user_id, token_code, expires_at, is_used
FROM MFA_TOKENS
WHERE is_used = 'N';

-- ─────────────────────────────────────────────────────────
-- 📊 الاستعلام 9: عرض سجل التدقيق
-- ─────────────────────────────────────────────────────────
-- الفائدة: مراجعة كل التغييرات على الجداول.
-- كيف يشتغل: SELECT * من AUDIT_TRAIL.
-- ─────────────────────────────────────────────────────────
SELECT * FROM AUDIT_TRAIL
ORDER BY changed_at DESC;

-- ══════════════════════════════════════════════════════════
-- 🔹 القسم 2: استعلامات الربط (JOIN Queries)
-- ══════════════════════════════════════════════════════════

-- ─────────────────────────────────────────────────────────
-- 📊 الاستعلام 10: عرض كل مستخدم مع أدواره
-- ─────────────────────────────────────────────────────────
-- الفائدة: ربط المستخدمين بالأدوار (Many-to-Many).
-- كيف يشتغل: 
--   - JOIN بين "User" و USER_ROLES (عبر user_id).
--   - JOIN بين USER_ROLES و ROLES (عبر role_id).
-- ─────────────────────────────────────────────────────────
SELECT 
    u.username,
    u.full_name,
    r.role_name,
    r.description,
    ur.assigned_at
FROM "User" u
JOIN USER_ROLES ur ON u.user_id = ur.user_id
JOIN ROLES r ON ur.role_id = r.role_id
ORDER BY u.username;

-- ─────────────────────────────────────────────────────────
-- 📊 الاستعلام 11: عرض كل دور مع صلاحياته
-- ─────────────────────────────────────────────────────────
-- الفائدة: ربط الأدوار بالصلاحيات (Many-to-Many).
-- كيف يشتغل: 
--   - JOIN بين ROLES و ROLE_PERMISSIONS.
--   - JOIN بين ROLE_PERMISSIONS و PERMISSIONS.
-- ─────────────────────────────────────────────────────────
SELECT 
    r.role_name,
    p.permission_code,
    p.resource_name,
    p.action
FROM ROLES r
JOIN ROLE_PERMISSIONS rp ON r.role_id = rp.role_id
JOIN PERMISSIONS p ON rp.permission_id = p.permission_id
ORDER BY r.role_name, p.permission_code;

-- ─────────────────────────────────────────────────────────
-- 📊 الاستعلام 12: عرض سجل الوصول مع بيانات المستخدم
-- ─────────────────────────────────────────────────────────
-- الفائدة: ربط كل حدث بالمستخدم المسؤول عنه.
-- كيف يشتغل: JOIN بين ACCESS_LOGS و "User".
-- ─────────────────────────────────────────────────────────
SELECT 
    u.username,
    u.full_name,
    a.action,
    a.status,
    a.ip_address,
    a.log_time,
    a.details
FROM ACCESS_LOGS a
JOIN "User" u ON a.user_id = u.user_id
ORDER BY a.log_time DESC;

-- ─────────────────────────────────────────────────────────
-- 📊 الاستعلام 13: عرض كل مستخدم مع آخر جلسة له
-- ─────────────────────────────────────────────────────────
-- الفائدة: معرفة آخر وقت دخول لكل مستخدم.
-- كيف يشتغل: JOIN مع SESSIONS + ORDER BY.
-- ─────────────────────────────────────────────────────────
SELECT 
    u.username,
    u.full_name,
    s.session_token,
    s.ip_address,
    s.login_time,
    s.is_active
FROM "User" u
JOIN SESSIONS s ON u.user_id = s.user_id
ORDER BY u.username, s.login_time DESC;

-- ─────────────────────────────────────────────────────────
-- 📊 الاستعلام 14: عرض المستخدمين مع سياسات MFA
-- ─────────────────────────────────────────────────────────
-- الفائدة: معرفة من عنده رموز MFA نشطة.
-- كيف يشتغل: JOIN بين "User" و MFA_TOKENS.
-- ─────────────────────────────────────────────────────────
SELECT 
    u.username,
    u.full_name,
    m.token_code,
    m.expires_at,
    m.is_used
FROM "User" u
JOIN MFA_TOKENS m ON u.user_id = m.user_id
ORDER BY u.username;

-- ─────────────────────────────────────────────────────────
-- 📊 الاستعلام 15: عرض الرؤية الشاملة (V_USER_ACCESS)
-- ─────────────────────────────────────────────────────────
-- الفائدة: عرض التقرير الكامل من الـ View الجاهز.
-- كيف يشتغل: SELECT من V_USER_ACCESS.
-- ─────────────────────────────────────────────────────────
SELECT * FROM V_USER_ACCESS;

-- ══════════════════════════════════════════════════════════
-- 🔹 القسم 3: استعلامات التجميع (Aggregation Queries)
-- ══════════════════════════════════════════════════════════

-- ─────────────────────────────────────────────────────────
-- 📊 الاستعلام 16: عدد المستخدمين لكل دور
-- ─────────────────────────────────────────────────────────
-- الفائدة: معرفة كم مستخدم في كل دور.
-- كيف يشتغل: COUNT + GROUP BY.
-- ─────────────────────────────────────────────────────────
SELECT 
    r.role_name,
    COUNT(ur.user_id) AS total_users
FROM ROLES r
LEFT JOIN USER_ROLES ur ON r.role_id = ur.role_id
GROUP BY r.role_name
ORDER BY total_users DESC;

-- ─────────────────────────────────────────────────────────
-- 📊 الاستعلام 17: عدد الصلاحيات لكل دور
-- ─────────────────────────────────────────────────────────
-- الفائدة: معرفة أي دور عنده أكثر صلاحيات.
-- كيف يشتغل: COUNT + GROUP BY.
-- ─────────────────────────────────────────────────────────
SELECT 
    r.role_name,
    COUNT(rp.permission_id) AS total_permissions
FROM ROLES r
LEFT JOIN ROLE_PERMISSIONS rp ON r.role_id = rp.role_id
GROUP BY r.role_name
ORDER BY total_permissions DESC;

-- ─────────────────────────────────────────────────────────
-- 📊 الاستعلام 18: عدد محاولات الدخول (نجاح/فشل) لكل مستخدم
-- ─────────────────────────────────────────────────────────
-- الفائدة: تحليل سلوك الدخول لكل مستخدم.
-- كيف يشتغل: SUM(CASE WHEN) + GROUP BY.
-- ─────────────────────────────────────────────────────────
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

-- ─────────────────────────────────────────────────────────
-- 📊 الاستعلام 19: عدد الأحداث حسب الـ IP
-- ─────────────────────────────────────────────────────────
-- الفائدة: كشف الـ IPs المشبوهة (كثرة محاولات).
-- كيف يشتغل: COUNT + GROUP BY على ip_address.
-- ─────────────────────────────────────────────────────────
SELECT 
    ip_address,
    COUNT(log_id) AS total_events,
    SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) AS failed_count
FROM ACCESS_LOGS
GROUP BY ip_address
HAVING COUNT(log_id) >= 2
ORDER BY failed_count DESC, total_events DESC;

-- ─────────────────────────────────────────────────────────
-- 📊 الاستعلام 20: عدد الجلسات النشطة لكل مستخدم
-- ─────────────────────────────────────────────────────────
-- الفائدة: معرفة المستخدمين اللي عندهم جلسات متعددة.
-- كيف يشتغل: COUNT + GROUP BY.
-- ─────────────────────────────────────────────────────────
SELECT 
    u.username,
    COUNT(s.session_id) AS active_sessions
FROM "User" u
JOIN SESSIONS s ON u.user_id = s.user_id
WHERE s.is_active = 'Y'
GROUP BY u.username
ORDER BY active_sessions DESC;

-- ══════════════════════════════════════════════════════════
-- 🔹 القسم 4: استعلامات Views
-- ══════════════════════════════════════════════════════════

-- ─────────────────────────────────────────────────────────
-- 📊 الاستعلام 21: V_USER_ACCESS (تقرير شامل)
-- ─────────────────────────────────────────────────────────
-- الفائدة: عرض كل مستخدم مع دوره وصلاحياته.
-- كيف يشتغل: View جاهز مبني على 5 جداول.
-- ─────────────────────────────────────────────────────────
SELECT * FROM V_USER_ACCESS
ORDER BY username, role_name;

-- ─────────────────────────────────────────────────────────
-- 📊 الاستعلام 22: V_FAILED_LOGINS (محاولات فاشلة)
-- ─────────────────────────────────────────────────────────
-- الفائدة: كشف المستخدمين اللي عندهم محاولات فاشلة متكررة.
-- كيف يشتغل: View يستخدم GROUP BY + LISTAGG.
-- ─────────────────────────────────────────────────────────
SELECT * FROM V_FAILED_LOGINS;

-- ─────────────────────────────────────────────────────────
-- 📊 الاستعلام 23: V_ACTIVE_SESSIONS (الجلسات النشطة)
-- ─────────────────────────────────────────────────────────
-- الفائدة: عرض الجلسات النشطة حالياً مع مدة النشاط.
-- كيف يشتغل: View يحسب المدة بـ ROUND و SYSDATE.
-- ─────────────────────────────────────────────────────────
SELECT * FROM V_ACTIVE_SESSIONS;

-- ══════════════════════════════════════════════════════════
-- 🔹 القسم 5: استعلامات معقدة (Complex Queries)
-- ══════════════════════════════════════════════════════════

-- ─────────────────────────────────────────────────────────
-- 📊 الاستعلام 24: تحليل نشاط المستخدمين مع الترتيب
-- ─────────────────────────────────────────────────────────
-- الفائدة: ترتيب المستخدمين حسب النشاط والمخاطر.
-- التقنيات: DENSE_RANK(), CASE WHEN, LEFT JOIN, NULLIF, ROUND
-- كيف يشتغل:
--   1. COUNT(a.log_id) → عدد الأنشطة.
--   2. DENSE_RANK() OVER → ترتيب حسب النشاط.
--   3. ROUND → حساب نسبة النجاح.
-- ─────────────────────────────────────────────────────────
SELECT 
    u.username,
    u.full_name,
    COUNT(a.log_id) AS total_activities,
    SUM(CASE WHEN a.status = 'SUCCESS' THEN 1 ELSE 0 END) AS success_count,
    SUM(CASE WHEN a.status = 'FAILED' THEN 1 ELSE 0 END) AS failed_count,
    ROUND(
        (SUM(CASE WHEN a.status = 'SUCCESS' THEN 1 ELSE 0 END) * 100.0) / 
        NULLIF(COUNT(a.log_id), 0), 2
    ) AS success_rate,
    DENSE_RANK() OVER (ORDER BY COUNT(a.log_id) DESC) AS activity_rank,
    DENSE_RANK() OVER (ORDER BY SUM(CASE WHEN a.status = 'FAILED' THEN 1 ELSE 0 END) DESC) AS risk_rank
FROM "User" u
LEFT JOIN ACCESS_LOGS a ON u.user_id = a.user_id
GROUP BY u.user_id, u.username, u.full_name
ORDER BY activity_rank;

-- ─────────────────────────────────────────────────────────
-- 📊 الاستعلام 25: تحليل الأدوار والصلاحيات (Subqueries)
-- ─────────────────────────────────────────────────────────
-- الفائدة: عرض كل دور مع عدد صلاحياته ومستوى خطورته.
-- التقنيات: Correlated Subqueries, LISTAGG, CASE WHEN
-- كيف يشتغل:
--   1. Subquery في SELECT → عدد الصلاحيات.
--   2. LISTAGG → تجميع الصلاحيات في نص واحد.
--   3. CASE WHEN → تصنيف الخطورة.
-- ─────────────────────────────────────────────────────────
SELECT 
    r.role_name,
    r.description,
    (SELECT COUNT(*) FROM ROLE_PERMISSIONS rp WHERE rp.role_id = r.role_id) AS total_permissions,
    (SELECT COUNT(*) FROM USER_ROLES ur WHERE ur.role_id = r.role_id) AS total_users,
    (SELECT LISTAGG(p.permission_code, ', ') WITHIN GROUP (ORDER BY p.permission_code)
     FROM ROLE_PERMISSIONS rp
     JOIN PERMISSIONS p ON rp.permission_id = p.permission_id
     WHERE rp.role_id = r.role_id) AS permission_list,
    CASE 
        WHEN (SELECT COUNT(*) FROM ROLE_PERMISSIONS rp WHERE rp.role_id = r.role_id) >= 10 THEN 'CRITICAL'
        WHEN (SELECT COUNT(*) FROM ROLE_PERMISSIONS rp WHERE rp.role_id = r.role_id) >= 5 THEN 'HIGH'
        WHEN (SELECT COUNT(*) FROM ROLE_PERMISSIONS rp WHERE rp.role_id = r.role_id) >= 3 THEN 'MEDIUM'
        ELSE 'LOW'
    END AS risk_level
FROM ROLES r
ORDER BY total_permissions DESC;

-- ─────────────────────────────────────────────────────────
-- 📊 الاستعلام 26: كشف المستخدمين المشبوهين (CTE)
-- ─────────────────────────────────────────────────────────
-- الفائدة: كشف المستخدمين اللي عندهم محاولات فاشلة أكثر من الناجحة.
-- التقنيات: WITH (CTEs), Multiple CTEs, Correlated Subquery, LISTAGG
-- كيف يشتغل:
--   1. UserActivity CTE → تجميع بيانات كل مستخدم.
--   2. SuspiciousUsers CTE → تصفية المشبوهين.
--   3. SELECT النهائي → عرض التفاصيل + تصنيف التهديد.
-- ─────────────────────────────────────────────────────────
WITH UserActivity AS (
    SELECT 
        u.user_id,
        u.username,
        u.full_name,
        COUNT(CASE WHEN a.status = 'FAILED' THEN 1 END) AS failed_count,
        COUNT(CASE WHEN a.status = 'SUCCESS' THEN 1 END) AS success_count,
        COUNT(DISTINCT a.ip_address) AS distinct_ips
    FROM "User" u
    JOIN ACCESS_LOGS a ON u.user_id = a.user_id
    GROUP BY u.user_id, u.username, u.full_name
),
SuspiciousUsers AS (
    SELECT * FROM UserActivity
    WHERE failed_count > success_count
       OR failed_count >= 3
       OR distinct_ips >= 3
)
SELECT 
    s.username,
    s.full_name,
    s.failed_count,
    s.success_count,
    s.distinct_ips,
    ROUND((s.failed_count * 100.0) / NULLIF(s.failed_count + s.success_count, 0), 2) AS failure_rate,
    CASE 
        WHEN s.failed_count >= 5 THEN 'HIGH RISK'
        WHEN s.failed_count >= 3 THEN 'MEDIUM RISK'
        ELSE 'UNDER WATCH'
    END AS threat_level,
    (SELECT LISTAGG(DISTINCT a.ip_address, ' | ') 
     FROM ACCESS_LOGS a 
     WHERE a.user_id = s.user_id AND a.status = 'FAILED') AS suspicious_ips
FROM SuspiciousUsers s
ORDER BY s.failed_count DESC;

-- ─────────────────────────────────────────────────────────
-- 📊 الاستعلام 27: التحليل الزمني (Brute Force Detection)
-- ─────────────────────────────────────────────────────────
-- الفائدة: كشف أنماط Brute Force عبر تحليل الفروق الزمنية.
-- التقنيات: LAG(), ROW_NUMBER(), PARTITION BY, OVER
-- كيف يشتغل:
--   1. LAG() → يجيب وقت المحاولة السابقة.
--   2. ROW_NUMBER() → ترقيم المحاولات لكل مستخدم.
--   3. CASE WHEN → كشف المحاولات السريعة (< دقيقتين).
-- ─────────────────────────────────────────────────────────
SELECT 
    u.username,
    a.action,
    a.status,
    a.ip_address,
    a.log_time,
    LAG(a.log_time) OVER (PARTITION BY u.user_id ORDER BY a.log_time) AS previous_login,
    ROUND((a.log_time - LAG(a.log_time) OVER (PARTITION BY u.user_id ORDER BY a.log_time)) * 24 * 60, 2) AS minutes_since_last,
    ROW_NUMBER() OVER (PARTITION BY u.user_id ORDER BY a.log_time DESC) AS attempt_number,
    CASE 
        WHEN a.status = 'FAILED' AND 
             (a.log_time - LAG(a.log_time) OVER (PARTITION BY u.user_id ORDER BY a.log_time)) * 24 * 60 < 2 
        THEN 'RAPID RETRY (Brute Force?)'
        WHEN a.status = 'FAILED' THEN 'Failed Attempt'
        ELSE 'Normal'
    END AS behavior_pattern
FROM ACCESS_LOGS a
JOIN "User" u ON a.user_id = u.user_id
WHERE a.action = 'LOGIN'
ORDER BY u.username, a.log_time DESC;

-- ══════════════════════════════════════════════════════════
-- 🔹 القسم 6: استعلامات إدارية (Administrative Queries)
-- ══════════════════════════════════════════════════════════

-- ─────────────────────────────────────────────────────────
-- 📊 الاستعلام 28: عدد الصفوف في كل جدول
-- ─────────────────────────────────────────────────────────
-- الفائدة: معرفة حجم البيانات في كل جدول.
-- كيف يشتغل: UNION ALL بين COUNT لكل جدول.
-- ─────────────────────────────────────────────────────────
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

-- ─────────────────────────────────────────────────────────
-- 📊 الاستعلام 29: عرض الجداول و Views و Sequences
-- ─────────────────────────────────────────────────────────
-- الفائدة: التحقق من وجود جميع العناصر.
-- كيف يشتغل: استعلام على Data Dictionary.
-- ─────────────────────────────────────────────────────────
SELECT 'TABLE' AS type, table_name AS name FROM user_tables
WHERE table_name IN ('User','ROLES','PERMISSIONS','USER_ROLES','ROLE_PERMISSIONS','POLICIES','ACCESS_LOGS','MFA_TOKENS','SESSIONS','AUDIT_TRAIL')
UNION ALL
SELECT 'VIEW' AS type, view_name AS name FROM user_views
WHERE view_name IN ('V_USER_ACCESS','V_FAILED_LOGINS','V_ACTIVE_SESSIONS')
UNION ALL
SELECT 'SEQUENCE' AS type, sequence_name AS name FROM user_sequences
ORDER BY type, name;

-- ─────────────────────────────────────────────────────────
-- 📊 الاستعلام 30: اختبار الـ Sequences
-- ─────────────────────────────────────────────────────────
-- الفائدة: التأكد من أن الـ Sequences تعمل.
-- كيف يشتغل: NEXTVAL يولد الرقم التالي.
-- ─────────────────────────────────────────────────────────
SELECT seq_users.NEXTVAL AS next_user_id FROM dual;
SELECT seq_roles.NEXTVAL AS next_role_id FROM dual;
SELECT seq_access_logs.NEXTVAL AS next_log_id FROM dual;

-- ══════════════════════════════════════════════════════════
-- 🔹 القسم 7: استعلامات التحقق النهائي
-- ══════════════════════════════════════════════════════════

-- ─────────────────────────────────────────────────────────
-- 📊 الاستعلام 31: التحقق من التشفير
-- ─────────────────────────────────────────────────────────
-- الفائدة: إثبات أن كلمات المرور مشفرة.
-- النتيجة المتوقعة: نص طويل (32 حرف) بدلاً من كلمة المرور.
-- ─────────────────────────────────────────────────────────
SELECT 
    username,
    password_hash,
    salt,
    LENGTH(password_hash) AS hash_length
FROM "User"
ORDER BY username;

-- ─────────────────────────────────────────────────────────
-- 📊 الاستعلام 32: التحقق من Triggers
-- ─────────────────────────────────────────────────────────
-- الفائدة: التأكد من وجود الـ Triggers.
-- ─────────────────────────────────────────────────────────
SELECT trigger_name, status, table_name
FROM user_triggers
WHERE trigger_name IN ('TRG_HASH_PASSWORD', 'TRG_AUDIT_USER')
ORDER BY trigger_name;

-- ══════════════════════════════════════════════════════════
-- نهاية الملف
-- ══════════════════════════════════════════════════════════