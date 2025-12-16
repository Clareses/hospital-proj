### ER 图

```mermaid

erDiagram

    Patient ||--o{ Visit : "has"
    Doctor  ||--o{ Visit : "handles"

    Visit ||--|| EMR : "has"
    EMR   ||--o{ Prescription : "writes"
    Prescription ||--o{ PrescriptionItem : "contains"
    Drug ||--o{ PrescriptionItem : "used in"

    Patient {
        int id
        string name
        string phone
        string id_number
    }

    Doctor {
        int id
        string name
        string department
        string phone
        string password
    }

    Visit {
        int id
        int patient_id
        int doctor_id
        string department
        int number
        string status
        string created_at
    }

    EMR {
        int id
        int visit_id
        string chief_complaint
        string diagnosis
        string treatment
        string created_at
    }

    Prescription {
        int id
        int emr_id
        string status
        string created_at
    }

    PrescriptionItem {
        int id
        int prescription_id
        int drug_id
        int quantity
        int days
    }

    Drug {
        int id
        string name
    }

```


### 创建数据库和表


``` bash

cat ./0.create_database.sql | sqlite3 hospital.db 

```

### 注入假数据

``` bash

cat ./1.drugs.sql | sqlite3 hospital.db

cat ./2.doctor.sql | sqlite3 hospital.db

```


