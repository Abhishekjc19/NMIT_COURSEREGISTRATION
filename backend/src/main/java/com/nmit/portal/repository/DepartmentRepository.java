package com.nmit.portal.repository;

import com.nmit.portal.model.Department;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface DepartmentRepository extends JpaRepository<Department, Long> {
    
    Optional<Department> findByCode(String code);
    
    Optional<Department> findByName(String name);
    
    List<Department> findByIsActiveTrue();
    
    Boolean existsByCode(String code);
    
    Boolean existsByName(String name);
    
    @Query("SELECT d FROM Department d WHERE LOWER(d.name) LIKE LOWER(CONCAT('%', :name, '%')) " +
           "OR LOWER(d.code) LIKE LOWER(CONCAT('%', :name, '%'))")
    List<Department> searchByNameOrCode(@Param("name") String name);
    
    @Query("SELECT d FROM Department d ORDER BY d.name ASC")
    List<Department> findAllOrderByName();
}