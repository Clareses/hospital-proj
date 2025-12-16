PRAGMA foreign_keys = ON;

-- ======================
-- 医生表
-- ======================
CREATE TABLE Doctor (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    name        TEXT NOT NULL,
    department  TEXT NOT NULL,
    phone       TEXT,
    password    TEXT NOT NULL  -- 名文存储
);

-- ======================
-- 患者
-- ======================
CREATE TABLE Patient (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    name        TEXT NOT NULL,
    phone       TEXT,
    id_number   TEXT UNIQUE
);

-- ======================
-- 就诊记录
-- ======================
CREATE TABLE Visit (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    patient_id  INTEGER NOT NULL,
    doctor_id   INTEGER,                       -- 新增医生字段（可选）
    department  TEXT NOT NULL,
    number      INTEGER NOT NULL,
    status      TEXT NOT NULL CHECK (status IN ('waiting', 'in_progress', 'finished', 'dispensed')),
    created_at  TEXT NOT NULL,

    FOREIGN KEY (patient_id) REFERENCES Patient(id),
    FOREIGN KEY (doctor_id)  REFERENCES Doctor(id)
);

-- ======================
-- 电子病历
-- ======================
CREATE TABLE EMR (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    visit_id        INTEGER NOT NULL,
    chief_complaint TEXT,
    diagnosis       TEXT,
    treatment       TEXT,
    created_at      TEXT NOT NULL,

    FOREIGN KEY (visit_id) REFERENCES Visit(id)
);

-- ======================
-- 处方
-- ======================
CREATE TABLE Prescription (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    emr_id      INTEGER NOT NULL,
    status      TEXT NOT NULL CHECK (status IN ('pending', 'dispensed')),
    created_at  TEXT NOT NULL,

    FOREIGN KEY (emr_id) REFERENCES EMR(id)
);

-- ======================
-- 处方明细
-- ======================
CREATE TABLE PrescriptionItem (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    prescription_id INTEGER NOT NULL,
    drug_id         INTEGER NOT NULL,
    quantity        INTEGER NOT NULL,
    days            INTEGER NOT NULL,

    FOREIGN KEY (prescription_id) REFERENCES Prescription(id),
    FOREIGN KEY (drug_id) REFERENCES Drug(id)
);

-- ======================
-- 药品
-- ======================
CREATE TABLE Drug (
    id      INTEGER PRIMARY KEY AUTOINCREMENT,
    name    TEXT NOT NULL
);
