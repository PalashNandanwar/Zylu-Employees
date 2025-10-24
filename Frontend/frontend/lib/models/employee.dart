// models/employee.dart
// For @required

// This enum must match your Spring Boot EmployeeStatus enum
enum EmployeeStatus { ACTIVE, INACTIVE }

class Employee {
  final int? id; // Nullable for new employees
  final String name;
  final DateTime joinDate;
  final EmployeeStatus status;
  final String position;
  final bool isFlagged; // This comes from your backend logic

  Employee({
    this.id,
    required this.name,
    required this.joinDate,
    required this.status,
    required this.position,
    required this.isFlagged,
  });

  // Factory to parse JSON from the API
  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      name: json['name'],
      joinDate: DateTime.parse(json['joinDate']),
      // Convert string from API to enum
      status: (json['status'] == 'ACTIVE')
          ? EmployeeStatus.ACTIVE
          : EmployeeStatus.INACTIVE,
      position: json['position'],
      isFlagged: json['flagged'], // 'flagged' property
    );
  }

  // Method to convert Employee object to JSON for POST/PUT
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'joinDate': joinDate.toIso8601String().split(
        'T',
      )[0], // Format as "YYYY-MM-DD"
      // Convert enum to string for API
      'status': status.toString().split('.').last,
      'position': position,
      // We don't send 'isFlagged' back to the server
    };
  }
}
