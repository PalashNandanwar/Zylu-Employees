package Zylu.Business.Backend.Entity;

import java.time.LocalDate;

import Zylu.Business.Backend.Enum.EmployeeStatus;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "Employee_Zylu")
public class Employee {
	
	@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    @Column(name = "join_date", nullable = false)
    private LocalDate joinDate;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private EmployeeStatus status;

    private String position;

    // The isFlagged() method remains the same
    public boolean isFlagged() {
        if (this.status != EmployeeStatus.ACTIVE) {
            return false;
        }
        return joinDate.isBefore(LocalDate.now().minusYears(5));
    }

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public LocalDate getJoinDate() {
		return joinDate;
	}

	public void setJoinDate(LocalDate joinDate) {
		this.joinDate = joinDate;
	}

	public EmployeeStatus getStatus() {
		return status;
	}

	public void setStatus(EmployeeStatus status) {
		this.status = status;
	}

	public String getPosition() {
		return position;
	}

	public void setPosition(String position) {
		this.position = position;
	}

	public Employee(Long id, String name, LocalDate joinDate, EmployeeStatus status, String position) {
		super();
		this.id = id;
		this.name = name;
		this.joinDate = joinDate;
		this.status = status;
		this.position = position;
	}

	public Employee() {
		super();
		// TODO Auto-generated constructor stub
	}
    
    

}
