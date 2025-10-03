package com.nmit.portal.repository;

import com.nmit.portal.model.Course;
import com.nmit.portal.model.Department;
import com.nmit.portal.model.Faculty;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CourseRepository extends JpaRepository<Course, Long> {
    
    Optional<Course> findByCourseCode(String courseCode);
    
    List<Course> findByDepartment(Department department);
    
    List<Course> findBySemester(Integer semester);
    
    List<Course> findByFaculty(Faculty faculty);
    
    List<Course> findByDepartmentAndSemester(Department department, Integer semester);
    
    List<Course> findByCourseType(String courseType);
    
    @Query("SELECT c FROM Course c WHERE LOWER(c.courseName) LIKE LOWER(CONCAT('%', :name, '%')) " +
           "OR LOWER(c.courseCode) LIKE LOWER(CONCAT('%', :name, '%'))")
    List<Course> searchByNameOrCode(@Param("name") String name);
    
    @Query("SELECT SUM(c.credits) FROM Course c WHERE c.department = :department AND c.semester = :semester")
    Integer getTotalCreditsBySemester(@Param("department") Department department, @Param("semester") Integer semester);
    
    Boolean existsByCourseCode(String courseCode);
    
    @Query("SELECT COUNT(c) FROM Course c WHERE c.department = :department")
    Long countByDepartment(@Param("department") Department department);
    
    @Query("SELECT c FROM Course c WHERE c.faculty IS NULL")
    List<Course> findCoursesWithoutFaculty();
}