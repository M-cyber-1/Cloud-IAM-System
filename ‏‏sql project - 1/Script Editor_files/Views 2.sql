ل الجلسات النشطه 

CREATE OR REPLACE VIEW V_ACTIVE_SESSIONS AS
SELECT 
    u.username,
    u.full_name,
    s.session_token,
    s.ip_address,
    s.login_time,
    ROUND((SYSDATE - s.login_time) * 24, 2) AS hours_active
FROM "User" u
JOIN SESSIONS s ON u.user_id = s.user_id
WHERE s.is_active = 'Y'
ORDER BY s.login_time DESC;

ل  محاولات الدخول الفاشله 

CREATE OR REPLACE VIEW V_FAILED_LOGINS AS
SELECT 
    u.username,
    u.full_name,
    COUNT(a.log_id) AS failed_attempts,
    MAX(a.log_time) AS last_failed_attempt,
    LISTAGG(DISTINCT a.ip_address, ', ') WITHIN GROUP (ORDER BY a.ip_address) AS suspicious_ips
FROM "User" u
JOIN ACCESS_LOGS a ON u.user_id = a.user_id
WHERE a.status = 'FAILED'
GROUP BY u.username, u.full_name
HAVING COUNT(a.log_id) >= 2
ORDER BY failed_attempts DESC;