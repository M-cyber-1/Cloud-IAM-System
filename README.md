# Cloud Identity and Access Management System (IAM)

## 📌 Project Overview
This project is a comprehensive, secure **Identity and Access Management (IAM)** system built using **Oracle Database 21c** and **Oracle APEX**. It simulates real-world cloud security systems (like AWS IAM) to manage users, roles, permissions, and security policies securely. The project focuses on implementing a Zero Trust architecture through robust authentication and auditing mechanisms.

## 🛠️ Technologies Used
- **Database:** Oracle Database 21c (XE)
- **Development Platform:** Oracle APEX
- **Language:** SQL, PL/SQL
- **Security Features:** SHA-256 Hashing, MFA, RBAC, Audit Trails

## 🗄️ Database Schema (10 Tables)
1. `User` - Stores user credentials (Passwords are hashed).
2. `ROLES` - Defines user roles (Admin, Analyst, Auditor, etc.).
3. `PERMISSIONS` - Defines system permissions (Read, Write, Delete).
4. `USER_ROLES` - M:N junction table linking users to roles.
5. `ROLE_PERMISSIONS` - M:N junction table linking roles to permissions.
6. `POLICIES` - Security access rules (IP restrictions, time-based access).
7. `ACCESS_LOGS` - Tracks all login attempts (successful and failed).
8. `MFA_TOKENS` - OTP tokens for Two-Factor Authentication (2FA).
9. `SESSIONS` - Tracks active user sessions.
10. `AUDIT_TRAIL` - Automatically tracks database changes and updates.

## ⚙️ Key Features
- **Password Hashing:** Automated via Triggers using Hashing + Salt to prevent Rainbow Table attacks.
- **RBAC (Role-Based Access Control):** Limits privileges based on user roles, ensuring the Principle of Least Privilege.
- **MFA:** Two-factor authentication implementation for enhanced security.
- **Analytical Views:** Includes `V_USER_ACCESS`, `V_FAILED_LOGINS`, and `V_ACTIVE_SESSIONS` for easy reporting.
- **Complex Queries:** Utilizes Window Functions (`DENSE_RANK`, `LAG`) and CTEs to detect Brute Force attacks and analyze user behavior.

## 👨‍💻 Author
**Mohammed Abdulmalik  Al-Hattami**  
Cybersecurity Student | Community College of Sana'a
