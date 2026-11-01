-- ==========================================
-- COMPLEX QUERIES - IAM PROJECT
-- ==========================================

-- ═══════════════════════════════════════════
-- 📊 الاستعلام 1: تحليل نشاط المستخدمين مع الترتيب
-- ═══════════════════════════════════════════
-- الاسم: User Activity Analysis with Ranking
-- الفائدة: يعرض كل مستخدم مع عدد محاولات الدخول، والنجاح، والفشل،
--         وترتيبه حسب النشاط، وترتيبه حسب المخاطر.
-- التقنيات: DENSE_RANK(), CASE WHEN, LEFT JOIN, NULLIF, ROUND
-- ═══════════════════════════════════════════
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

-- ═══════════════════════════════════════════
-- 📊 الاستعلام 2: تحليل الأدوار والصلاحيات
-- ═══════════════════════════════════════════
-- الاسم: Role-Permission Analysis
-- الفائدة: يعرض كل دور مع عدد صلاحياته، وعدد المستخدمين المرتبطين به،
--         وقائمة الصلاحيات كاملة، وتصنيف مستوى الخطورة.
-- التقنيات: Correlated Subqueries, LISTAGG, CASE WHEN, WITHIN GROUP
-- ═══════════════════════════════════════════
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

-- ═══════════════════════════════════════════
-- 📊 الاستعلام 3: كشف المستخدمين المشبوهين
-- ═══════════════════════════════════════════
-- الاسم: Suspicious Users Detection
-- الفائدة: يكشف المستخدمين اللي عندهم محاولات فاشلة أكثر من الناجحة،
--         أو محاولات متكررة من IPs متعددة، مع تصنيف مستوى التهديد.
-- التقنيات: WITH (CTEs), Multiple CTEs, Correlated Subquery, LISTAGG, CASE WHEN
-- ═══════════════════════════════════════════
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

-- ═══════════════════════════════════════════
-- 📊 الاستعلام 4: التحليل الزمني لكشف Brute Force
-- ═══════════════════════════════════════════
-- الاسم: Temporal Behavior Analysis (Brute Force Detection)
-- الفائدة: يحلل الفروق الزمنية بين محاولات الدخول، ويكشف الأنماط
--         المشبوهة مثل المحاولات السريعة المتكررة (Brute Force).
-- التقنيات: LAG(), ROW_NUMBER(), PARTITION BY, OVER, CASE WHEN
-- ═══════════════════════════════════════════
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