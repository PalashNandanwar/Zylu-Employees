// services/api_service.dart
// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/employee.dart';

class ApiService {
  // !! MAKE SURE THIS IS YOUR BACKEND'S URL !!
  final String _baseUrl = "http://localhost:8081";

  final _headers = {'Content-Type': 'application/json; charset=UTF-8'};

  // GET /employees
  Future<List<Employee>> getEmployees() async {
    final response = await http.get(Uri.parse('$_baseUrl/employees'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Employee> employees = body
          .map((dynamic item) => Employee.fromJson(item))
          .toList();
      return employees;
    } else {
      throw Exception("Failed to load employees");
    }
  }

  // POST /createEmp
  Future<Employee> createEmployee(Employee employee) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/createEmp'),
      headers: _headers,
      body: jsonEncode(employee.toJson()),
    );

    if (response.statusCode == 201) {
      // 201 Created
      return Employee.fromJson(jsonDecode(response.body));
    } else {
      // Handle validation errors, e.g., "Employee name already exists"
      throw Exception(response.body);
    }
  }

  // PUT /employees/{id}
  // As discussed, we only allow updating position and status
  Future<Employee> updateEmployee(
    int id,
    String position,
    EmployeeStatus status,
  ) async {
    final body = jsonEncode({
      'position': position,
      'status': status.toString().split('.').last,
    });

    final response = await http.put(
      Uri.parse('$_baseUrl/employees/$id'),
      headers: _headers,
      body: body,
    );

    if (response.statusCode == 200) {
      return Employee.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to update employee: ${response.body}");
    }
  }

  // DELETE /employees/{id}
  Future<void> deleteEmployee(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/employees/$id'));

    if (response.statusCode != 204) {
      // 204 No Content
      throw Exception("Failed to delete employee");
    }
  }
}
