// providers/employee_provider.dart
import 'package:flutter/material.dart';
import '../models/employee.dart';
import '../services/api_service.dart';

class EmployeeProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Employee> _employees = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Employee> get employees => _employees;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  EmployeeProvider() {
    fetchEmployees(); // Load employees when the app starts
  }

  Future<void> fetchEmployees() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _employees = await _apiService.getEmployees();
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  // Returns true if successful, false if not
  Future<bool> addEmployee(Employee employee) async {
    try {
      Employee newEmployee = await _apiService.createEmployee(employee);
      _employees.add(newEmployee);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Returns true if successful, false if not
  Future<bool> editEmployee(
    Employee employee,
    String newPosition,
    EmployeeStatus newStatus,
  ) async {
    try {
      Employee updatedEmployee = await _apiService.updateEmployee(
        employee.id!,
        newPosition,
        newStatus,
      );
      // Find and replace the old employee in the list
      int index = _employees.indexWhere((emp) => emp.id == updatedEmployee.id);
      if (index != -1) {
        _employees[index] = updatedEmployee;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> removeEmployee(int id) async {
    try {
      await _apiService.deleteEmployee(id);
      _employees.removeWhere((emp) => emp.id == id);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
