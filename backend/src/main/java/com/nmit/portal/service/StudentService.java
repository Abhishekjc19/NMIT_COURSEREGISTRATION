package com.nmit.portal.service;

import com.nmit.portal.dto.ApiResponse;
import com.nmit.portal.model.Student;
import com.nmit.portal.model.Department;
import com.nmit.portal.model.User;
import com.nmit.portal.repository.StudentRepository;
import com.nmit.portal.repository.DepartmentRepository;
import com.nmit.portal.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class StudentService {

    @Autowired
    private StudentRepository studentRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private DepartmentRepository departmentRepository;

    public List<Student> getAllStudents() {
        return studentRepository.findAll();
    }

    public Page<Student> getAllStudents(Pageable pageable) {
        return studentRepository.findAll(pageable);
    }

    public Optional<Student> getStudentById(Long id) {
        return studentRepository.findById(id);
    }

    public Optional<Student> getStudentByUsn(String usn) {
        return studentRepository.findByUsn(usn);
    }

    public Optional<Student> getStudentByUserId(Long userId) {
        return studentRepository.findByUserId(userId);
    }

    public List<Student> getStudentsByDepartment(Long departmentId) {
        Optional<Department> department = departmentRepository.findById(departmentId);
        if (department.isPresent()) {
            return studentRepository.findByDepartment(department.get());
        }
        return List.of();
    }

    public List<Student> getStudentsByBatchYear(Integer batchYear) {
        return studentRepository.findByBatchYear(batchYear);
    }

    public List<Student> getStudentsBySemester(Integer semester) {
        return studentRepository.findByCurrentSemester(semester);
    }

    public List<Student> searchStudents(String query) {
        return studentRepository.searchByNameOrUsn(query);
    }

    public ApiResponse createStudent(Student student) {
        try {
            // Validate USN uniqueness
            if (studentRepository.existsByUsn(student.getUsn())) {
                return ApiResponse.error("Student with USN " + student.getUsn() + " already exists");
            }

            // Validate admission number uniqueness if provided
            if (student.getAdmissionNumber() != null && 
                studentRepository.existsByAdmissionNumber(student.getAdmissionNumber())) {
                return ApiResponse.error("Student with admission number " + student.getAdmissionNumber() + " already exists");
            }

            // Validate user exists
            if (student.getUser() == null || student.getUser().getId() == null) {
                return ApiResponse.error("User information is required");
            }

            Optional<User> userOptional = userRepository.findById(student.getUser().getId());
            if (userOptional.isEmpty()) {
                return ApiResponse.error("User not found");
            }

            // Validate department exists
            if (student.getDepartment() == null || student.getDepartment().getId() == null) {
                return ApiResponse.error("Department information is required");
            }

            Optional<Department> departmentOptional = departmentRepository.findById(student.getDepartment().getId());
            if (departmentOptional.isEmpty()) {
                return ApiResponse.error("Department not found");
            }

            student.setUser(userOptional.get());
            student.setDepartment(departmentOptional.get());
            student.setCreatedBy("ADMIN");

            Student savedStudent = studentRepository.save(student);
            return ApiResponse.success("Student created successfully", savedStudent);

        } catch (Exception e) {
            return ApiResponse.error("Error creating student: " + e.getMessage());
        }
    }

    public ApiResponse updateStudent(Long id, Student studentDetails) {
        try {
            Optional<Student> studentOptional = studentRepository.findById(id);
            if (studentOptional.isEmpty()) {
                return ApiResponse.error("Student not found");
            }

            Student student = studentOptional.get();

            // Update basic information
            if (studentDetails.getAdmissionNumber() != null) {
                student.setAdmissionNumber(studentDetails.getAdmissionNumber());
            }
            if (studentDetails.getBatchYear() != null) {
                student.setBatchYear(studentDetails.getBatchYear());
            }
            if (studentDetails.getCurrentSemester() != null) {
                student.setCurrentSemester(studentDetails.getCurrentSemester());
            }
            if (studentDetails.getCgpa() != null) {
                student.setCgpa(studentDetails.getCgpa());
            }
            if (studentDetails.getDateOfBirth() != null) {
                student.setDateOfBirth(studentDetails.getDateOfBirth());
            }
            if (studentDetails.getGender() != null) {
                student.setGender(studentDetails.getGender());
            }
            if (studentDetails.getAddress() != null) {
                student.setAddress(studentDetails.getAddress());
            }
            if (studentDetails.getParentName() != null) {
                student.setParentName(studentDetails.getParentName());
            }
            if (studentDetails.getParentPhone() != null) {
                student.setParentPhone(studentDetails.getParentPhone());
            }
            if (studentDetails.getParentEmail() != null) {
                student.setParentEmail(studentDetails.getParentEmail());
            }
            if (studentDetails.getStatus() != null) {
                student.setStatus(studentDetails.getStatus());
            }

            // Update department if provided
            if (studentDetails.getDepartment() != null && studentDetails.getDepartment().getId() != null) {
                Optional<Department> departmentOptional = departmentRepository.findById(studentDetails.getDepartment().getId());
                if (departmentOptional.isPresent()) {
                    student.setDepartment(departmentOptional.get());
                }
            }

            student.setUpdatedBy("ADMIN");
            Student updatedStudent = studentRepository.save(student);
            return ApiResponse.success("Student updated successfully", updatedStudent);

        } catch (Exception e) {
            return ApiResponse.error("Error updating student: " + e.getMessage());
        }
    }

    public ApiResponse deleteStudent(Long id) {
        try {
            Optional<Student> studentOptional = studentRepository.findById(id);
            if (studentOptional.isEmpty()) {
                return ApiResponse.error("Student not found");
            }

            // Soft delete - set isActive to false
            Student student = studentOptional.get();
            student.setIsActive(false);
            student.setUpdatedBy("ADMIN");
            studentRepository.save(student);

            return ApiResponse.success("Student deleted successfully");

        } catch (Exception e) {
            return ApiResponse.error("Error deleting student: " + e.getMessage());
        }
    }

    public List<Student> getTopPerformers(Double minCgpa) {
        return studentRepository.findStudentsWithCgpaGreaterThan(minCgpa);
    }

    public Long getStudentCountByDepartment(Long departmentId) {
        Optional<Department> department = departmentRepository.findById(departmentId);
        if (department.isPresent()) {
            return studentRepository.countByDepartment(department.get());
        }
        return 0L;
    }

    public Double getAverageCgpaByDepartment(Long departmentId) {
        Optional<Department> department = departmentRepository.findById(departmentId);
        if (department.isPresent()) {
            return studentRepository.findAverageCgpaByDepartment(department.get());
        }
        return 0.0;
    }
}