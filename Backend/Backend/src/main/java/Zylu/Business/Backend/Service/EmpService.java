package Zylu.Business.Backend.Service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import Zylu.Business.Backend.Entity.Employee;
import Zylu.Business.Backend.Repositroy.EmpReposirtoy;

@Service
public class EmpService {
    @Autowired
    private EmpReposirtoy empRepo;

    public Employee createEmployee(Employee employee) {
        if (employee.getName() == null || employee.getName().trim().isEmpty()) {
            throw new IllegalArgumentException("Employee name cannot be null or empty.");
        }
        if (employee.getJoinDate() == null) {
            throw new IllegalArgumentException("Employee join date cannot be null.");
        }
        if (employee.getStatus() == null) {
            throw new IllegalArgumentException("Employee status cannot be null.");
        }

        String trimmedName = employee.getName().trim();

        if (empRepo.existsByName(trimmedName)) {
            throw new IllegalArgumentException("An employee with the name '" + trimmedName + "' already exists.");
        }
        return empRepo.save(employee);
    }

    public java.util.List<Employee> getAllEmployees() {
        return empRepo.findAll();
    }

    public Employee updateEmployee(Long id, Employee employeeDetails) {
        Employee existingEmployee = empRepo.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Employee not found with id: " + id));

        if (employeeDetails.getPosition() != null && !employeeDetails.getPosition().trim().isEmpty()) {
            existingEmployee.setPosition(employeeDetails.getPosition().trim());
        }

        if (employeeDetails.getStatus() != null) {
            existingEmployee.setStatus(employeeDetails.getStatus());
        }

        if (employeeDetails.getJoinDate() != null) {
            existingEmployee.setJoinDate(employeeDetails.getJoinDate());
        }
        return empRepo.save(existingEmployee);
    }

    public void deleteEmployee(Long id) {
        if (!empRepo.existsById(id)) {
            throw new IllegalArgumentException("Employee not found with id: " + id);
        }
        empRepo.deleteById(id);
    }

}
