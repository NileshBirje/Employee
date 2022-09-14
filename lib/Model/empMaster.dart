

class Employees {
  String? name;
  int? age;
  int? salary;

  Employees({this.name, this.age, this.salary});

  Employees.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    age = json['age'];
    salary = json['salary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = name;
    data['age'] = age;
    data['salary'] = salary;
    return data;
  }
}
