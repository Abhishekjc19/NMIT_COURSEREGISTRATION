package com.nmit.portal.repository;

import com.nmit.portal.model.PlacementRecord;
import com.nmit.portal.model.Student;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface PlacementRecordRepository extends JpaRepository<PlacementRecord, Long> {
    
    List<PlacementRecord> findByStudent(Student student);
    
    List<PlacementRecord> findByCompanyName(String companyName);
    
    List<PlacementRecord> findByStatus(String status);
    
    List<PlacementRecord> findByPlacementType(String placementType);
    
    List<PlacementRecord> findByCompanyCategory(String companyCategory);
    
    @Query("SELECT p FROM PlacementRecord p WHERE p.student.department.id = :departmentId")
    List<PlacementRecord> findByDepartmentId(@Param("departmentId") Long departmentId);
    
    @Query("SELECT p FROM PlacementRecord p WHERE p.student.batchYear = :batchYear")
    List<PlacementRecord> findByBatchYear(@Param("batchYear") Integer batchYear);
    
    @Query("SELECT p FROM PlacementRecord p WHERE p.packageOffered >= :minPackage ORDER BY p.packageOffered DESC")
    List<PlacementRecord> findByPackageGreaterThan(@Param("minPackage") Double minPackage);
    
    @Query("SELECT p FROM PlacementRecord p WHERE p.placementDate BETWEEN :startDate AND :endDate")
    List<PlacementRecord> findByPlacementDateBetween(@Param("startDate") LocalDate startDate, 
                                                     @Param("endDate") LocalDate endDate);
    
    @Query("SELECT COUNT(p) FROM PlacementRecord p WHERE p.student.department.id = :departmentId AND p.status = 'Placed'")
    Long countPlacedStudentsByDepartment(@Param("departmentId") Long departmentId);
    
    @Query("SELECT AVG(p.packageOffered) FROM PlacementRecord p WHERE p.student.department.id = :departmentId AND p.status = 'Placed'")
    Double findAveragePackageByDepartment(@Param("departmentId") Long departmentId);
    
    @Query("SELECT MAX(p.packageOffered) FROM PlacementRecord p WHERE p.student.department.id = :departmentId")
    Double findHighestPackageByDepartment(@Param("departmentId") Long departmentId);
    
    @Query("SELECT p.companyName, COUNT(p) as placementCount FROM PlacementRecord p WHERE p.status = 'Placed' " +
           "GROUP BY p.companyName ORDER BY placementCount DESC")
    List<Object[]> findTopRecruiters();
    
    @Query("SELECT COUNT(DISTINCT p.student) FROM PlacementRecord p WHERE p.status = 'Placed'")
    Long countUniquePlacedStudents();
}