package com.nmit.portal.service;

import com.nmit.portal.dto.ApiResponse;
import com.nmit.portal.model.Result;
import com.nmit.portal.model.Student;
import com.nmit.portal.model.Course;
import com.nmit.portal.repository.ResultRepository;
import com.nmit.portal.repository.StudentRepository;
import com.nmit.portal.repository.CourseRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class ResultService {

    @Autowired
    private ResultRepository resultRepository;

    @Autowired
    private StudentRepository studentRepository;

    @Autowired
    private CourseRepository courseRepository;

    public List<Result> getAllResults() {
        return resultRepository.findAll();
    }

    public Optional<Result> getResultById(Long id) {
        return resultRepository.findById(id);
    }

    public List<Result> getResultsByStudent(Long studentId) {
        Optional<Student> student = studentRepository.findById(studentId);
        if (student.isPresent()) {
            return resultRepository.findByStudent(student.get());
        }
        return List.of();
    }

    public List<Result> getResultsByStudentUsn(String usn) {
        Optional<Student> student = studentRepository.findByUsn(usn);
        if (student.isPresent()) {
            return resultRepository.findByStudent(student.get());
        }
        return List.of();
    }

    public List<Result> getResultsByStudentAndYear(Long studentId, String academicYear) {
        Optional<Student> student = studentRepository.findById(studentId);
        if (student.isPresent()) {
            return resultRepository.findByStudentAndAcademicYear(student.get(), academicYear);
        }
        return List.of();
    }

    public List<Result> getResultsByCourse(Long courseId) {
        Optional<Course> course = courseRepository.findById(courseId);
        if (course.isPresent()) {
            return resultRepository.findByCourse(course.get());
        }
        return List.of();
    }

    public List<Result> getResultsByAcademicYear(String academicYear) {
        return resultRepository.findByAcademicYear(academicYear);
    }

    public List<Result> getResultsByDepartmentAndYear(Long departmentId, String academicYear) {
        return resultRepository.findByDepartmentAndAcademicYear(departmentId, academicYear);
    }

    public ApiResponse createResult(Result result) {
        try {
            // Validate student exists
            if (result.getStudent() == null || result.getStudent().getId() == null) {
                return ApiResponse.error("Student information is required");
            }

            Optional<Student> studentOptional = studentRepository.findById(result.getStudent().getId());
            if (studentOptional.isEmpty()) {
                return ApiResponse.error("Student not found");
            }

            // Validate course exists
            if (result.getCourse() == null || result.getCourse().getId() == null) {
                return ApiResponse.error("Course information is required");
            }

            Optional<Course> courseOptional = courseRepository.findById(result.getCourse().getId());
            if (courseOptional.isEmpty()) {
                return ApiResponse.error("Course not found");
            }

            // Check if result already exists for this student, course, and academic year
            Optional<Result> existingResult = resultRepository.findByStudentAndCourseAndAcademicYear(
                studentOptional.get(), courseOptional.get(), result.getAcademicYear()
            );

            if (existingResult.isPresent()) {
                return ApiResponse.error("Result already exists for this student, course, and academic year");
            }

            result.setStudent(studentOptional.get());
            result.setCourse(courseOptional.get());

            // Calculate total marks and grade
            calculateMarksAndGrade(result);

            result.setCreatedBy("FACULTY");
            Result savedResult = resultRepository.save(result);

            // Update student CGPA
            updateStudentCgpa(studentOptional.get());

            return ApiResponse.success("Result created successfully", savedResult);

        } catch (Exception e) {
            return ApiResponse.error("Error creating result: " + e.getMessage());
        }
    }

    public ApiResponse updateResult(Long id, Result resultDetails) {
        try {
            Optional<Result> resultOptional = resultRepository.findById(id);
            if (resultOptional.isEmpty()) {
                return ApiResponse.error("Result not found");
            }

            Result result = resultOptional.get();

            // Update marks
            if (resultDetails.getInternalMarks() != null) {
                result.setInternalMarks(resultDetails.getInternalMarks());
            }
            if (resultDetails.getExternalMarks() != null) {
                result.setExternalMarks(resultDetails.getExternalMarks());
            }
            if (resultDetails.getExamType() != null) {
                result.setExamType(resultDetails.getExamType());
            }
            if (resultDetails.getResultStatus() != null) {
                result.setResultStatus(resultDetails.getResultStatus());
            }

            // Recalculate total marks and grade
            calculateMarksAndGrade(result);

            result.setUpdatedBy("FACULTY");
            Result updatedResult = resultRepository.save(result);

            // Update student CGPA
            updateStudentCgpa(result.getStudent());

            return ApiResponse.success("Result updated successfully", updatedResult);

        } catch (Exception e) {
            return ApiResponse.error("Error updating result: " + e.getMessage());
        }
    }

    public ApiResponse deleteResult(Long id) {
        try {
            Optional<Result> resultOptional = resultRepository.findById(id);
            if (resultOptional.isEmpty()) {
                return ApiResponse.error("Result not found");
            }

            Result result = resultOptional.get();
            Student student = result.getStudent();

            // Soft delete
            result.setIsActive(false);
            result.setUpdatedBy("ADMIN");
            resultRepository.save(result);

            // Update student CGPA
            updateStudentCgpa(student);

            return ApiResponse.success("Result deleted successfully");

        } catch (Exception e) {
            return ApiResponse.error("Error deleting result: " + e.getMessage());
        }
    }

    private void calculateMarksAndGrade(Result result) {
        Double internal = result.getInternalMarks() != null ? result.getInternalMarks() : 0.0;
        Double external = result.getExternalMarks() != null ? result.getExternalMarks() : 0.0;
        
        result.setTotalMarks(internal + external);
        
        // Calculate grade based on total marks
        Double totalMarks = result.getTotalMarks();
        String grade;
        Double gradePoints;

        if (totalMarks >= 90) {
            grade = "O";
            gradePoints = 10.0;
        } else if (totalMarks >= 80) {
            grade = "A+";
            gradePoints = 9.0;
        } else if (totalMarks >= 70) {
            grade = "A";
            gradePoints = 8.0;
        } else if (totalMarks >= 60) {
            grade = "B+";
            gradePoints = 7.0;
        } else if (totalMarks >= 55) {
            grade = "B";
            gradePoints = 6.0;
        } else if (totalMarks >= 50) {
            grade = "C";
            gradePoints = 5.0;
        } else if (totalMarks >= 40) {
            grade = "P";
            gradePoints = 4.0;
        } else {
            grade = "F";
            gradePoints = 0.0;
        }

        result.setGrade(grade);
        result.setGradePoints(gradePoints);
        result.setResultStatus(gradePoints >= 4.0 ? "Pass" : "Fail");
    }

    private void updateStudentCgpa(Student student) {
        // Calculate CGPA based on all passed results
        Double averageGradePoints = resultRepository.findAverageGradePointsByStudent(student);
        if (averageGradePoints != null) {
            student.setCgpa(averageGradePoints);
            studentRepository.save(student);
        }
    }

    public List<Result> getTopPerformers(Double minMarks) {
        return resultRepository.findTopPerformers(minMarks);
    }

    public Long getPassedStudentsCount(Long courseId) {
        Optional<Course> course = courseRepository.findById(courseId);
        if (course.isPresent()) {
            return resultRepository.countPassedStudentsByCourse(course.get());
        }
        return 0L;
    }

    public Long getFailedStudentsCount(Long courseId) {
        Optional<Course> course = courseRepository.findById(courseId);
        if (course.isPresent()) {
            return resultRepository.countFailedStudentsByCourse(course.get());
        }
        return 0L;
    }

    public List<String> getAllAcademicYears() {
        return resultRepository.findAllAcademicYears();
    }
}