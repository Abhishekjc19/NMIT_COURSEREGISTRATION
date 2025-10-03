package com.nmit.portal.service;

import com.nmit.portal.dto.ApiResponse;
import com.nmit.portal.dto.JwtAuthenticationResponse; 
import com.nmit.portal.dto.LoginRequest;
import com.nmit.portal.dto.StudentLoginRequest;
import com.nmit.portal.model.User;
import com.nmit.portal.model.Student;
import com.nmit.portal.repository.StudentRepository;
import com.nmit.portal.repository.UserRepository;
import com.nmit.portal.security.JwtTokenProvider;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Optional;

@Service
public class AuthService {

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private JwtTokenProvider tokenProvider;

    @Autowired
    private StudentRepository studentRepository;

    public JwtAuthenticationResponse authenticateUser(LoginRequest loginRequest) {
        
        Authentication authentication = authenticationManager.authenticate(
            new UsernamePasswordAuthenticationToken(
                loginRequest.getUsernameOrEmail(),
                loginRequest.getPassword()
            )
        );

        SecurityContextHolder.getContext().setAuthentication(authentication);

        String jwt = tokenProvider.generateToken(authentication);
        
        // Update last login time
        Optional<User> userOptional = userRepository.findByUsernameOrEmail(
            loginRequest.getUsernameOrEmail(), 
            loginRequest.getUsernameOrEmail()
        );
        
        if (userOptional.isPresent()) {
            User user = userOptional.get();
            user.setLastLogin(LocalDateTime.now());
            userRepository.save(user);
            
            return new JwtAuthenticationResponse(
                jwt, 
                user.getId(), 
                user.getUsername(),
                user.getEmail(),
                user.getRole().name(),
                user.getFullName()
            );
        }
        
        throw new RuntimeException("User not found after authentication");
    }

    public ApiResponse changePassword(Long userId, String currentPassword, String newPassword) {
        Optional<User> userOptional = userRepository.findById(userId);
        
        if (userOptional.isEmpty()) {
            return ApiResponse.error("User not found");
        }
        
        User user = userOptional.get();
        
        if (!passwordEncoder.matches(currentPassword, user.getPassword())) {
            return ApiResponse.error("Current password is incorrect");
        }
        
        if (currentPassword.equals(newPassword)) {
            return ApiResponse.error("New password must be different from current password");
        }
        
        user.setPassword(passwordEncoder.encode(newPassword));
        user.setUpdatedBy(user.getUsername());
        userRepository.save(user);
        
        return ApiResponse.success("Password changed successfully");
    }

    public ApiResponse resetPassword(String email) {
        Optional<User> userOptional = userRepository.findByEmail(email);
        
        if (userOptional.isEmpty()) {
            return ApiResponse.error("User not found with email: " + email);
        }
        
        User user = userOptional.get();
        
        // Generate reset token (in real implementation, you'd send email)
        String resetToken = java.util.UUID.randomUUID().toString();
        user.setPasswordResetToken(resetToken);
        user.setTokenExpiry(LocalDateTime.now().plusHours(24)); // 24 hours expiry
        
        userRepository.save(user);
        
        // TODO: Send email with reset token
        
        return ApiResponse.success("Password reset email sent successfully");
    }

    public ApiResponse confirmPasswordReset(String token, String newPassword) {
        Optional<User> userOptional = userRepository.findByPasswordResetToken(token);
        
        if (userOptional.isEmpty()) {
            return ApiResponse.error("Invalid reset token");
        }
        
        User user = userOptional.get();
        
        if (user.getTokenExpiry().isBefore(LocalDateTime.now())) {
            return ApiResponse.error("Reset token has expired");
        }
        
        user.setPassword(passwordEncoder.encode(newPassword));
        user.setPasswordResetToken(null);
        user.setTokenExpiry(null);
        user.setUpdatedBy("SYSTEM");
        
        userRepository.save(user);
        
        return ApiResponse.success("Password reset successfully");
    }

    public JwtAuthenticationResponse authenticateStudent(StudentLoginRequest studentLoginRequest) {
        String usnNormalized = studentLoginRequest.getUsn().trim().toLowerCase();
        Optional<User> userOptional = userRepository.findByUsername(usnNormalized);
        if (userOptional.isEmpty()) {
            throw new RuntimeException("Student not found with USN: " + studentLoginRequest.getUsn());
        }
        User user = userOptional.get();

        // Load student to verify DOB
        Optional<Student> studentOpt = studentRepository.findByUserId(user.getId());
        if (studentOpt.isEmpty()) {
            throw new RuntimeException("Student profile not linked for USN: " + studentLoginRequest.getUsn());
        }
        Student student = studentOpt.get();
        if (student.getDateOfBirth() == null) {
            throw new RuntimeException("Date of birth not set for student: " + studentLoginRequest.getUsn());
        }

        java.time.LocalDate suppliedDob = parseFlexibleDate(studentLoginRequest.getDob());
        if (!student.getDateOfBirth().isEqual(suppliedDob)) {
            throw new RuntimeException("Invalid DOB for USN: " + studentLoginRequest.getUsn());
        }

        // Ensure a password exists; if not, set a default encoded one (one-time migration safety)
        if (user.getPassword() == null || user.getPassword().isBlank()) {
            user.setPassword(passwordEncoder.encode("student123"));
            userRepository.save(user);
        }

        Authentication authentication = authenticationManager.authenticate(
            new UsernamePasswordAuthenticationToken(usnNormalized, "student123")
        );
        SecurityContextHolder.getContext().setAuthentication(authentication);
        String jwt = tokenProvider.generateToken(authentication);

        user.setUpdatedBy("SYSTEM");
        userRepository.save(user);

        return new JwtAuthenticationResponse(
            jwt,
            user.getId(),
            user.getUsername(),
            user.getEmail(),
            user.getRole().name(),
            user.getFirstName() + " " + user.getLastName()
        );
    }

    private java.time.LocalDate parseFlexibleDate(String input) {
        String trimmed = input.trim();
        java.time.format.DateTimeFormatter iso = java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd");
        java.time.format.DateTimeFormatter slash = java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy");
        try {
            if (trimmed.contains("/")) {
                return java.time.LocalDate.parse(trimmed, slash);
            }
            return java.time.LocalDate.parse(trimmed, iso);
        } catch (Exception ex) {
            throw new RuntimeException("Invalid date format. Use YYYY-MM-DD or DD/MM/YYYY");
        }
    }
}