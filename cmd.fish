#!/bin/fish

function generate_db
    echo "Generating database"
    cd 1.database
    cat ./init.sql | sqlite3 ./hospital.db
    cd ..
end

function start_backend
    echo "Starting backend"
    cd 3.backend
    mkdir instance
    cp ../1.database/hospital.db ./instance/hospital.db
    uv run app.py &> .srv.log
    cd ..
end

function start_student_cli
    echo "Starting student cli"
    cd ./4.frontend/student_end/
    flutter run &> .student.log
    cd ../..
end

