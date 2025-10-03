package com.nmit.portal.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Email;

import java.time.LocalDate;

@Entity
@Table(name = "admission_applications")
public class AdmissionApplication extends BaseEntity {

    @NotBlank
    @Column(name = "application_number", unique = true, nullable = false)
    private String applicationNumber;

    @NotBlank
    @Column(name = "applicant_name", nullable = false)
    private String applicantName;

    @Email
    @Column(name = "email", nullable = false)
    private String email;

    @Column(name = "phone_number")
    private String phoneNumber;

    @Column(name = "date_of_birth")
    private LocalDate dateOfBirth;

    @Column(name = "gender")
    private String gender;

    @Column(name = "address", length = 500)
    private String address;

    @Column(name = "course_applied")
    private String courseApplied;

    @Column(name = "entrance_exam_score")
    private Double entranceExamScore;

    @Column(name = "class_12_percentage")
    private Double class12Percentage;

    @Column(name = "class_10_percentage")
    private Double class10Percentage;

    @Column(name = "application_status")
    private String applicationStatus; // Applied, Under Review, Approved, Rejected, Admitted

    @Column(name = "application_date")
    private LocalDate applicationDate;

    @Column(name = "admission_date")
    private LocalDate admissionDate;

    @Column(name = "fee_paid")
    private Double feePaid;

    @Column(name = "parent_name")
    private String parentName;

    @Column(name = "parent_phone")
    private String parentPhone;

    @Column(name = "parent_occupation")
    private String parentOccupation;

    @Column(name = "remarks", length = 500)
    private String remarks;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "department_id")
    private Department department;

    // Constructors
    public AdmissionApplication() {}

    public AdmissionApplication(String applicationNumber, String applicantName, String email) {
        this.applicationNumber = applicationNumber;
        this.applicantName = applicantName;
        this.email = email;
        this.applicationDate = LocalDate.now();
        this.applicationStatus = "Applied";
    }

    // Getters and Setters
    public String getApplicationNumber() {
        return applicationNumber;
    }

    public void setApplicationNumber(String applicationNumber) {
        this.applicationNumber = applicationNumber;
    }

    public String getApplicantName() {
        return applicantName;
    }

    public void setApplicantName(String applicantName) {
        this.applicantName = applicantName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public LocalDate getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(LocalDate dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getCourseApplied() {
        return courseApplied;
    }

    public void setCourseApplied(String courseApplied) {
        this.courseApplied = courseApplied;
    }

    public Double getEntranceExamScore() {
        return entranceExamScore;
    }

    public void setEntranceExamScore(Double entranceExamScore) {
        this.entranceExamScore = entranceExamScore;
    }

    public Double getClass12Percentage() {
        return class12Percentage;
    }

    public void setClass12Percentage(Double class12Percentage) {
        this.class12Percentage = class12Percentage;
    }

    public Double getClass10Percentage() {
        return class10Percentage;
    }

    public void setClass10Percentage(Double class10Percentage) {
        this.class10Percentage = class10Percentage;
    }

    public String getApplicationStatus() {
        return applicationStatus;
    }

    public void setApplicationStatus(String applicationStatus) {
        this.applicationStatus = applicationStatus;
    }

    public LocalDate getApplicationDate() {
        return applicationDate;
    }

    public void setApplicationDate(LocalDate applicationDate) {
        this.applicationDate = applicationDate;
    }

    public LocalDate getAdmissionDate() {
        return admissionDate;
    }

    public void setAdmissionDate(LocalDate admissionDate) {
        this.admissionDate = admissionDate;
    }

    public Double getFeePaid() {
        return feePaid;
    }

    public void setFeePaid(Double feePaid) {
        this.feePaid = feePaid;
    }

    public String getParentName() {
        return parentName;
    }

    public void setParentName(String parentName) {
        this.parentName = parentName;
    }

    public String getParentPhone() {
        return parentPhone;
    }

    public void setParentPhone(String parentPhone) {
        this.parentPhone = parentPhone;
    }

    public String getParentOccupation() {
        return parentOccupation;
    }

    public void setParentOccupation(String parentOccupation) {
        this.parentOccupation = parentOccupation;
    }

    public String getRemarks() {
        return remarks;
    }

    public void setRemarks(String remarks) {
        this.remarks = remarks;
    }

    public Department getDepartment() {
        return department;
    }

    public void setDepartment(Department department) {
        this.department = department;
    }
}