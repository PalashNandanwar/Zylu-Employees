package Zylu.Business.Backend.Repositroy;

import org.springframework.data.jpa.repository.JpaRepository;

import Zylu.Business.Backend.Entity.Employee;

public interface EmpReposirtoy extends JpaRepository<Employee, Long> {
	boolean existsByName(String name);
}
