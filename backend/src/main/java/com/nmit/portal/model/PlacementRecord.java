package com.nmit.portal.model;

import jakarta.persistence.*;

import java.time.LocalDate;

@Entity
@Table(name = "placement_records")
public class PlacementRecord extends BaseEntity {

    @Column(name = "company_name", nullable = false)
    private String companyName;

    @Column(name = "job_title")
    private String jobTitle;

    @Column(name = "package_offered")
    private Double packageOffered;

    @Column(name = "job_location")
    private String jobLocation;

    @Column(name = "placement_date")
    private LocalDate placementDate;

    @Column(name = "offer_letter_date")
    private LocalDate offerLetterDate;

    @Column(name = "joining_date")
    private LocalDate joiningDate;

    @Column(name = "placement_type")
    private String placementType; // Campus, Off-Campus, Higher Studies

    @Column(name = "status")
    private String status; // Placed, Offer Received, Joined, Declined

    @Column(name = "company_category")
    private String companyCategory; // Product, Service, Startup, MNC

    @Column(name = "remarks", length = 500)
    private String remarks;

    // Relationships
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "student_id", nullable = false)
    private Student student;

    // Constructors
    public PlacementRecord() {}

    public PlacementRecord(Student student, String companyName) {
        this.student = student;
        this.companyName = companyName;
    }

    // Getters and Setters
    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getJobTitle() {
        return jobTitle;
    }

    public void setJobTitle(String jobTitle) {
        this.jobTitle = jobTitle;
    }

    public Double getPackageOffered() {
        return packageOffered;
    }

    public void setPackageOffered(Double packageOffered) {
        this.packageOffered = packageOffered;
    }

    public String getJobLocation() {
        return jobLocation;
    }

    public void setJobLocation(String jobLocation) {
        this.jobLocation = jobLocation;
    }

    public LocalDate getPlacementDate() {
        return placementDate;
    }

    public void setPlacementDate(LocalDate placementDate) {
        this.placementDate = placementDate;
    }

    public LocalDate getOfferLetterDate() {
        return offerLetterDate;
    }

    public void setOfferLetterDate(LocalDate offerLetterDate) {
        this.offerLetterDate = offerLetterDate;
    }

    public LocalDate getJoiningDate() {
        return joiningDate;
    }

    public void setJoiningDate(LocalDate joiningDate) {
        this.joiningDate = joiningDate;
    }

    public String getPlacementType() {
        return placementType;
    }

    public void setPlacementType(String placementType) {
        this.placementType = placementType;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getCompanyCategory() {
        return companyCategory;
    }

    public void setCompanyCategory(String companyCategory) {
        this.companyCategory = companyCategory;
    }

    public String getRemarks() {
        return remarks;
    }

    public void setRemarks(String remarks) {
        this.remarks = remarks;
    }

    public Student getStudent() {
        return student;
    }

    public void setStudent(Student student) {
        this.student = student;
    }
}