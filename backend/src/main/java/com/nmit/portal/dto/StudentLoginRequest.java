package com.nmit.portal.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import jakarta.validation.constraints.Pattern;

public class StudentLoginRequest {
    
    @NotBlank
    @Size(max = 20)
    @Pattern(regexp = "^[0-9][A-Z]{2}[0-9]{2}[A-Z]{2}[0-9]{3}$", message = "USN format should be like 4NM27AI001")
    private String usn;
    
    @NotBlank
    // Accept flexible input; format validation handled in service (supports YYYY-MM-DD or DD/MM/YYYY)
    private String dob;
    
    // Constructors
    public StudentLoginRequest() {}
    
    public StudentLoginRequest(String usn, String dob) {
        this.usn = usn;
        this.dob = dob;
    }
    
    // Getters and Setters
    public String getUsn() {
        return usn;
    }
    
    public void setUsn(String usn) {
        this.usn = usn;
    }
    
    public String getDob() {
        return dob;
    }
    
    public void setDob(String dob) {
        this.dob = dob;
    }
    
    @Override
    public String toString() {
        return "StudentLoginRequest{" +
                "usn='" + usn + '\'' +
                ", dob='" + dob + '\'' +
                '}';
    }
}