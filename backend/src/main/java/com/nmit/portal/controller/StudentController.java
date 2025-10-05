package com.nmit.portal.controller;

import com.nmit.portal.dto.ApiResponse;
import com.nmit.portal.model.Student;
import com.nmit.portal.service.StudentService;
import com.nmit.portal.security.UserPrincipal;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/students")
public class StudentController {

    @Autowired
    private StudentService studentService;

    @GetMapping
    @PreAuthorize("hasRole('ADMIN') or hasRole('FACULTY') or hasRole('HOD')")
    public ResponseEntity<?> getAllStudents(Pageable pageable) {
        try {
            Page<Student> students = studentService.getAllStudents(pageable);
            return ResponseEntity.ok(ApiResponse.success("Students retrieved successfully", students));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error("Error retrieving students: " + e.getMessage()));
        }
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN') or hasRole('FACULTY') or hasRole('HOD') or (hasRole('STUDENT') and #userPrincipal.id == @studentService.getStudentById(#id).orElse(new com.nmit.portal.model.Student()).user?.id)")
    public ResponseEntity<?> getStudentById(@PathVariable Long id, @AuthenticationPrincipal UserPrincipal userPrincipal) {
        try {
            Optional<Student> student = studentService.getStudentById(id);
            if (student.isPresent()) {
                return ResponseEntity.ok(ApiResponse.success("Student retrieved successfully", student.get()));
            } else {
                return ResponseEntity.notFound().build();
            }
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error("Error retrieving student: " + e.getMessage()));
        }
    }

    @GetMapping("/usn/{usn}")
    @PreAuthorize("hasRole('ADMIN') or hasRole('FACULTY') or hasRole('HOD')")
    public ResponseEntity<?> getStudentByUsn(@PathVariable String usn) {
        try {
            Optional<Student> student = studentService.getStudentByUsn(usn);
            if (student.isPresent()) {
                return ResponseEntity.ok(ApiResponse.success("Student retrieved successfully", student.get()));
            } else {
                return ResponseEntity.notFound().build();
            }
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error("Error retrieving student: " + e.getMessage()));
        }
    }

    @GetMapping("/my-profile")
    @PreAuthorize("hasRole('STUDENT')")
    public ResponseEntity<?> getMyProfile(@AuthenticationPrincipal UserPrincipal userPrincipal) {
        try {
            Optional<Student> student = studentService.getStudentByUserId(userPrincipal.getId());
            if (student.isPresent()) {
                return ResponseEntity.ok(ApiResponse.success("Profile retrieved successfully", student.get()));
            } else {
                return ResponseEntity.notFound().build();
            }
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error("Error retrieving profile: " + e.getMessage()));
        }
    }

    @GetMapping("/department/{departmentId}")
    @PreAuthorize("hasRole('ADMIN') or hasRole('FACULTY') or hasRole('HOD')")
    public ResponseEntity<?> getStudentsByDepartment(@PathVariable Long departmentId) {
        try {
            List<Student> students = studentService.getStudentsByDepartment(departmentId);
            return ResponseEntity.ok(ApiResponse.success("Students retrieved successfully", students));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error("Error retrieving students: " + e.getMessage()));
        }
    }

    @GetMapping("/batch/{batchYear}")
    @PreAuthorize("hasRole('ADMIN') or hasRole('FACULTY') or hasRole('HOD')")
    public ResponseEntity<?> getStudentsByBatch(@PathVariable Integer batchYear) {
        try {
            List<Student> students = studentService.getStudentsByBatchYear(batchYear);
            return ResponseEntity.ok(ApiResponse.success("Students retrieved successfully", students));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error("Error retrieving students: " + e.getMessage()));
        }
    }

    @GetMapping("/semester/{semester}")
    @PreAuthorize("hasRole('ADMIN') or hasRole('FACULTY') or hasRole('HOD')")
    public ResponseEntity<?> getStudentsBySemester(@PathVariable Integer semester) {
        try {
            List<Student> students = studentService.getStudentsBySemester(semester);
            return ResponseEntity.ok(ApiResponse.success("Students retrieved successfully", students));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error("Error retrieving students: " + e.getMessage()));
        }
    }

    @GetMapping("/search")
    @PreAuthorize("hasRole('ADMIN') or hasRole('FACULTY') or hasRole('HOD')")
    public ResponseEntity<?> searchStudents(@RequestParam String query) {
        try {
            List<Student> students = studentService.searchStudents(query);
            return ResponseEntity.ok(ApiResponse.success("Search results retrieved successfully", students));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error("Error searching students: " + e.getMessage()));
        }
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> createStudent(@Valid @RequestBody Student student) {
        ApiResponse response = studentService.createStudent(student);
        if (response.getSuccess()) {
            return ResponseEntity.ok(response);
        } else {
            return ResponseEntity.badRequest().body(response);
        }
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN') or (hasRole('STUDENT') and #userPrincipal.id == @studentService.getStudentById(#id).orElse(new com.nmit.portal.model.Student()).user?.id)")
    public ResponseEntity<?> updateStudent(@PathVariable Long id, @Valid @RequestBody Student student, 
                                         @AuthenticationPrincipal UserPrincipal userPrincipal) {
        ApiResponse response = studentService.updateStudent(id, student);
        if (response.getSuccess()) {
            return ResponseEntity.ok(response);
        } else {
            return ResponseEntity.badRequest().body(response);
        }
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> deleteStudent(@PathVariable Long id) {
        ApiResponse response = studentService.deleteStudent(id);
        if (response.getSuccess()) {
            return ResponseEntity.ok(response);
        } else {
            return ResponseEntity.badRequest().body(response);
        }
    }

    @GetMapping("/top-performers")
    @PreAuthorize("hasRole('ADMIN') or hasRole('FACULTY') or hasRole('HOD')")
    public ResponseEntity<?> getTopPerformers(@RequestParam(defaultValue = "8.0") Double minCgpa) {
        try {
            List<Student> students = studentService.getTopPerformers(minCgpa);
            return ResponseEntity.ok(ApiResponse.success("Top performers retrieved successfully", students));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error("Error retrieving top performers: " + e.getMessage()));
        }
    }

    @GetMapping("/department/{departmentId}/count")
    @PreAuthorize("hasRole('ADMIN') or hasRole('FACULTY') or hasRole('HOD')")
    public ResponseEntity<?> getStudentCountByDepartment(@PathVariable Long departmentId) {
        try {
            Long count = studentService.getStudentCountByDepartment(departmentId);
            return ResponseEntity.ok(ApiResponse.success("Student count retrieved successfully", count));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error("Error retrieving student count: " + e.getMessage()));
        }
    }

    @GetMapping("/department/{departmentId}/average-cgpa")
    @PreAuthorize("hasRole('ADMIN') or hasRole('FACULTY') or hasRole('HOD')")
    public ResponseEntity<?> getAverageCgpaByDepartment(@PathVariable Long departmentId) {
        try {
            Double avgCgpa = studentService.getAverageCgpaByDepartment(departmentId);
            return ResponseEntity.ok(ApiResponse.success("Average CGPA retrieved successfully", avgCgpa));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error("Error retrieving average CGPA: " + e.getMessage()));
        }
    }
}