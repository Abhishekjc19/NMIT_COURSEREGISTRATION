package com.nmit.portal.repository;

import com.nmit.portal.model.Faculty;
import com.nmit.portal.model.Department;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface FacultyRepository extends JpaRepository<Faculty, Long> {
    
    Optional<Faculty> findByEmployeeId(String employeeId);
    
    Optional<Faculty> findByUserId(Long userId);
    
    List<Faculty> findByDepartment(Department department);
    
    List<Faculty> findByDesignation(String designation);
    
    @Query("SELECT f FROM Faculty f WHERE f.experienceYears >= :minExperience")
    List<Faculty> findByExperienceGreaterThan(@Param("minExperience") Integer minExperience);
    
    @Query("SELECT f FROM Faculty f JOIN f.user u WHERE LOWER(u.firstName) LIKE LOWER(CONCAT('%', :name, '%')) " +
           "OR LOWER(u.lastName) LIKE LOWER(CONCAT('%', :name, '%')) OR LOWER(f.employeeId) LIKE LOWER(CONCAT('%', :name, '%'))")
    List<Faculty> searchByNameOrEmployeeId(@Param("name") String name);
    
    @Query("SELECT COUNT(f) FROM Faculty f WHERE f.department = :department")
    Long countByDepartment(@Param("department") Department department);
    
    Boolean existsByEmployeeId(String employeeId);
    
    @Query("SELECT f FROM Faculty f WHERE LOWER(f.specialization) LIKE LOWER(CONCAT('%', :specialization, '%'))")
    List<Faculty> findBySpecializationContaining(@Param("specialization") String specialization);
}