package com.nmit.portal.controller;

import com.nmit.portal.dto.ApiResponse;
import com.nmit.portal.dto.JwtAuthenticationResponse;
import com.nmit.portal.dto.LoginRequest;
import com.nmit.portal.dto.StudentLoginRequest;
import com.nmit.portal.service.AuthService;
import com.nmit.portal.security.UserPrincipal;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/auth")
public class AuthController {

    @Autowired
    private AuthService authService;

    @PostMapping("/login")
    public ResponseEntity<?> authenticateUser(@Valid @RequestBody LoginRequest loginRequest) {
        try {
            JwtAuthenticationResponse response = authService.authenticateUser(loginRequest);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error("Login failed: " + e.getMessage()));
        }
    }

    @PostMapping("/student-login")
    public ResponseEntity<?> authenticateStudent(@Valid @RequestBody StudentLoginRequest studentLoginRequest) {
        try {
            JwtAuthenticationResponse response = authService.authenticateStudent(studentLoginRequest);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error("Student login failed: " + e.getMessage()));
        }
    }

    @PostMapping("/change-password")
    public ResponseEntity<?> changePassword(
            @AuthenticationPrincipal UserPrincipal userPrincipal,
            @RequestBody Map<String, String> request) {
        
        String currentPassword = request.get("currentPassword");
        String newPassword = request.get("newPassword");
        
        if (currentPassword == null || newPassword == null) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error("Current password and new password are required"));
        }
        
        ApiResponse response = authService.changePassword(
            userPrincipal.getId(), 
            currentPassword, 
            newPassword
        );
        
        if (response.getSuccess()) {
            return ResponseEntity.ok(response);
        } else {
            return ResponseEntity.badRequest().body(response);
        }
    }

    @PostMapping("/forgot-password")
    public ResponseEntity<?> forgotPassword(@RequestBody Map<String, String> request) {
        String email = request.get("email");
        
        if (email == null || email.trim().isEmpty()) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error("Email is required"));
        }
        
        ApiResponse response = authService.resetPassword(email);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/reset-password")
    public ResponseEntity<?> resetPassword(@RequestBody Map<String, String> request) {
        String token = request.get("token");
        String newPassword = request.get("newPassword");
        
        if (token == null || newPassword == null) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error("Token and new password are required"));
        }
        
        ApiResponse response = authService.confirmPasswordReset(token, newPassword);
        
        if (response.getSuccess()) {
            return ResponseEntity.ok(response);
        } else {
            return ResponseEntity.badRequest().body(response);
        }
    }

    @GetMapping("/me")
    public ResponseEntity<?> getCurrentUser(@AuthenticationPrincipal UserPrincipal userPrincipal) {
        return ResponseEntity.ok(ApiResponse.success("User details retrieved successfully", Map.of(
            "id", userPrincipal.getId(),
            "username", userPrincipal.getUsername(),
            "email", userPrincipal.getEmail(),
            "firstName", userPrincipal.getFirstName(),
            "lastName", userPrincipal.getLastName(),
            "authorities", userPrincipal.getAuthorities()
        )));
    }

    @PostMapping("/logout")
    public ResponseEntity<?> logout() {
        // In a stateless JWT implementation, logout is typically handled client-side
        // by removing the token from storage
        return ResponseEntity.ok(ApiResponse.success("Logged out successfully"));
    }
}