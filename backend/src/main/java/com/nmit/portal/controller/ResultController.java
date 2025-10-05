package com.nmit.portal.controller;

import com.nmit.portal.dto.ApiResponse;
import com.nmit.portal.model.Result;
import com.nmit.portal.service.ResultService;
import com.nmit.portal.security.UserPrincipal;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/results")
public class ResultController {

    @Autowired
    private ResultService resultService;

    @GetMapping
    @PreAuthorize("hasRole('ADMIN') or hasRole('FACULTY') or hasRole('HOD')")
    public ResponseEntity<?> getAllResults() {
        try {
            List<Result> results = resultService.getAllResults();
            return ResponseEntity.ok(ApiResponse.success("Results retrieved successfully", results));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error("Error retrieving results: " + e.getMessage()));
        }
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN') or hasRole('FACULTY') or hasRole('HOD') or hasRole('STUDENT')")
    public ResponseEntity<?> getResultById(@PathVariable Long id, @AuthenticationPrincipal UserPrincipal userPrincipal) {
        try {
            Optional<Result> result = resultService.getResultById(id);
            if (result.isPresent()) {
                return ResponseEntity.ok(ApiResponse.success("Result retrieved successfully", result.get()));
            } else {
                return ResponseEntity.notFound().build();
            }
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error("Error retrieving result: " + e.getMessage()));
        }
    }

    @GetMapping("/student/{studentId}")
    @PreAuthorize("hasRole('ADMIN') or hasRole('FACULTY') or hasRole('HOD') or (hasRole('STUDENT') and @studentService.getStudentById(#studentId).orElse(new com.nmit.portal.model.Student()).user?.id == #userPrincipal.id)")
    public ResponseEntity<?> getResultsByStudent(@PathVariable Long studentId, @AuthenticationPrincipal UserPrincipal userPrincipal) {
        try {
            List<Result> results = resultService.getResultsByStudent(studentId);
            return ResponseEntity.ok(ApiResponse.success("Results retrieved successfully", results));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error("Error retrieving results: " + e.getMessage()));
        }
    }

    @GetMapping("/student/usn/{usn}")
    @PreAuthorize("hasRole('ADMIN') or hasRole('FACULTY') or hasRole('HOD')")
    public ResponseEntity<?> getResultsByStudentUsn(@PathVariable String usn) {
        try {
            List<Result> results = resultService.getResultsByStudentUsn(usn);
            return ResponseEntity.ok(ApiResponse.success("Results retrieved successfully", results));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error("Error retrieving results: " + e.getMessage()));
        }
    }

    @GetMapping("/my-results")
    @PreAuthorize("hasRole('STUDENT')")
    public ResponseEntity<?> getMyResults(@AuthenticationPrincipal UserPrincipal userPrincipal) {
        try {
            // First get the student by user ID, then get results
            // This would require a method in StudentService to get student by user ID
            // For now, we'll assume the student ID is passed as a parameter
            // In a real implementation, you'd get the student from the user principal
            return ResponseEntity.ok(ApiResponse.success("Please use /results/student/{studentId} endpoint"));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error("Error retrieving results: " + e.getMessage()));
        }
    }

    @GetMapping("/student/{studentId}/year/{academicYear}")
    @PreAuthorize("hasRole('ADMIN') or hasRole('FACULTY') or hasRole('HOD') or (hasRole('STUDENT') and @studentService.getStudentById(#studentId).orElse(new com.nmit.portal.model.Student()).user?.id == #userPrincipal.id)")
    public ResponseEntity<?> getResultsByStudentAndYear(@PathVariable Long studentId, @PathVariable String academicYear,
                                                       @AuthenticationPrincipal UserPrincipal userPrincipal) {
        try {
            List<Result> results = resultService.getResultsByStudentAndYear(studentId, academicYear);
            return ResponseEntity.ok(ApiResponse.success("Results retrieved successfully", results));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error("Error retrieving results: " + e.getMessage()));
        }
    }

    @GetMapping("/course/{courseId}")
    @PreAuthorize("hasRole('ADMIN') or hasRole('FACULTY') or hasRole('HOD')")
    public ResponseEntity<?> getResultsByCourse(@PathVariable Long courseId) {
        try {
            List<Result> results = resultService.getResultsByCourse(courseId);
            return ResponseEntity.ok(ApiResponse.success("Results retrieved successfully", results));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error("Error retrieving results: " + e.getMessage()));
        }
    }

    @GetMapping("/academic-year/{academicYear}")
    @PreAuthorize("hasRole('ADMIN') or hasRole('FACULTY') or hasRole('HOD')")
    public ResponseEntity<?> getResultsByAcademicYear(@PathVariable String academicYear) {
        try {
            List<Result> results = resultService.getResultsByAcademicYear(academicYear);
            return ResponseEntity.ok(ApiResponse.success("Results retrieved successfully", results));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error("Error retrieving results: " + e.getMessage()));
        }
    }

    @GetMapping("/department/{departmentId}/year/{academicYear}")
    @PreAuthorize("hasRole('ADMIN') or hasRole('FACULTY') or hasRole('HOD')")
    public ResponseEntity<?> getResultsByDepartmentAndYear(@PathVariable Long departmentId, @PathVariable String academicYear) {
        try {
            List<Result> results = resultService.getResultsByDepartmentAndYear(departmentId, academicYear);
            return ResponseEntity.ok(ApiResponse.success("Results retrieved successfully", results));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error("Error retrieving results: " + e.getMessage()));
        }
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN') or hasRole('FACULTY')")
    public ResponseEntity<?> createResult(@Valid @RequestBody Result result) {
        ApiResponse response = resultService.createResult(result);
        if (response.getSuccess()) {
            return ResponseEntity.ok(response);
        } else {
            return ResponseEntity.badRequest().body(response);
        }
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN') or hasRole('FACULTY')")
    public ResponseEntity<?> updateResult(@PathVariable Long id, @Valid @RequestBody Result result) {
        ApiResponse response = resultService.updateResult(id, result);
        if (response.getSuccess()) {
            return ResponseEntity.ok(response);
        } else {
            return ResponseEntity.badRequest().body(response);
        }
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> deleteResult(@PathVariable Long id) {
        ApiResponse response = resultService.deleteResult(id);
        if (response.getSuccess()) {
            return ResponseEntity.ok(response);
        } else {
            return ResponseEntity.badRequest().body(response);
        }
    }

    @GetMapping("/top-performers")
    @PreAuthorize("hasRole('ADMIN') or hasRole('FACULTY') or hasRole('HOD')")
    public ResponseEntity<?> getTopPerformers(@RequestParam(defaultValue = "80.0") Double minMarks) {
        try {
            List<Result> results = resultService.getTopPerformers(minMarks);
            return ResponseEntity.ok(ApiResponse.success("Top performers retrieved successfully", results));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error("Error retrieving top performers: " + e.getMessage()));
        }
    }

    @GetMapping("/course/{courseId}/passed-count")
    @PreAuthorize("hasRole('ADMIN') or hasRole('FACULTY') or hasRole('HOD')")
    public ResponseEntity<?> getPassedStudentsCount(@PathVariable Long courseId) {
        try {
            Long count = resultService.getPassedStudentsCount(courseId);
            return ResponseEntity.ok(ApiResponse.success("Passed students count retrieved successfully", count));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error("Error retrieving passed students count: " + e.getMessage()));
        }
    }

    @GetMapping("/course/{courseId}/failed-count")
    @PreAuthorize("hasRole('ADMIN') or hasRole('FACULTY') or hasRole('HOD')")
    public ResponseEntity<?> getFailedStudentsCount(@PathVariable Long courseId) {
        try {
            Long count = resultService.getFailedStudentsCount(courseId);
            return ResponseEntity.ok(ApiResponse.success("Failed students count retrieved successfully", count));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error("Error retrieving failed students count: " + e.getMessage()));
        }
    }

    @GetMapping("/academic-years")
    @PreAuthorize("hasRole('ADMIN') or hasRole('FACULTY') or hasRole('HOD')")
    public ResponseEntity<?> getAllAcademicYears() {
        try {
            List<String> academicYears = resultService.getAllAcademicYears();
            return ResponseEntity.ok(ApiResponse.success("Academic years retrieved successfully", academicYears));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error("Error retrieving academic years: " + e.getMessage()));
        }
    }
}