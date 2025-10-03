package com.nmit.portal.repository;

import com.nmit.portal.model.Result;
import com.nmit.portal.model.Student;
import com.nmit.portal.model.Course;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ResultRepository extends JpaRepository<Result, Long> {
    
    List<Result> findByStudent(Student student);
    
    List<Result> findByCourse(Course course);
    
    List<Result> findByStudentAndAcademicYear(Student student, String academicYear);
    
    List<Result> findByAcademicYear(String academicYear);
    
    Optional<Result> findByStudentAndCourseAndAcademicYear(Student student, Course course, String academicYear);
    
    List<Result> findByStudentAndExamType(Student student, String examType);
    
    List<Result> findByResultStatus(String resultStatus);
    
    @Query("SELECT r FROM Result r WHERE r.student.department.id = :departmentId AND r.academicYear = :academicYear")
    List<Result> findByDepartmentAndAcademicYear(@Param("departmentId") Long departmentId, 
                                                 @Param("academicYear") String academicYear);
    
    @Query("SELECT AVG(r.gradePoints) FROM Result r WHERE r.student = :student AND r.resultStatus = 'Pass'")
    Double findAverageGradePointsByStudent(@Param("student") Student student);
    
    @Query("SELECT r FROM Result r WHERE r.student.batchYear = :batchYear AND r.academicYear = :academicYear")
    List<Result> findByBatchAndAcademicYear(@Param("batchYear") Integer batchYear, 
                                           @Param("academicYear") String academicYear);
    
    @Query("SELECT COUNT(r) FROM Result r WHERE r.course = :course AND r.resultStatus = 'Pass'")
    Long countPassedStudentsByCourse(@Param("course") Course course);
    
    @Query("SELECT COUNT(r) FROM Result r WHERE r.course = :course AND r.resultStatus = 'Fail'")
    Long countFailedStudentsByCourse(@Param("course") Course course);
    
    @Query("SELECT r FROM Result r WHERE r.totalMarks >= :minMarks ORDER BY r.totalMarks DESC")
    List<Result> findTopPerformers(@Param("minMarks") Double minMarks);
    
    @Query("SELECT DISTINCT r.academicYear FROM Result r ORDER BY r.academicYear DESC")
    List<String> findAllAcademicYears();
}