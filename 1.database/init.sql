-- =====================================
-- Hospital DB 初始化脚本（SQLite 版本）
-- =====================================

PRAGMA foreign_keys = ON;

-- 删除旧表
DROP TABLE IF EXISTS record_drugs;
DROP TABLE IF EXISTS records;
DROP TABLE IF EXISTS doctors;
DROP TABLE IF EXISTS drugs;
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS users;

-- =====================================
-- users 表
-- =====================================
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    phone TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    password TEXT NOT NULL,
    role TEXT CHECK(role IN ('patient','doctor','admin')) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 插入管理员
INSERT INTO users (phone, name, password, role)
VALUES ('00000000', 'admin', 'admin', 'admin');

-- =====================================
-- departments 表
-- =====================================
CREATE TABLE departments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE
);

INSERT INTO departments (name) VALUES
('内科'), ('外科'), ('儿科'), ('妇科'), ('皮肤科');

-- =====================================
-- doctors 表
-- =====================================
CREATE TABLE doctors (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL UNIQUE,
    department_id INTEGER NOT NULL,
    phone TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (department_id) REFERENCES departments(id)
);

-- =====================================
-- drugs 表
-- =====================================
CREATE TABLE drugs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE,
    amount INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO drugs (name, amount) VALUES
('阿司匹林', 100),
('青霉素', 50),
('感冒灵', 200),
('退烧片', 150),
('止咳糖浆', 120),
('维生素C', 300),
('抗生素X', 80),
('消炎药Y', 90),
('眼药水', 60),
('胃药', 100);

-- =====================================
-- 插入医生用户及关联
-- =====================================
INSERT INTO users (phone, name, password, role) VALUES
('13800000001', '张伟', '123456', 'doctor'),
('13800000002', '王芳', '123456', 'doctor'),
('13800000003', '李强', '123456', 'doctor'),
('13800000004', '赵敏', '123456', 'doctor'),
('13800000005', '孙磊', '123456', 'doctor'),
('13800000006', '周丽', '123456', 'doctor'),
('13800000007', '吴杰', '123456', 'doctor'),
('13800000008', '郑倩', '123456', 'doctor'),
('13800000009', '冯涛', '123456', 'doctor'),
('13800000010', '陈静', '123456', 'doctor');

INSERT INTO doctors (user_id, department_id, phone) VALUES
(2,1,'13800000001'),
(3,2,'13800000002'),
(4,3,'13800000003'),
(5,1,'13800000004'),
(6,2,'13800000005'),
(7,3,'13800000006'),
(8,4,'13800000007'),
(9,5,'13800000008'),
(10,1,'13800000009'),
(11,2,'13800000010');

-- =====================================
-- 患者用户
-- =====================================
INSERT INTO users (phone, name, password, role) VALUES
('13900000001', '刘洋', '123456', 'patient'),
('13900000002', '陈晨', '123456', 'patient'),
('13900000003', '杨超', '123456', 'patient'),
('13900000004', '黄婷婷', '123456', 'patient'),
('13900000005', '林峰', '123456', 'patient'),
('13900000006', '周倩', '123456', 'patient'),
('13900000007', '徐磊', '123456', 'patient'),
('13900000008', '马丽', '123456', 'patient'),
('13900000009', '朱杰', '123456', 'patient'),
('13900000010', '何敏', '123456', 'patient'),
('13900000011', '高飞', '123456', 'patient'),
('13900000012', '魏婷', '123456', 'patient'),
('13900000013', '孔强', '123456', 'patient'),
('13900000014', '贾丽', '123456', 'patient'),
('13900000015', '邓浩', '123456', 'patient'),
('13900000016', '潘静', '123456', 'patient'),
('13900000017', '施伟', '123456', 'patient'),
('13900000018', '范丽', '123456', 'patient'),
('13900000019', '熊磊', '123456', 'patient'),
('13900000020', '赖婷', '123456', 'patient');

-- =====================================
-- records 表
-- =====================================
CREATE TABLE records (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    patient_id INTEGER NOT NULL,
    doctor_id INTEGER,
    department_id INTEGER NOT NULL,
    complaint TEXT NOT NULL,
    diagnosis TEXT,
    progress TEXT CHECK(progress IN ('pending','processing','done')) DEFAULT 'pending',
    visit_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES users(id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(id),
    FOREIGN KEY (department_id) REFERENCES departments(id)
);

-- =====================================
-- record_drugs 表
-- =====================================
CREATE TABLE record_drugs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    record_id INTEGER NOT NULL,
    drug_id INTEGER NOT NULL,
    amount INTEGER NOT NULL,
    FOREIGN KEY (record_id) REFERENCES records(id) ON DELETE CASCADE,
    FOREIGN KEY (drug_id) REFERENCES drugs(id)
);

-- =====================================
-- records 表数据
-- =====================================
INSERT INTO records
(patient_id, doctor_id, department_id, complaint, diagnosis, progress, visit_date)
VALUES
-- 内科
(12, 1, 1, '头晕乏力', '轻度贫血', 'done', '2025-12-01'),
(13, 4, 1, '胸闷心悸', '心律不齐', 'processing', '2025-12-02'),
(14, 9, 1, '胃部不适', '慢性胃炎', 'done', '2025-12-03'),

-- 外科
(15, 2, 2, '右腿疼痛', '肌肉拉伤', 'done', '2025-12-01'),
(16, 5, 2, '腹部疼痛', '阑尾炎', 'processing', '2025-12-02'),
(17, 10,2, '刀伤处理', '表皮创伤', 'done', '2025-12-04'),

-- 儿科
(18, 3, 3, '发烧咳嗽', '病毒性感冒', 'done', '2025-12-03'),
(19, 6, 3, '腹泻', '肠胃炎', 'processing', '2025-12-04'),

-- 妇科
(20, 7, 4, '月经不调', '内分泌失调', 'processing', '2025-12-05'),
(21, 7, 4, '下腹疼痛', '盆腔炎', 'done', '2025-12-06'),

-- 皮肤科
(22, 8, 5, '皮肤瘙痒', '湿疹', 'done', '2025-12-05'),
(23, 8, 5, '脸部红疹', '过敏性皮炎', 'pending', '2025-12-06');

-- =====================================
-- record_drugs 示例
-- =====================================
INSERT INTO record_drugs (record_id, drug_id, amount) VALUES
-- record 1
(1, 1, 10),   -- 阿司匹林
(1, 6, 20),   -- 维生素C

-- record 2
(2, 10, 15),  -- 胃药
(2, 1, 5),

-- record 3
(3, 10, 20),

-- record 4
(4, 8, 10),   -- 消炎药Y

-- record 5
(5, 7, 5),    -- 抗生素X
(5, 2, 5),    -- 青霉素

-- record 6
(6, 8, 8),

-- record 7
(7, 3, 10),   -- 感冒灵
(7, 4, 5),    -- 退烧片
(7, 5, 2),    -- 止咳糖浆

-- record 8
(8, 10, 10),

-- record 9
(9, 6, 15),

-- record 10
(10, 8, 10),

-- record 11
(11, 9, 2),   -- 眼药水

-- record 12
(12, 9, 2),
(12, 6, 10);
