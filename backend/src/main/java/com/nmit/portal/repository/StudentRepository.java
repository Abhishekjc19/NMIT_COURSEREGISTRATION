package com.nmit.portal.repository;

import com.nmit.portal.model.Student;
import com.nmit.portal.model.Department;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface StudentRepository extends JpaRepository<Student, Long> {
    
    Optional<Student> findByUsn(String usn);
    
    Optional<Student> findByAdmissionNumber(String admissionNumber);
    
    Optional<Student> findByUserId(Long userId);
    
    List<Student> findByDepartment(Department department);
    
    List<Student> findByBatchYear(Integer batchYear);
    
    List<Student> findByCurrentSemester(Integer semester);
    
    List<Student> findByDepartmentAndBatchYear(Department department, Integer batchYear);
    
    List<Student> findByDepartmentAndCurrentSemester(Department department, Integer semester);
    
    @Query("SELECT s FROM Student s WHERE s.cgpa >= :minCgpa ORDER BY s.cgpa DESC")
    List<Student> findStudentsWithCgpaGreaterThan(@Param("minCgpa") Double minCgpa);
    
    @Query("SELECT s FROM Student s WHERE s.department.id = :departmentId AND s.batchYear = :batchYear")
    List<Student> findByDepartmentIdAndBatchYear(@Param("departmentId") Long departmentId, 
                                                 @Param("batchYear") Integer batchYear);
    
    @Query("SELECT COUNT(s) FROM Student s WHERE s.department = :department")
    Long countByDepartment(@Param("department") Department department);
    
    @Query("SELECT s FROM Student s JOIN s.user u WHERE LOWER(u.firstName) LIKE LOWER(CONCAT('%', :name, '%')) " +
           "OR LOWER(u.lastName) LIKE LOWER(CONCAT('%', :name, '%')) OR LOWER(s.usn) LIKE LOWER(CONCAT('%', :name, '%'))")
    List<Student> searchByNameOrUsn(@Param("name") String name);
    
    Boolean existsByUsn(String usn);
    
    Boolean existsByAdmissionNumber(String admissionNumber);
    
    @Query("SELECT AVG(s.cgpa) FROM Student s WHERE s.department = :department AND s.cgpa IS NOT NULL")
    Double findAverageCgpaByDepartment(@Param("department") Department department);
}