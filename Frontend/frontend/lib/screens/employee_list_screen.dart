// screens/employee_list_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/employee.dart';
import '../providers/employee_provider.dart';
import 'add_edit_employee_screen.dart';

class EmployeeListScreen extends StatelessWidget {
  const EmployeeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Zylu Employees"),
        actions: [
          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<EmployeeProvider>(
                context,
                listen: false,
              ).fetchEmployees();
            },
          ),
        ],
      ),
      body: Consumer<EmployeeProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.employees.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null) {
            return Center(child: Text("Error: ${provider.errorMessage}"));
          }

          if (provider.employees.isEmpty) {
            return const Center(child: Text("No employees found. Add one!"));
          }

          return ListView.builder(
            itemCount: provider.employees.length,
            itemBuilder: (context, index) {
              final employee = provider.employees[index];
              return _buildEmployeeCard(context, employee);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // Navigate to Add/Edit screen in "add" mode
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEditEmployeeScreen(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmployeeCard(BuildContext context, Employee employee) {
    // This is the core logic from the assignment
    final cardColor = employee.isFlagged ? Colors.green[100] : Colors.white;
    final statusColor = employee.status == EmployeeStatus.ACTIVE
        ? Colors.green
        : Colors.grey;
    final joinDate = DateFormat('dd MMM yyyy').format(employee.joinDate);

    return Card(
      color: cardColor,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        title: Text(
          employee.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Text(employee.position, style: TextStyle(fontSize: 16)),
            const SizedBox(height: 5),
            Text("Joined: $joinDate"),
            const SizedBox(height: 5),
            Text(
              employee.status.toString().split('.').last,
              style: TextStyle(color: statusColor, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // EDIT Button
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                // Navigate to Add/Edit screen in "edit" mode
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddEditEmployeeScreen(employee: employee),
                  ),
                );
              },
            ),
            // DELETE Button
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _showDeleteDialog(context, employee);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Employee employee) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete ${employee.name}?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () {
              Provider.of<EmployeeProvider>(
                context,
                listen: false,
              ).removeEmployee(employee.id!);
              Navigator.of(ctx).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
