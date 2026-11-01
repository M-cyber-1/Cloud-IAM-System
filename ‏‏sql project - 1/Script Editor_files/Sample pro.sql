-- ==========================================
-- IAM SYSTEM - SAMPLE DATA (CLEAN VERSION)
-- Author: Mohammed Al-Hattami
-- ==========================================

-- ==========================================
-- 0. تنظيف البيانات القديمة
-- ==========================================
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

-- ==========================================
-- 1. المستخدمون (15 مستخدم)
-- ==========================================
INSERT INTO "User" (username, email, password_hash, full_name, is_active) VALUES ('admin', 'admin@iam.com', 'admin@123', 'Mohammed Al-Hattami', 'Y');
INSERT INTO "User" (username, email, password_hash, full_name, is_active) VALUES ('analyst1', 'sara@iam.com', 'sara@123', 'Sara Ahmed', 'Y');
INSERT INTO "User" (username, email, password_hash, full_name, is_active) VALUES ('analyst2', 'ali@iam.com', 'ali@123', 'Ali Saleh', 'Y');
INSERT INTO "User" (username, email, password_hash, full_name, is_active) VALUES ('analyst3', 'fatima@iam.com', 'fatima@123', 'Fatima Nasser', 'Y');
INSERT INTO "User" (username, email, password_hash, full_name, is_active) VALUES ('viewer1', 'omar@iam.com', 'omar@123', 'Omar Khalid', 'Y');
INSERT INTO "User" (username, email, password_hash, full_name, is_active) VALUES ('viewer2', 'hana@iam.com', 'hana@123', 'Hana Salem', 'Y');
INSERT INTO "User" (username, email, password_hash, full_name, is_active) VALUES ('auditor1', 'khalid@iam.com', 'khalid@123', 'Khalid Yousef', 'Y');
INSERT INTO "User" (username, email, password_hash, full_name, is_active) VALUES ('auditor2', 'maryam@iam.com', 'maryam@123', 'Maryam Hussein', 'Y');
INSERT INTO "User" (username, email, password_hash, full_name, is_active) VALUES ('manager1', 'abdullah@iam.com', 'abdullah@123', 'Abdullah Omar', 'Y');
INSERT INTO "User" (username, email, password_hash, full_name, is_active) VALUES ('manager2', 'noor@iam.com', 'noor@123', 'Noor Al-Hadi', 'Y');
INSERT INTO "User" (username, email, password_hash, full_name, is_active) VALUES ('dev1', 'dev1@iam.com', 'dev1@123', 'Yasser Mohammed', 'Y');
INSERT INTO "User" (username, email, password_hash, full_name, is_active) VALUES ('dev2', 'dev2@iam.com', 'dev2@123', 'Aisha Ibrahim', 'Y');
INSERT INTO "User" (username, email, password_hash, full_name, is_active) VALUES ('guest1', 'guest1@iam.com', 'guest1@123', 'Guest User 1', 'N');
INSERT INTO "User" (username, email, password_hash, full_name, is_active) VALUES ('guest2', 'guest2@iam.com', 'guest2@123', 'Guest User 2', 'N');
INSERT INTO "User" (username, email, password_hash, full_name, is_active) VALUES ('support1', 'support@iam.com', 'support@123', 'Support Team', 'Y');
COMMIT;

-- ==========================================
-- 2. الأدوار (6 أدوار)
-- ==========================================
INSERT INTO ROLES (role_name, description) VALUES ('ADMIN', 'Full system administrator with all permissions');
INSERT INTO ROLES (role_name, description) VALUES ('SECURITY_ANALYST', 'Analyzes security logs and incidents');
INSERT INTO ROLES (role_name, description) VALUES ('AUDITOR', 'Reviews audit trails and compliance');
INSERT INTO ROLES (role_name, description) VALUES ('MANAGER', 'Manages users and resources');
INSERT INTO ROLES (role_name, description) VALUES ('DEVELOPER', 'Develops and deploys applications');
INSERT INTO ROLES (role_name, description) VALUES ('VIEWER', 'Read-only access to dashboards');
COMMIT;

-- ==========================================
-- 3. الصلاحيات (15 صلاحية)
-- ==========================================
INSERT INTO PERMISSIONS (permission_code, description, resource_name, action) VALUES ('USER_CREATE', 'Create new users', 'Users', 'WRITE');
INSERT INTO PERMISSIONS (permission_code, description, resource_name, action) VALUES ('USER_READ', 'View user details', 'Users', 'READ');
INSERT INTO PERMISSIONS (permission_code, description, resource_name, action) VALUES ('USER_UPDATE', 'Update user information', 'Users', 'WRITE');
INSERT INTO PERMISSIONS (permission_code, description, resource_name, action) VALUES ('USER_DELETE', 'Delete users', 'Users', 'DELETE');
INSERT INTO PERMISSIONS (permission_code, description, resource_name, action) VALUES ('ROLE_ASSIGN', 'Assign roles to users', 'Roles', 'WRITE');
INSERT INTO PERMISSIONS (permission_code, description, resource_name, action) VALUES ('ROLE_READ', 'View roles', 'Roles', 'READ');
INSERT INTO PERMISSIONS (permission_code, description, resource_name, action) VALUES ('LOG_READ', 'View access logs', 'Logs', 'READ');
INSERT INTO PERMISSIONS (permission_code, description, resource_name, action) VALUES ('LOG_DELETE', 'Delete old logs', 'Logs', 'DELETE');
INSERT INTO PERMISSIONS (permission_code, description, resource_name, action) VALUES ('AUDIT_READ', 'View audit trail', 'Audit', 'READ');
INSERT INTO PERMISSIONS (permission_code, description, resource_name, action) VALUES ('POLICY_CREATE', 'Create security policies', 'Policies', 'WRITE');
INSERT INTO PERMISSIONS (permission_code, description, resource_name, action) VALUES ('POLICY_READ', 'View policies', 'Policies', 'READ');
INSERT INTO PERMISSIONS (permission_code, description, resource_name, action) VALUES ('POLICY_UPDATE', 'Update policies', 'Policies', 'WRITE');
INSERT INTO PERMISSIONS (permission_code, description, resource_name, action) VALUES ('SESSION_READ', 'View active sessions', 'Sessions', 'READ');
INSERT INTO PERMISSIONS (permission_code, description, resource_name, action) VALUES ('SESSION_KILL', 'Terminate sessions', 'Sessions', 'DELETE');
INSERT INTO PERMISSIONS (permission_code, description, resource_name, action) VALUES ('MFA_MANAGE', 'Manage MFA tokens', 'MFA', 'WRITE');
COMMIT;

-- ==========================================
-- 4. ربط المستخدمين بالأدوار (USER_ROLES)
-- ==========================================
INSERT INTO USER_ROLES (user_id, role_id, assigned_by) VALUES 
((SELECT user_id FROM "User" WHERE username='admin'), (SELECT role_id FROM ROLES WHERE role_name='ADMIN'), (SELECT user_id FROM "User" WHERE username='admin'));

INSERT INTO USER_ROLES (user_id, role_id, assigned_by) VALUES 
((SELECT user_id FROM "User" WHERE username='analyst1'), (SELECT role_id FROM ROLES WHERE role_name='SECURITY_ANALYST'), (SELECT user_id FROM "User" WHERE username='admin'));
INSERT INTO USER_ROLES (user_id, role_id, assigned_by) VALUES 
((SELECT user_id FROM "User" WHERE username='analyst2'), (SELECT role_id FROM ROLES WHERE role_name='SECURITY_ANALYST'), (SELECT user_id FROM "User" WHERE username='admin'));
INSERT INTO USER_ROLES (user_id, role_id, assigned_by) VALUES 
((SELECT user_id FROM "User" WHERE username='analyst3'), (SELECT role_id FROM ROLES WHERE role_name='SECURITY_ANALYST'), (SELECT user_id FROM "User" WHERE username='admin'));

INSERT INTO USER_ROLES (user_id, role_id, assigned_by) VALUES 
((SELECT user_id FROM "User" WHERE username='auditor1'), (SELECT role_id FROM ROLES WHERE role_name='AUDITOR'), (SELECT user_id FROM "User" WHERE username='admin'));
INSERT INTO USER_ROLES (user_id, role_id, assigned_by) VALUES 
((SELECT user_id FROM "User" WHERE username='auditor2'), (SELECT role_id FROM ROLES WHERE role_name='AUDITOR'), (SELECT user_id FROM "User" WHERE username='admin'));

INSERT INTO USER_ROLES (user_id, role_id, assigned_by) VALUES 
((SELECT user_id FROM "User" WHERE username='manager1'), (SELECT role_id FROM ROLES WHERE role_name='MANAGER'), (SELECT user_id FROM "User" WHERE username='admin'));
INSERT INTO USER_ROLES (user_id, role_id, assigned_by) VALUES 
((SELECT user_id FROM "User" WHERE username='manager2'), (SELECT role_id FROM ROLES WHERE role_name='MANAGER'), (SELECT user_id FROM "User" WHERE username='admin'));

INSERT INTO USER_ROLES (user_id, role_id, assigned_by) VALUES 
((SELECT user_id FROM "User" WHERE username='dev1'), (SELECT role_id FROM ROLES WHERE role_name='DEVELOPER'), (SELECT user_id FROM "User" WHERE username='admin'));
INSERT INTO USER_ROLES (user_id, role_id, assigned_by) VALUES 
((SELECT user_id FROM "User" WHERE username='dev2'), (SELECT role_id FROM ROLES WHERE role_name='DEVELOPER'), (SELECT user_id FROM "User" WHERE username='admin'));

INSERT INTO USER_ROLES (user_id, role_id, assigned_by) VALUES 
((SELECT user_id FROM "User" WHERE username='viewer1'), (SELECT role_id FROM ROLES WHERE role_name='VIEWER'), (SELECT user_id FROM "User" WHERE username='admin'));
INSERT INTO USER_ROLES (user_id, role_id, assigned_by) VALUES 
((SELECT user_id FROM "User" WHERE username='viewer2'), (SELECT role_id FROM ROLES WHERE role_name='VIEWER'), (SELECT user_id FROM "User" WHERE username='admin'));
INSERT INTO USER_ROLES (user_id, role_id, assigned_by) VALUES 
((SELECT user_id FROM "User" WHERE username='support1'), (SELECT role_id FROM ROLES WHERE role_name='VIEWER'), (SELECT user_id FROM "User" WHERE username='admin'));

INSERT INTO USER_ROLES (user_id, role_id, assigned_by) VALUES 
((SELECT user_id FROM "User" WHERE username='admin'), (SELECT role_id FROM ROLES WHERE role_name='MANAGER'), (SELECT user_id FROM "User" WHERE username='admin'));
INSERT INTO USER_ROLES (user_id, role_id, assigned_by) VALUES 
((SELECT user_id FROM "User" WHERE username='analyst1'), (SELECT role_id FROM ROLES WHERE role_name='AUDITOR'), (SELECT user_id FROM "User" WHERE username='admin'));
COMMIT;

-- ==========================================
-- 5. ربط الأدوار بالصلاحيات (ROLE_PERMISSIONS)
-- ==========================================
-- ADMIN: كل الصلاحيات
INSERT INTO ROLE_PERMISSIONS (role_id, permission_id)
SELECT (SELECT role_id FROM ROLES WHERE role_name='ADMIN'), permission_id FROM PERMISSIONS;

-- SECURITY_ANALYST
INSERT INTO ROLE_PERMISSIONS (role_id, permission_id)
SELECT (SELECT role_id FROM ROLES WHERE role_name='SECURITY_ANALYST'), permission_id 
FROM PERMISSIONS WHERE permission_code IN ('LOG_READ', 'AUDIT_READ', 'POLICY_READ', 'SESSION_READ', 'USER_READ');

-- AUDITOR
INSERT INTO ROLE_PERMISSIONS (role_id, permission_id)
SELECT (SELECT role_id FROM ROLES WHERE role_name='AUDITOR'), permission_id 
FROM PERMISSIONS WHERE permission_code IN ('LOG_READ', 'AUDIT_READ', 'USER_READ');

-- MANAGER
INSERT INTO ROLE_PERMISSIONS (role_id, permission_id)
SELECT (SELECT role_id FROM ROLES WHERE role_name='MANAGER'), permission_id 
FROM PERMISSIONS WHERE permission_code IN ('USER_CREATE', 'USER_READ', 'USER_UPDATE', 'ROLE_ASSIGN', 'ROLE_READ');

-- DEVELOPER
INSERT INTO ROLE_PERMISSIONS (role_id, permission_id)
SELECT (SELECT role_id FROM ROLES WHERE role_name='DEVELOPER'), permission_id 
FROM PERMISSIONS WHERE permission_code IN ('USER_READ', 'ROLE_READ', 'POLICY_READ');

-- VIEWER
INSERT INTO ROLE_PERMISSIONS (role_id, permission_id)
SELECT (SELECT role_id FROM ROLES WHERE role_name='VIEWER'), permission_id 
FROM PERMISSIONS WHERE permission_code IN ('USER_READ', 'ROLE_READ', 'POLICY_READ');
COMMIT;

-- ==========================================
-- 6. السياسات الأمنية (8 سياسات)
-- ==========================================
INSERT INTO POLICIES (policy_name, condition_type, condition_value, is_active) VALUES ('Office Network Only', 'IP_RANGE', '192.168.1.0/24', 'Y');
INSERT INTO POLICIES (policy_name, condition_type, condition_value, is_active) VALUES ('Business Hours Access', 'TIME_RANGE', '08:00-18:00', 'Y');
INSERT INTO POLICIES (policy_name, condition_type, condition_value, is_active) VALUES ('Max Login Attempts', 'THRESHOLD', '5', 'Y');
INSERT INTO POLICIES (policy_name, condition_type, condition_value, is_active) VALUES ('MFA Required for Admins', 'MFA_REQUIRED', 'ADMIN', 'Y');
INSERT INTO POLICIES (policy_name, condition_type, condition_value, is_active) VALUES ('Session Timeout', 'TIMEOUT', '30_minutes', 'Y');
INSERT INTO POLICIES (policy_name, condition_type, condition_value, is_active) VALUES ('Block Foreign IPs', 'GEO_BLOCK', 'Non-Yemen', 'N');
INSERT INTO POLICIES (policy_name, condition_type, condition_value, is_active) VALUES ('Password Expiry', 'PASSWORD_AGE', '90_days', 'Y');
INSERT INTO POLICIES (policy_name, condition_type, condition_value, is_active) VALUES ('VPN Required for Remote', 'VPN_REQUIRED', 'Remote_Users', 'Y');
COMMIT;

-- ==========================================
-- 7. سجل الوصول (40 سجل)
-- ==========================================
INSERT INTO ACCESS_LOGS (user_id, action, status, ip_address, user_agent, details) VALUES 
((SELECT user_id FROM "User" WHERE username='admin'), 'LOGIN', 'SUCCESS', '192.168.1.10', 'Chrome/120.0', 'Admin login');
INSERT INTO ACCESS_LOGS (user_id, action, status, ip_address, user_agent, details) VALUES 
((SELECT user_id FROM "User" WHERE username='analyst1'), 'LOGIN', 'SUCCESS', '192.168.1.15', 'Firefox/121.0', 'Analyst login');
INSERT INTO ACCESS_LOGS (user_id, action, status, ip_address, user_agent, details) VALUES 
((SELECT user_id FROM "User" WHERE username='analyst2'), 'LOGIN', 'FAILED', '192.168.1.20', 'Chrome/120.0', 'Wrong password');
INSERT INTO ACCESS_LOGS (user_id, action, status, ip_address, user_agent, details) VALUES 
((SELECT user_id FROM "User" WHERE username='analyst2'), 'LOGIN', 'SUCCESS', '192.168.1.20', 'Chrome/120.0', 'Login after reset');
INSERT INTO ACCESS_LOGS (user_id, action, status, ip_address, user_agent, details) VALUES 
((SELECT user_id FROM "User" WHERE username='analyst3'), 'LOGIN', 'SUCCESS', '10.0.0.5', 'Edge/120.0', 'Remote login via VPN');
INSERT INTO ACCESS_LOGS (user_id, action, status, ip_address, user_agent, details) VALUES 
((SELECT user_id FROM "User" WHERE username='viewer1'), 'LOGIN', 'SUCCESS', '192.168.1.30', 'Chrome/120.0', 'Viewer login');
INSERT INTO ACCESS_LOGS (user_id, action, status, ip_address, user_agent, details) VALUES 
((SELECT user_id FROM "User" WHERE username='viewer2'), 'LOGIN', 'FAILED', '45.33.12.8', 'Unknown', 'Suspicious IP');
INSERT INTO ACCESS_LOGS (user_id, action, status, ip_address, user_agent, details) VALUES 
((SELECT user_id FROM "User" WHERE username='auditor1'), 'LOGIN', 'SUCCESS', '192.168.1.40', 'Firefox/121.0', 'Auditor login');
INSERT INTO ACCESS_LOGS (user_id, action, status, ip_address, user_agent, details) VALUES 
((SELECT user_id FROM "User" WHERE username='auditor2'), 'LOGIN', 'SUCCESS', '192.168.1.45', 'Chrome/120.0', 'Auditor login');
INSERT INTO ACCESS_LOGS (user_id, action, status, ip_address, user_agent, details) VALUES 
((SELECT user_id FROM "User" WHERE username='manager1'), 'LOGIN', 'SUCCESS', '192.168.1.50', 'Safari/17.0', 'Manager login');
INSERT INTO ACCESS_LOGS (user_id, action, status, ip_address, user_agent, details) VALUES 
((SELECT user_id FROM "User" WHERE username='manager2'), 'LOGIN', 'FAILED', '192.168.1.55', 'Chrome/120.0', 'Wrong password (3rd attempt)');
INSERT INTO ACCESS_LOGS (user_id, action, status, ip_address, user_agent, details) VALUES 
((SELECT user_id FROM "User" WHERE username='manager2'), 'LOGIN', 'SUCCESS', '192.168.1.55', 'Chrome/120.0', 'Login successful');
INSERT INTO ACCESS_LOGS (user_id, action, status, ip_address, user_agent, details) VALUES 
((SELECT user_id FROM "User" WHERE username='dev1'), 'LOGIN', 'SUCCESS', '10.0.0.100', 'VSCode/1.85', 'Developer login');
INSERT INTO ACCESS_LOGS (user_id, action, status, ip_address, user_agent, details) VALUES 
((SELECT user_id FROM "User" WHERE username='dev2'), 'LOGIN', 'SUCCESS', '10.0.0.101', 'VSCode/1.85', 'Developer login');
INSERT INTO ACCESS_LOGS (user_id, action, status, ip_address, user_agent, details) VALUES 
((SELECT user_id FROM "User" WHERE username='guest1'), 'LOGIN', 'FAILED', '203.0.113.5', 'Unknown', 'Account disabled');
INSERT INTO ACCESS_LOGS (user_id, action, status, ip_address, user_agent, details) VALUES 
((SELECT user_id FROM "User" WHERE username='guest2'), 'LOGIN', 'FAILED', '203.0.113.6', 'Unknown', 'Account disabled');
INSERT INTO ACCESS_LOGS (user_id, action, status, ip_address, user_agent, details) VALUES 
((SELECT user_id FROM "User" WHERE username='support1'), 'LOGIN', 'SUCCESS', '192.168.1.200', 'Chrome/120.0', 'Support login');

INSERT INTO ACCESS_LOGS (user_id, action, status, ip_address, user_agent, details) VALUES 
((SELECT user_id FROM "User" WHERE username='admin'), 'CREATE_USER', 'SUCCESS', '192.168.1.10', 'Chrome/120.0', 'Created user analyst1');
INSERT INTO ACCESS_LOGS (user_id, action, status, ip_address, user_agent, details) VALUES 
((SELECT user_id FROM "User" WHERE username='admin'), 'ASSIGN_ROLE', 'SUCCESS', '192.168.1.10', 'Chrome/120.0', 'Assigned ADMIN to user 1');
INSERT INTO ACCESS_LOGS (user_id, action, status, ip_address, user_agent, details) VALUES 
((SELECT user_id FROM "User" WHERE username='admin'), 'CREATE_POLICY', 'SUCCESS', '192.168.1.10', 'Chrome/120.0', 'Created policy: Max Login Attempts');
INSERT INTO ACCESS_LOGS (user_id, action, status, ip_address, user_agent, details) VALUES 
((SELECT user_id FROM "User" WHERE username='admin'), 'DELETE_USER', 'SUCCESS', '192.168.1.10', 'Chrome/120.0', 'Deleted old user');
INSERT INTO ACCESS_LOGS (user_id, action, status, ip_address, user_agent, details) VALUES 
((SELECT user_id FROM "User" WHERE username='admin'), 'EXPORT_LOGS', 'SUCCESS', '192.168.1.10', 'Chrome/120.0', 'Exported access logs');

INSERT INTO ACCESS_LOGS (user_id, action, status, ip_address, user_agent, details) VALUES 
((SELECT user_id FROM "User" WHERE username='analyst1'), 'VIEW_LOGS', 'SUCCESS', '192.168.1.15', 'Firefox/121.0', 'Reviewed login failures');
INSERT INTO ACCESS_LOGS (user_id, action, status, ip_address, user_agent, details) VALUES 
((SELECT user_id FROM "User" WHERE username='analyst1'), 'INVESTIGATE', 'SUCCESS', '192.168.1.15', 'Firefox/121.0', 'Investigated suspicious IP');
INSERT INTO ACCESS_LOGS (user_id, action, status, ip_address, user_agent, details) VALUES 
((SELECT user_id FROM "User" WHERE username='analyst2'), 'VIEW_LOGS', 'SUCCESS', '192.168.1.20', 'Chrome/120.0', 'Reviewed session logs');
INSERT INTO ACCESS_LOGS (user_id, action, status, ip_address, user_agent, details) VALUES 
((SELECT user_id FROM "User" WHERE username='analyst3'), 'INVESTIGATE', 'SUCCESS', '10.0.0.5', 'Edge/120.0', 'Analyzed threat pattern');

INSERT INTO ACCESS_LOGS (user_id, action, status, ip_address, user_agent, details) VALUES 
((SELECT user_id FROM "User" WHERE username='analyst1'), 'LOGIN', 'FAILED', '45.33.12.9', 'Unknown', 'Brute force attempt 1');
INSERT INTO ACCESS_LOGS (user_id, action, status, ip_address, user_agent, details) VALUES 
((SELECT user_id FROM "User" WHERE username='analyst1'), 'LOGIN', 'FAILED', '45.33.12.9', 'Unknown', 'Brute force attempt 2');
INSERT INTO ACCESS_LOGS (user_id, action, status, ip_address, user_agent, details) VALUES 
((SELECT user_id FROM "User" WHERE username='analyst1'), 'LOGIN', 'FAILED', '45.33.12.9', 'Unknown', 'Brute force attempt 3');
INSERT INTO ACCESS_LOGS (user_id, action, status, ip_address, user_agent, details) VALUES 
((SELECT user_id FROM "User" WHERE username='analyst1'), 'LOGIN', 'FAILED', '45.33.12.9', 'Unknown', 'Brute force attempt 4');
INSERT INTO ACCESS_LOGS (user_id, action, status, ip_address, user_agent, details) VALUES 
((SELECT user_id FROM "User" WHERE username='analyst1'), 'LOGIN', 'FAILED', '45.33.12.9', 'Unknown', 'Account locked');

INSERT INTO ACCESS_LOGS (user_id, action, status, ip_address, user_agent, details) VALUES 
((SELECT user_id FROM "User" WHERE username='admin'), 'LOGOUT', 'SUCCESS', '192.168.1.10', 'Chrome/120.0', 'Admin logout');
INSERT INTO ACCESS_LOGS (user_id, action, status, ip_address, user_agent, details) VALUES 
((SELECT user_id FROM "User" WHERE username='viewer1'), 'LOGOUT', 'SUCCESS', '192.168.1.30', 'Chrome/120.0', 'Viewer logout');
INSERT INTO ACCESS_LOGS (user_id, action, status, ip_address, user_agent, details) VALUES 
((SELECT user_id FROM "User" WHERE username='manager1'), 'LOGOUT', 'SUCCESS', '192.168.1.50', 'Safari/17.0', 'Manager logout');

INSERT INTO ACCESS_LOGS (user_id, action, status, ip_address, user_agent, details) VALUES 
((SELECT user_id FROM "User" WHERE username='auditor1'), 'AUDIT_REVIEW', 'SUCCESS', '192.168.1.40', 'Firefox/121.0', 'Reviewed Q1 audit');
INSERT INTO ACCESS_LOGS (user_id, action, status, ip_address, user_agent, details) VALUES 
((SELECT user_id FROM "User" WHERE username='auditor2'), 'AUDIT_REVIEW', 'SUCCESS', '192.168.1.45', 'Chrome/120.0', 'Compliance check');

INSERT INTO ACCESS_LOGS (user_id, action, status, ip_address, user_agent, details) VALUES 
((SELECT user_id FROM "User" WHERE username='analyst3'), 'LOGIN', 'FAILED', '8.8.8.8', 'Unknown', 'Blocked: Non-office IP');
INSERT INTO ACCESS_LOGS (user_id, action, status, ip_address, user_agent, details) VALUES 
((SELECT user_id FROM "User" WHERE username='viewer2'), 'LOGIN', 'FAILED', '8.8.4.4', 'Unknown', 'Blocked: Outside business hours');
COMMIT;

-- ==========================================
-- 8. رموز MFA (12 رمز)
-- ==========================================
INSERT INTO MFA_TOKENS (user_id, token_code, expires_at, is_used) VALUES 
((SELECT user_id FROM "User" WHERE username='admin'), '458721', SYSDATE + 5/1440, 'Y');
INSERT INTO MFA_TOKENS (user_id, token_code, expires_at, is_used) VALUES 
((SELECT user_id FROM "User" WHERE username='analyst1'), '739154', SYSDATE + 5/1440, 'Y');
INSERT INTO MFA_TOKENS (user_id, token_code, expires_at, is_used) VALUES 
((SELECT user_id FROM "User" WHERE username='analyst1'), '861203', SYSDATE + 5/1440, 'N');
INSERT INTO MFA_TOKENS (user_id, token_code, expires_at, is_used) VALUES 
((SELECT user_id FROM "User" WHERE username='analyst2'), '294517', SYSDATE + 5/1440, 'Y');
INSERT INTO MFA_TOKENS (user_id, token_code, expires_at, is_used) VALUES 
((SELECT user_id FROM "User" WHERE username='analyst3'), '617829', SYSDATE + 5/1440, 'Y');
INSERT INTO MFA_TOKENS (user_id, token_code, expires_at, is_used) VALUES 
((SELECT user_id FROM "User" WHERE username='manager1'), '405163', SYSDATE + 5/1440, 'Y');
INSERT INTO MFA_TOKENS (user_id, token_code, expires_at, is_used) VALUES 
((SELECT user_id FROM "User" WHERE username='manager1'), '928374', SYSDATE + 5/1440, 'N');
INSERT INTO MFA_TOKENS (user_id, token_code, expires_at, is_used) VALUES 
((SELECT user_id FROM "User" WHERE username='manager2'), '182936', SYSDATE + 5/1440, 'Y');
INSERT INTO MFA_TOKENS (user_id, token_code, expires_at, is_used) VALUES 
((SELECT user_id FROM "User" WHERE username='dev1'), '564738', SYSDATE + 5/1440, 'Y');
INSERT INTO MFA_TOKENS (user_id, token_code, expires_at, is_used) VALUES 
((SELECT user_id FROM "User" WHERE username='dev2'), '293847', SYSDATE + 5/1440, 'N');
INSERT INTO MFA_TOKENS (user_id, token_code, expires_at, is_used) VALUES 
((SELECT user_id FROM "User" WHERE username='auditor1'), '748291', SYSDATE + 5/1440, 'Y');
INSERT INTO MFA_TOKENS (user_id, token_code, expires_at, is_used) VALUES 
((SELECT user_id FROM "User" WHERE username='auditor2'), '102938', SYSDATE + 5/1440, 'Y');
COMMIT;

-- ==========================================
-- 9. الجلسات (10 جلسات)
-- ==========================================
INSERT INTO SESSIONS (user_id, session_token, ip_address, is_active) VALUES 
((SELECT user_id FROM "User" WHERE username='admin'), 'TKN_ADMIN_' || TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS'), '192.168.1.10', 'Y');
INSERT INTO SESSIONS (user_id, session_token, ip_address, is_active) VALUES 
((SELECT user_id FROM "User" WHERE username='analyst1'), 'TKN_SARA_' || TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS'), '192.168.1.15', 'Y');
INSERT INTO SESSIONS (user_id, session_token, ip_address, is_active) VALUES 
((SELECT user_id FROM "User" WHERE username='analyst2'), 'TKN_ALI_' || TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS'), '192.168.1.20', 'Y');
INSERT INTO SESSIONS (user_id, session_token, ip_address, is_active) VALUES 
((SELECT user_id FROM "User" WHERE username='analyst3'), 'TKN_FATIMA_' || TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS'), '10.0.0.5', 'Y');
INSERT INTO SESSIONS (user_id, session_token, ip_address, is_active) VALUES 
((SELECT user_id FROM "User" WHERE username='viewer1'), 'TKN_OMAR_' || TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS'), '192.168.1.30', 'N');
INSERT INTO SESSIONS (user_id, session_token, ip_address, is_active) VALUES 
((SELECT user_id FROM "User" WHERE username='auditor1'), 'TKN_KHALID_' || TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS'), '192.168.1.40', 'Y');
INSERT INTO SESSIONS (user_id, session_token, ip_address, is_active) VALUES 
((SELECT user_id FROM "User" WHERE username='manager1'), 'TKN_ABDULLAH_' || TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS'), '192.168.1.50', 'Y');
INSERT INTO SESSIONS (user_id, session_token, ip_address, is_active) VALUES 
((SELECT user_id FROM "User" WHERE username='dev1'), 'TKN_YASSER_' || TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS'), '10.0.0.100', 'Y');
INSERT INTO SESSIONS (user_id, session_token, ip_address, is_active) VALUES 
((SELECT user_id FROM "User" WHERE username='dev2'), 'TKN_AISHA_' || TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS'), '10.0.0.101', 'Y');
INSERT INTO SESSIONS (user_id, session_token, ip_address, is_active) VALUES 
((SELECT user_id FROM "User" WHERE username='support1'), 'TKN_SUPPORT_' || TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS'), '192.168.1.200', 'Y');
COMMIT;

-- ==========================================
-- 10. سجل التدقيق (6 سجلات يدوية)
-- ==========================================
INSERT INTO AUDIT_TRAIL (user_id, table_name, action, old_value, new_value, ip_address) VALUES 
((SELECT user_id FROM "User" WHERE username='admin'), 'ROLES', 'INSERT', NULL, 'ADMIN', '192.168.1.10');
INSERT INTO AUDIT_TRAIL (user_id, table_name, action, old_value, new_value, ip_address) VALUES 
((SELECT user_id FROM "User" WHERE username='admin'), 'PERMISSIONS', 'INSERT', NULL, 'USER_CREATE', '192.168.1.10');
INSERT INTO AUDIT_TRAIL (user_id, table_name, action, old_value, new_value, ip_address) VALUES 
((SELECT user_id FROM "User" WHERE username='admin'), 'POLICIES', 'INSERT', NULL, 'Max Login Attempts=5', '192.168.1.10');
INSERT INTO AUDIT_TRAIL (user_id, table_name, action, old_value, new_value, ip_address) VALUES 
((SELECT user_id FROM "User" WHERE username='admin'), 'USER_ROLES', 'INSERT', NULL, 'admin->ADMIN', '192.168.1.10');
INSERT INTO AUDIT_TRAIL (user_id, table_name, action, old_value, new_value, ip_address) VALUES 
((SELECT user_id FROM "User" WHERE username='analyst1'), 'ACCESS_LOGS', 'READ', NULL, 'Reviewed 50 logs', '192.168.1.15');
INSERT INTO AUDIT_TRAIL (user_id, table_name, action, old_value, new_value, ip_address) VALUES 
((SELECT user_id FROM "User" WHERE username='auditor1'), 'AUDIT_TRAIL', 'READ', NULL, 'Q1 Audit Review', '192.168.1.40');
COMMIT;

-- ==========================================
-- التحقق النهائي
-- ==========================================
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