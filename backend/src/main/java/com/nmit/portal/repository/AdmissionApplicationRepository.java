package com.nmit.portal.repository;

import com.nmit.portal.model.AdmissionApplication;
import com.nmit.portal.model.Department;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface AdmissionApplicationRepository extends JpaRepository<AdmissionApplication, Long> {
    
    Optional<AdmissionApplication> findByApplicationNumber(String applicationNumber);
    
    List<AdmissionApplication> findByApplicationStatus(String applicationStatus);
    
    List<AdmissionApplication> findByDepartment(Department department);
    
    List<AdmissionApplication> findByCourseApplied(String courseApplied);
    
    @Query("SELECT a FROM AdmissionApplication a WHERE a.applicationDate BETWEEN :startDate AND :endDate")
    List<AdmissionApplication> findByApplicationDateBetween(@Param("startDate") LocalDate startDate, 
                                                           @Param("endDate") LocalDate endDate);
    
    @Query("SELECT a FROM AdmissionApplication a WHERE LOWER(a.applicantName) LIKE LOWER(CONCAT('%', :name, '%'))")
    List<AdmissionApplication> searchByApplicantName(@Param("name") String name);
    
    @Query("SELECT a FROM AdmissionApplication a WHERE a.entranceExamScore >= :minScore ORDER BY a.entranceExamScore DESC")
    List<AdmissionApplication> findByEntranceScoreGreaterThan(@Param("minScore") Double minScore);
    
    @Query("SELECT COUNT(a) FROM AdmissionApplication a WHERE a.applicationStatus = :status")
    Long countByApplicationStatus(@Param("status") String status);
    
    @Query("SELECT COUNT(a) FROM AdmissionApplication a WHERE a.department = :department AND a.applicationStatus = 'Admitted'")
    Long countAdmittedByDepartment(@Param("department") Department department);
    
    Boolean existsByApplicationNumber(String applicationNumber);
    
    Boolean existsByEmail(String email);
    
    @Query("SELECT a FROM AdmissionApplication a WHERE a.class12Percentage >= :minPercentage AND a.class10Percentage >= :minPercentage")
    List<AdmissionApplication> findByAcademicPerformance(@Param("minPercentage") Double minPercentage);
}