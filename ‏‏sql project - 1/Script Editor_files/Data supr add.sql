-- ==========================================================
-- CLOUD IAM SYSTEM - REALISTIC ENTERPRISE DATA
-- يولد بيانات شركة حقيقية بأكثر من 320 مستخدم
-- Author: Mohammed Al-Hattami
-- ==========================================================

-- ══════════════════════════════════════════════════════════
-- PART 1: تنظيف شامل (بحذر، من الأبناء إلى الآباء)
-- ══════════════════════════════════════════════════════════
DELETE FROM AUDIT_TRAIL;
DELETE FROM SESSIONS;
DELETE FROM MFA_TOKENS;
DELETE FROM ACCESS_LOGS;
DELETE FROM USER_ROLES;
DELETE FROM ROLE_PERMISSIONS;
DELETE FROM POLICIES;
DELETE FROM PERMISSIONS;
DELETE FROM ROLES;
DELETE FROM "User";
COMMIT;

-- ══════════════════════════════════════════════════════════
-- PART 2: الأدوار (16 دور)
-- ══════════════════════════════════════════════════════════
INSERT INTO ROLES (role_name, description) VALUES ('SUPER_ADMIN', 'Super administrator with unrestricted access');
INSERT INTO ROLES (role_name, description) VALUES ('ADMIN', 'System administrator');
INSERT INTO ROLES (role_name, description) VALUES ('SECURITY_MANAGER', 'Manages security team and policies');
INSERT INTO ROLES (role_name, description) VALUES ('SECURITY_ANALYST', 'Analyzes security logs and incidents');
INSERT INTO ROLES (role_name, description) VALUES ('AUDITOR', 'Reviews audit trails and compliance');
INSERT INTO ROLES (role_name, description) VALUES ('MANAGER', 'Manages users and resources');
INSERT INTO ROLES (role_name, description) VALUES ('DEVELOPER', 'Develops and deploys applications');
INSERT INTO ROLES (role_name, description) VALUES ('SUPPORT', 'Technical support team');
INSERT INTO ROLES (role_name, description) VALUES ('VIEWER', 'Read-only access to dashboards');
INSERT INTO ROLES (role_name, description) VALUES ('HR_MANAGER', 'Human resources management');
INSERT INTO ROLES (role_name, description) VALUES ('DEVOPS', 'DevOps engineering');
INSERT INTO ROLES (role_name, description) VALUES ('DBA', 'Database administrator');
INSERT INTO ROLES (role_name, description) VALUES ('NETWORK_ADMIN', 'Network administrator');
INSERT INTO ROLES (role_name, description) VALUES ('FINANCE_MANAGER', 'Finance department manager');
INSERT INTO ROLES (role_name, description) VALUES ('COMPLIANCE_OFFICER', 'Regulatory compliance officer');
INSERT INTO ROLES (role_name, description) VALUES ('GUEST', 'Temporary guest access');
COMMIT;

-- ══════════════════════════════════════════════════════════
-- PART 3: الصلاحيات (32 صلاحية)
-- ══════════════════════════════════════════════════════════
INSERT INTO PERMISSIONS (permission_code, description, resource_name, action) VALUES ('USER_CREATE', 'Create users', 'Users', 'WRITE');
INSERT INTO PERMISSIONS (permission_code, description, resource_name, action) VALUES ('USER_READ', 'Read users', 'Users', 'READ');
INSERT INTO PERMISSIONS (permission_code, description, resource_name, action) VALUES ('USER_UPDATE', 'Update users', 'Users', 'WRITE');
INSERT INTO PERMISSIONS (permission_code, description, resource_name, action) VALUES ('USER_DELETE', 'Delete users', 'Users', 'DELETE');
INSERT INTO PERMISSIONS (permission_code, description, resource_name, action) VALUES ('ROLE_CREATE', 'Create roles', 'Roles', 'WRITE');
INSERT INTO PERMISSIONS (permission_code, description, resource_name, action) VALUES ('ROLE_READ', 'Read roles', 'Roles', 'READ');
INSERT INTO PERMISSIONS (permission_code, description, resource_name, action) VALUES ('ROLE_ASSIGN', 'Assign roles', 'Roles', 'WRITE');
INSERT INTO PERMISSIONS (permission_code, description, resource_name, action) VALUES ('ROLE_DELETE', 'Delete roles', 'Roles', 'DELETE');
INSERT INTO PERMISSIONS (permission_code, description, resource_name, action) VALUES ('LOG_READ', 'Read access logs', 'Logs', 'READ');
INSERT INTO PERMISSIONS (permission_code, description, resource_name, action) VALUES ('LOG_DELETE', 'Delete access logs', 'Logs', 'DELETE');
INSERT INTO PERMISSIONS (permission_code, description, resource_name, action) VALUES ('LOG_EXPORT', 'Export logs', 'Logs', 'READ');
INSERT INTO PERMISSIONS (permission_code, description, resource_name, action) VALUES ('LOG_ANALYZE', 'Analyze logs', 'Logs', 'READ');
INSERT INTO PERMISSIONS (permission_code, description, resource_name, action) VALUES ('POLICY_CREATE', 'Create policies', 'Policies', 'WRITE');
INSERT INTO PERMISSIONS (permission_code, description, resource_name, action) VALUES ('POLICY_READ', 'Read policies', 'Policies', 'READ');
INSERT INTO PERMISSIONS (permission_code, description, resource_name, action) VALUES ('POLICY_UPDATE', 'Update policies', 'Policies', 'WRITE');
INSERT INTO PERMISSIONS (permission_code, description, resource_name, action) VALUES ('POLICY_DELETE', 'Delete policies', 'Policies', 'DELETE');
INSERT INTO PERMISSIONS (permission_code, description, resource_name, action) VALUES ('SESSION_READ', 'Read active sessions', 'Sessions', 'READ');
INSERT INTO PERMISSIONS (permission_code, description, resource_name, action) VALUES ('SESSION_KILL', 'Terminate sessions', 'Sessions', 'DELETE');
INSERT INTO PERMISSIONS (permission_code, description, resource_name, action) VALUES ('SESSION_AUDIT', 'Audit sessions', 'Sessions', 'READ');
INSERT INTO PERMISSIONS (permission_code, description, resource_name, action) VALUES ('MFA_MANAGE', 'Manage MFA tokens', 'MFA', 'WRITE');
INSERT INTO PERMISSIONS (permission_code, description, resource_name, action) VALUES ('MFA_READ', 'Read MFA tokens', 'MFA', 'READ');
INSERT INTO PERMISSIONS (permission_code, description, resource_name, action) VALUES ('MFA_RESET', 'Reset MFA for users', 'MFA', 'WRITE');
INSERT INTO PERMISSIONS (permission_code, description, resource_name, action) VALUES ('MFA_DISABLE', 'Disable MFA', 'MFA', 'DELETE');
INSERT INTO PERMISSIONS (permission_code, description, resource_name, action) VALUES ('AUDIT_READ', 'Read audit trail', 'Audit', 'READ');
INSERT INTO PERMISSIONS (permission_code, description, resource_name, action) VALUES ('AUDIT_EXPORT', 'Export audit trail', 'Audit', 'READ');
INSERT INTO PERMISSIONS (permission_code, description, resource_name, action) VALUES ('AUDIT_ARCHIVE', 'Archive audit trail', 'Audit', 'WRITE');
INSERT INTO PERMISSIONS (permission_code, description, resource_name, action) VALUES ('AUDIT_DELETE', 'Delete audit trail', 'Audit', 'DELETE');
INSERT INTO PERMISSIONS (permission_code, description, resource_name, action) VALUES ('REPORT_VIEW', 'View reports', 'Reports', 'READ');
INSERT INTO PERMISSIONS (permission_code, description, resource_name, action) VALUES ('REPORT_EXPORT', 'Export reports', 'Reports', 'READ');
INSERT INTO PERMISSIONS (permission_code, description, resource_name, action) VALUES ('REPORT_CREATE', 'Create custom reports', 'Reports', 'WRITE');
INSERT INTO PERMISSIONS (permission_code, description, resource_name, action) VALUES ('CONFIG_READ', 'Read system config', 'Config', 'READ');
INSERT INTO PERMISSIONS (permission_code, description, resource_name, action) VALUES ('CONFIG_UPDATE', 'Update system config', 'Config', 'WRITE');
COMMIT;

-- ══════════════════════════════════════════════════════════
-- PART 4: المستخدمون (320 مستخدم بأسماء واقعية)
-- ══════════════════════════════════════════════════════════
DECLARE
    TYPE name_array IS TABLE OF VARCHAR2(50);
    v_firsts name_array := name_array(
        'Mohammed','Ahmed','Ali','Omar','Khalid','Yasser','Abdullah','Salem','Nasser','Fahd',
        'Saud','Hassan','Hussein','Ibrahim','Yousef','Aisha','Fatima','Maryam','Hana','Noor',
        'Sara','Layla','Amal','Rania','Dina','Reem','Lina','Mona','Huda','Wafa',
        'Bilal','Tariq','Walid','Ammar','Anas','Zaid','Hamza','Rami','Sami','Faris',
        'Majed','Nabil','Osama','Qasim','Rashid','Tawfiq','Umar','Wael','Yahya','Zakaria'
    );
    v_lasts name_array := name_array(
        'Al-Hattami','Al-Yemeni','Al-Sanani','Al-Adeni','Al-Taizi','Al-Hadhrami','Al-Ibbi','Al-Dhamari','Al-Maribi','Al-Jawfi',
        'Al-Mahdi','Al-Shami','Al-Qadhi','Al-Ahdal','Al-Wazir','Al-Akwa','Al-Suraimi','Al-Zubairi','Al-Mutawakkil','Al-Wasabi',
        'Al-Bakri','Al-Kabsi','Al-Radaei','Al-Amri','Al-Hakimi','Al-Sabri','Al-Qubati','Al-Nahari','Al-Maqtari','Al-Sharabi',
        'Al-Harazi','Al-Khulaidi','Al-Absi','Al-Muradi','Al-Hemyari','Al-Zaidi','Al-Kohlani','Al-Jabri','Al-Salami','Al-Matari'
    );
    v_first VARCHAR2(50);
    v_last  VARCHAR2(50);
    v_username VARCHAR2(50);
    v_email VARCHAR2(100);
    v_password VARCHAR2(50);
    v_active CHAR(1);
BEGIN
    FOR i IN 1..320 LOOP
        v_first := v_firsts(TRUNC(DBMS_RANDOM.VALUE(1, v_firsts.COUNT + 1)));
        v_last  := v_lasts(TRUNC(DBMS_RANDOM.VALUE(1, v_lasts.COUNT + 1)));
        v_username := LOWER(v_first) || '_' || i;
        v_email    := v_username || '@cloud-iam.com';
        v_password := v_username || '@2026';
        
        -- 10% من المستخدمين معطلون
        IF MOD(i, 10) = 0 THEN
            v_active := 'N';
        ELSE
            v_active := 'Y';
        END IF;
        
        INSERT INTO "User" (username, email, password_hash, full_name, is_active)
        VALUES (v_username, v_email, v_password, v_first || ' ' || v_last, v_active);
    END LOOP;
    COMMIT;
END;
/

-- ══════════════════════════════════════════════════════════
-- PART 5: إسناد الأدوار للمستخدمين (حسب النسب المحددة)
-- ══════════════════════════════════════════════════════════
DECLARE
    v_counter NUMBER := 0;
    v_role_id NUMBER;
    v_admin_id NUMBER;
BEGIN
    SELECT MIN(user_id) INTO v_admin_id FROM "User";
    
    FOR u IN (SELECT user_id FROM "User" ORDER BY user_id) LOOP
        v_counter := v_counter + 1;
        
        IF v_counter <= 3 THEN
            SELECT role_id INTO v_role_id FROM ROLES WHERE role_name = 'SUPER_ADMIN';
        ELSIF v_counter <= 15 THEN
            SELECT role_id INTO v_role_id FROM ROLES WHERE role_name = 'ADMIN';
        ELSIF v_counter <= 40 THEN
            SELECT role_id INTO v_role_id FROM ROLES WHERE role_name = 'SECURITY_MANAGER';
        ELSIF v_counter <= 90 THEN
            SELECT role_id INTO v_role_id FROM ROLES WHERE role_name = 'SECURITY_ANALYST';
        ELSIF v_counter <= 120 THEN
            SELECT role_id INTO v_role_id FROM ROLES WHERE role_name = 'AUDITOR';
        ELSIF v_counter <= 160 THEN
            SELECT role_id INTO v_role_id FROM ROLES WHERE role_name = 'MANAGER';
        ELSIF v_counter <= 210 THEN
            SELECT role_id INTO v_role_id FROM ROLES WHERE role_name = 'DEVELOPER';
        ELSIF v_counter <= 230 THEN
            SELECT role_id INTO v_role_id FROM ROLES WHERE role_name = 'SUPPORT';
        ELSIF v_counter <= 240 THEN
            SELECT role_id INTO v_role_id FROM ROLES WHERE role_name = 'HR_MANAGER';
        ELSIF v_counter <= 250 THEN
            SELECT role_id INTO v_role_id FROM ROLES WHERE role_name = 'DEVOPS';
        ELSIF v_counter <= 255 THEN
            SELECT role_id INTO v_role_id FROM ROLES WHERE role_name = 'DBA';
        ELSIF v_counter <= 260 THEN
            SELECT role_id INTO v_role_id FROM ROLES WHERE role_name = 'NETWORK_ADMIN';
        ELSIF v_counter <= 265 THEN
            SELECT role_id INTO v_role_id FROM ROLES WHERE role_name = 'FINANCE_MANAGER';
        ELSIF v_counter <= 270 THEN
            SELECT role_id INTO v_role_id FROM ROLES WHERE role_name = 'COMPLIANCE_OFFICER';
        ELSIF v_counter <= 290 THEN
            SELECT role_id INTO v_role_id FROM ROLES WHERE role_name = 'VIEWER';
        ELSE
            SELECT role_id INTO v_role_id FROM ROLES WHERE role_name = 'GUEST';
        END IF;
        
        INSERT INTO USER_ROLES (user_id, role_id, assigned_by)
        VALUES (u.user_id, v_role_id, v_admin_id);
    END LOOP;
    COMMIT;
END;
/

-- ══════════════════════════════════════════════════════════
-- PART 6: ربط الأدوار بالصلاحيات (كل دور يأخذ صلاحياته)
-- ══════════════════════════════════════════════════════════

-- SUPER_ADMIN: كل الصلاحيات
INSERT INTO ROLE_PERMISSIONS (role_id, permission_id)
SELECT (SELECT role_id FROM ROLES WHERE role_name='SUPER_ADMIN'), permission_id FROM PERMISSIONS;

-- ADMIN: كل الصلاحيات ما عدا CONFIG_UPDATE
INSERT INTO ROLE_PERMISSIONS (role_id, permission_id)
SELECT (SELECT role_id FROM ROLES WHERE role_name='ADMIN'), permission_id FROM PERMISSIONS
WHERE permission_code NOT IN ('CONFIG_UPDATE');

-- SECURITY_MANAGER
INSERT INTO ROLE_PERMISSIONS (role_id, permission_id)
SELECT (SELECT role_id FROM ROLES WHERE role_name='SECURITY_MANAGER'), permission_id FROM PERMISSIONS
WHERE permission_code IN ('USER_READ','USER_UPDATE','ROLE_READ','ROLE_ASSIGN','LOG_READ','LOG_EXPORT','LOG_ANALYZE','POLICY_CREATE','POLICY_READ','POLICY_UPDATE','SESSION_READ','SESSION_KILL','SESSION_AUDIT','MFA_MANAGE','MFA_READ','AUDIT_READ','AUDIT_EXPORT','REPORT_VIEW','REPORT_EXPORT');

-- SECURITY_ANALYST
INSERT INTO ROLE_PERMISSIONS (role_id, permission_id)
SELECT (SELECT role_id FROM ROLES WHERE role_name='SECURITY_ANALYST'), permission_id FROM PERMISSIONS
WHERE permission_code IN ('USER_READ','LOG_READ','LOG_EXPORT','LOG_ANALYZE','POLICY_READ','SESSION_READ','SESSION_AUDIT','AUDIT_READ','REPORT_VIEW','REPORT_EXPORT');

-- AUDITOR
INSERT INTO ROLE_PERMISSIONS (role_id, permission_id)
SELECT (SELECT role_id FROM ROLES WHERE role_name='AUDITOR'), permission_id FROM PERMISSIONS
WHERE permission_code IN ('USER_READ','ROLE_READ','LOG_READ','LOG_EXPORT','AUDIT_READ','AUDIT_EXPORT','AUDIT_ARCHIVE','REPORT_VIEW','REPORT_EXPORT');

-- MANAGER
INSERT INTO ROLE_PERMISSIONS (role_id, permission_id)
SELECT (SELECT role_id FROM ROLES WHERE role_name='MANAGER'), permission_id FROM PERMISSIONS
WHERE permission_code IN ('USER_CREATE','USER_READ','USER_UPDATE','ROLE_READ','ROLE_ASSIGN','LOG_READ','POLICY_READ','SESSION_READ','REPORT_VIEW','REPORT_EXPORT');

-- DEVELOPER
INSERT INTO ROLE_PERMISSIONS (role_id, permission_id)
SELECT (SELECT role_id FROM ROLES WHERE role_name='DEVELOPER'), permission_id FROM PERMISSIONS
WHERE permission_code IN ('USER_READ','ROLE_READ','POLICY_READ','CONFIG_READ','REPORT_VIEW');

-- SUPPORT
INSERT INTO ROLE_PERMISSIONS (role_id, permission_id)
SELECT (SELECT role_id FROM ROLES WHERE role_name='SUPPORT'), permission_id FROM PERMISSIONS
WHERE permission_code IN ('USER_READ','LOG_READ','SESSION_READ','REPORT_VIEW');

-- VIEWER
INSERT INTO ROLE_PERMISSIONS (role_id, permission_id)
SELECT (SELECT role_id FROM ROLES WHERE role_name='VIEWER'), permission_id FROM PERMISSIONS
WHERE permission_code IN ('USER_READ','ROLE_READ','POLICY_READ','REPORT_VIEW');

-- HR_MANAGER
INSERT INTO ROLE_PERMISSIONS (role_id, permission_id)
SELECT (SELECT role_id FROM ROLES WHERE role_name='HR_MANAGER'), permission_id FROM PERMISSIONS
WHERE permission_code IN ('USER_CREATE','USER_READ','USER_UPDATE','ROLE_READ','REPORT_VIEW','REPORT_EXPORT');

-- DEVOPS
INSERT INTO ROLE_PERMISSIONS (role_id, permission_id)
SELECT (SELECT role_id FROM ROLES WHERE role_name='DEVOPS'), permission_id FROM PERMISSIONS
WHERE permission_code IN ('USER_READ','ROLE_READ','CONFIG_READ','CONFIG_UPDATE','LOG_READ','REPORT_VIEW');

-- DBA
INSERT INTO ROLE_PERMISSIONS (role_id, permission_id)
SELECT (SELECT role_id FROM ROLES WHERE role_name='DBA'), permission_id FROM PERMISSIONS
WHERE permission_code IN ('USER_READ','ROLE_READ','CONFIG_READ','CONFIG_UPDATE','AUDIT_READ','AUDIT_EXPORT','REPORT_VIEW');

-- NETWORK_ADMIN
INSERT INTO ROLE_PERMISSIONS (role_id, permission_id)
SELECT (SELECT role_id FROM ROLES WHERE role_name='NETWORK_ADMIN'), permission_id FROM PERMISSIONS
WHERE permission_code IN ('USER_READ','CONFIG_READ','CONFIG_UPDATE','LOG_READ','SESSION_READ','REPORT_VIEW');

-- FINANCE_MANAGER
INSERT INTO ROLE_PERMISSIONS (role_id, permission_id)
SELECT (SELECT role_id FROM ROLES WHERE role_name='FINANCE_MANAGER'), permission_id FROM PERMISSIONS
WHERE permission_code IN ('USER_READ','REPORT_VIEW','REPORT_EXPORT','REPORT_CREATE');

-- COMPLIANCE_OFFICER
INSERT INTO ROLE_PERMISSIONS (role_id, permission_id)
SELECT (SELECT role_id FROM ROLES WHERE role_name='COMPLIANCE_OFFICER'), permission_id FROM PERMISSIONS
WHERE permission_code IN ('USER_READ','ROLE_READ','LOG_READ','LOG_EXPORT','AUDIT_READ','AUDIT_EXPORT','POLICY_READ','REPORT_VIEW','REPORT_EXPORT');

-- GUEST
INSERT INTO ROLE_PERMISSIONS (role_id, permission_id)
SELECT (SELECT role_id FROM ROLES WHERE role_name='GUEST'), permission_id FROM PERMISSIONS
WHERE permission_code IN ('REPORT_VIEW');
COMMIT;

-- ══════════════════════════════════════════════════════════
-- PART 7: السياسات الأمنية (15 سياسة)
-- ══════════════════════════════════════════════════════════
INSERT INTO POLICIES (policy_name, condition_type, condition_value) VALUES ('Office Network Only', 'IP_RANGE', '192.168.1.0/24');
INSERT INTO POLICIES (policy_name, condition_type, condition_value) VALUES ('Business Hours Access', 'TIME_RANGE', '08:00-18:00');
INSERT INTO POLICIES (policy_name, condition_type, condition_value) VALUES ('Max Login Attempts', 'THRESHOLD', '5');
INSERT INTO POLICIES (policy_name, condition_type, condition_value) VALUES ('MFA Required for Admins', 'MFA_REQUIRED', 'ADMIN');
INSERT INTO POLICIES (policy_name, condition_type, condition_value) VALUES ('MFA Required for Managers', 'MFA_REQUIRED', 'MANAGER');
INSERT INTO POLICIES (policy_name, condition_type, condition_value) VALUES ('Session Timeout', 'TIMEOUT', '30_minutes');
INSERT INTO POLICIES (policy_name, condition_type, condition_value) VALUES ('Password Expiry', 'PASSWORD_AGE', '90_days');
INSERT INTO POLICIES (policy_name, condition_type, condition_value) VALUES ('VPN Required for Remote', 'VPN_REQUIRED', 'Remote_Users');
INSERT INTO POLICIES (policy_name, condition_type, condition_value) VALUES ('Block Tor Exit Nodes', 'GEO_BLOCK', 'Tor_Network');
INSERT INTO POLICIES (policy_name, condition_type, condition_value) VALUES ('Weekend Access Restriction', 'TIME_RANGE', 'Sat-Sun-Disabled');
INSERT INTO POLICIES (policy_name, condition_type, condition_value) VALUES ('Account Lockout', 'THRESHOLD', 'Lock_after_3_failures');
INSERT INTO POLICIES (policy_name, condition_type, condition_value) VALUES ('Strong Password Policy', 'PASSWORD_COMPLEXITY', 'Min_12_Chars_Mixed');
INSERT INTO POLICIES (policy_name, condition_type, condition_value) VALUES ('Idle Timeout', 'TIMEOUT', '15_minutes_idle');
INSERT INTO POLICIES (policy_name, condition_type, condition_value) VALUES ('Concurrent Sessions Limit', 'THRESHOLD', 'Max_3_sessions');
INSERT INTO POLICIES (policy_name, condition_type, condition_value) VALUES ('Sensitive Data Access Logging', 'AUDIT', 'All_Access_Logged');
COMMIT;

-- ══════════════════════════════════════════════════════════
-- PART 8: رموز MFA (~150 مستخدم)
-- ══════════════════════════════════════════════════════════
DECLARE
    v_counter NUMBER := 0;
BEGIN
    FOR u IN (SELECT user_id FROM "User" ORDER BY user_id) LOOP
        v_counter := v_counter + 1;
        
        -- أول 150 مستخدم عندهم MFA
        IF v_counter <= 150 THEN
            INSERT INTO MFA_TOKENS (user_id, token_code, expires_at, is_used)
            VALUES (u.user_id, 
                    LPAD(TRUNC(DBMS_RANDOM.VALUE(100000, 999999)), 6, '0'),
                    SYSDATE + 5/1440,
                    CASE WHEN MOD(v_counter, 3) = 0 THEN 'Y' ELSE 'N' END);
        END IF;
    END LOOP;
    COMMIT;
END;
/

-- ══════════════════════════════════════════════════════════
-- PART 9: سجل الوصول (~800 سجل)
-- ══════════════════════════════════════════════════════════
DECLARE
    v_counter NUMBER := 0;
    v_ip VARCHAR2(45);
BEGIN
    FOR u IN (SELECT user_id FROM "User" ORDER BY user_id) LOOP
        v_counter := v_counter + 1;
        
        -- تسجيل دخول ناجح
        v_ip := '192.168.1.' || TRUNC(DBMS_RANDOM.VALUE(10, 200));
        INSERT INTO ACCESS_LOGS (user_id, action, status, ip_address, user_agent, details, log_time)
        VALUES (u.user_id, 'LOGIN', 'SUCCESS', v_ip, 'Chrome/120.0', 
                'Successful login', SYSDATE - DBMS_RANDOM.VALUE(1, 30));
        
        -- 30% عندهم محاولة فاشلة واحدة
        IF MOD(v_counter, 3) = 0 THEN
            INSERT INTO ACCESS_LOGS (user_id, action, status, ip_address, user_agent, details, log_time)
            VALUES (u.user_id, 'LOGIN', 'FAILED', v_ip, 'Chrome/120.0', 
                    'Wrong password', SYSDATE - DBMS_RANDOM.VALUE(1, 30));
        END IF;
        
        -- 10% عندهم Brute Force (5 محاولات فاشلة من IP مشبوه)
        IF MOD(v_counter, 10) = 0 THEN
            FOR i IN 1..5 LOOP
                INSERT INTO ACCESS_LOGS (user_id, action, status, ip_address, user_agent, details, log_time)
                VALUES (u.user_id, 'LOGIN', 'FAILED', 
                        '45.33.12.' || TRUNC(DBMS_RANDOM.VALUE(1, 255)),
                        'Unknown', 'Brute force attempt #' || i, 
                        SYSDATE - DBMS_RANDOM.VALUE(1, 5));
            END LOOP;
        END IF;
        
        -- بعض المستخدمين عندهم عمليات إدارية
        IF v_counter <= 40 THEN
            INSERT INTO ACCESS_LOGS (user_id, action, status, ip_address, user_agent, details, log_time)
            VALUES (u.user_id, 'CREATE_USER', 'SUCCESS', v_ip, 'Chrome/120.0', 
                    'Created new user', SYSDATE - DBMS_RANDOM.VALUE(1, 20));
        END IF;
        
        -- بعض المستخدمين عندهم تسجيل خروج
        IF MOD(v_counter, 4) = 0 THEN
            INSERT INTO ACCESS_LOGS (user_id, action, status, ip_address, user_agent, details, log_time)
            VALUES (u.user_id, 'LOGOUT', 'SUCCESS', v_ip, 'Chrome/120.0', 
                    'User logout', SYSDATE - DBMS_RANDOM.VALUE(1, 20));
        END IF;
    END LOOP;
    COMMIT;
END;
/

-- ══════════════════════════════════════════════════════════
-- PART 10: الجلسات النشطة (~120 جلسة)
-- ══════════════════════════════════════════════════════════
DECLARE
    v_counter NUMBER := 0;
BEGIN
    FOR u IN (SELECT user_id FROM "User" WHERE is_active = 'Y' ORDER BY user_id) LOOP
        v_counter := v_counter + 1;
        
        -- 40% من المستخدمين النشطين عندهم جلسات نشطة
        IF MOD(v_counter, 5) IN (1, 2) THEN
            INSERT INTO SESSIONS (user_id, session_token, ip_address, login_time, is_active)
            VALUES (u.user_id, 
                    'TKN_' || u.user_id || '_' || TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISSFF'),
                    '192.168.1.' || TRUNC(DBMS_RANDOM.VALUE(10, 200)),
                    SYSDATE - DBMS_RANDOM.VALUE(0, 2),
                    'Y');
        END IF;
    END LOOP;
    COMMIT;
END;
/

-- ══════════════════════════════════════════════════════════
-- PART 11: التحقق النهائي
-- ══════════════════════════════════════════════════════════
SELECT 'Users: ' || COUNT(*) FROM "User"
UNION ALL SELECT 'Roles: ' || COUNT(*) FROM ROLES
UNION ALL SELECT 'Permissions: ' || COUNT(*) FROM PERMISSIONS
UNION ALL SELECT 'User_Roles: ' || COUNT(*) FROM USER_ROLES
UNION ALL SELECT 'Role_Permissions: ' || COUNT(*) FROM ROLE_PERMISSIONS
UNION ALL SELECT 'Policies: ' || COUNT(*) FROM POLICIES
UNION ALL SELECT 'MFA_Tokens: ' || COUNT(*) FROM MFA_TOKENS
UNION ALL SELECT 'Access_Logs: ' || COUNT(*) FROM ACCESS_LOGS
UNION ALL SELECT 'Sessions: ' || COUNT(*) FROM SESSIONS
UNION ALL SELECT 'Audit_Trail: ' || COUNT(*) FROM AUDIT_TRAIL;