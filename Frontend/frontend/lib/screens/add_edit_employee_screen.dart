// screens/add_edit_employee_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/employee.dart';
import '../providers/employee_provider.dart';

class AddEditEmployeeScreen extends StatefulWidget {
  // If employee is null, we are in "add" mode
  // If employee is not null, we are in "edit" mode
  final Employee? employee;

  const AddEditEmployeeScreen({super.key, this.employee});

  @override
  State<AddEditEmployeeScreen> createState() => _AddEditEmployeeScreenState();
}

class _AddEditEmployeeScreenState extends State<AddEditEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  bool get _isEditMode => widget.employee != null;

  // Form fields
  late TextEditingController _nameController;
  late TextEditingController _positionController;
  DateTime? _joinDate;
  EmployeeStatus _status = EmployeeStatus.ACTIVE;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.employee?.name);
    _positionController = TextEditingController(
      text: widget.employee?.position,
    );
    _joinDate = widget.employee?.joinDate;
    _status = widget.employee?.status ?? EmployeeStatus.ACTIVE;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _positionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _joinDate ?? DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _joinDate) {
      setState(() {
        _joinDate = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return; // Invalid form
    }

    // Extra validation
    if (_joinDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a join date'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final provider = Provider.of<EmployeeProvider>(context, listen: false);
    bool success = false;

    try {
      if (_isEditMode) {
        // --- EDIT LOGIC ---
        // As discussed, we only send the fields that can be changed
        success = await provider.editEmployee(
          widget.employee!,
          _positionController.text.trim(),
          _status,
        );
      } else {
        // --- ADD LOGIC ---
        final newEmployee = Employee(
          name: _nameController.text.trim(),
          position: _positionController.text.trim(),
          joinDate: _joinDate!,
          status: _status,
          isFlagged: false, // Server will calculate this, default to false
        );
        success = await provider.addEmployee(newEmployee);
      }

      if (mounted) {
        if (success) {
          Navigator.of(context).pop(); // Go back to the list
        } else {
          // Show the validation error from the backend
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Error: ${provider.errorMessage ?? 'Failed to save employee'}",
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Employee' : 'Add Employee'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  // --- Name Field ---
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                    readOnly:
                        _isEditMode, // Name cannot be changed in edit mode
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                        ? 'Name is required'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // --- Position Field ---
                  TextFormField(
                    controller: _positionController,
                    decoration: const InputDecoration(
                      labelText: 'Position',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                        ? 'Position is required'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // --- Join Date Picker ---
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _joinDate == null
                              ? 'Select Join Date'
                              : 'Joined: ${DateFormat('dd MMM yyyy').format(_joinDate!)}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: _isEditMode
                              ? null
                              : _pickDate, // Date cannot be changed in edit mode
                          color: _isEditMode
                              ? Colors.grey
                              : Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // --- Status Dropdown ---
                  DropdownButtonFormField<EmployeeStatus>(
                    initialValue: _status,
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(),
                    ),
                    items: EmployeeStatus.values.map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(status.toString().split('.').last),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _status = value);
                      }
                    },
                  ),
                  const SizedBox(height: 30),

                  // --- Save Button ---
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: Text(_isEditMode ? 'Update' : 'Save'),
                  ),
                ],
              ),
            ),
    );
  }
}
