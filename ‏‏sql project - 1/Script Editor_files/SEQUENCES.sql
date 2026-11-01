-- ==========================================
-- SEQUENCES FOR IAM PROJECT
-- ==========================================

-- 1. Sequence للمستخدمين
CREATE SEQUENCE seq_users
    START WITH 100
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- 2. Sequence للأدوار
CREATE SEQUENCE seq_roles
    START WITH 100
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- 3. Sequence للصلاحيات
CREATE SEQUENCE seq_permissions
    START WITH 100
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- 4. Sequence للسياسات
CREATE SEQUENCE seq_policies
    START WITH 100
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- 5. Sequence لسجل الوصول
CREATE SEQUENCE seq_access_logs
    START WITH 1000
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- 6. Sequence لرموز MFA
CREATE SEQUENCE seq_mfa_tokens
    START WITH 100
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- 7. Sequence للجلسات
CREATE SEQUENCE seq_sessions
    START WITH 100
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- 8. Sequence لسجل التدقيق
CREATE SEQUENCE seq_audit_trail
    START WITH 100
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;




----------

SELECT SEQUENCE_NAME, LAST_NUMBER, INCREMENT_BY, CACHE_SIZE FROM user_sequences
WHERE SEQUENCE_NAME LIKE 'SEQ_%'
ORDER BY SEQUENCE_NAME;