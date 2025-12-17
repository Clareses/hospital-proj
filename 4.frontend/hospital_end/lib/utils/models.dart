class Patient {
  final String name;
  final int age;
  final String complaint;

  Patient(this.name, this.age, this.complaint);
}

class Doctor {
  final String name;
  final String phone;
  final String department;

  Doctor(this.name, this.phone, this.department);
}

class Drug {
  final String name;
  int count;

  Drug(this.name, this.count);
}
