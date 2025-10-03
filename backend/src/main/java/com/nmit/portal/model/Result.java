package com.nmit.portal.model;

import jakarta.persistence.*;

@Entity
@Table(name = "results", uniqueConstraints = {
    @UniqueConstraint(columnNames = {"student_id", "course_id", "exam_type", "academic_year"})
})
public class Result extends BaseEntity {

    @Column(name = "internal_marks")
    private Double internalMarks;

    @Column(name = "external_marks")
    private Double externalMarks;

    @Column(name = "total_marks")
    private Double totalMarks;

    @Column(name = "grade")
    private String grade;

    @Column(name = "grade_points")
    private Double gradePoints;

    @Column(name = "exam_type")
    private String examType; // Regular, Supplementary, Revaluation

    @Column(name = "academic_year")
    private String academicYear;

    @Column(name = "result_status")
    private String resultStatus; // Pass, Fail, Absent

    // Relationships
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "student_id", nullable = false)
    private Student student;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "course_id", nullable = false)
    private Course course;

    // Constructors
    public Result() {}

    public Result(Student student, Course course, String academicYear) {
        this.student = student;
        this.course = course;
        this.academicYear = academicYear;
    }

    // Getters and Setters
    public Double getInternalMarks() {
        return internalMarks;
    }

    public void setInternalMarks(Double internalMarks) {
        this.internalMarks = internalMarks;
    }

    public Double getExternalMarks() {
        return externalMarks;
    }

    public void setExternalMarks(Double externalMarks) {
        this.externalMarks = externalMarks;
    }

    public Double getTotalMarks() {
        return totalMarks;
    }

    public void setTotalMarks(Double totalMarks) {
        this.totalMarks = totalMarks;
    }

    public String getGrade() {
        return grade;
    }

    public void setGrade(String grade) {
        this.grade = grade;
    }

    public Double getGradePoints() {
        return gradePoints;
    }

    public void setGradePoints(Double gradePoints) {
        this.gradePoints = gradePoints;
    }

    public String getExamType() {
        return examType;
    }

    public void setExamType(String examType) {
        this.examType = examType;
    }

    public String getAcademicYear() {
        return academicYear;
    }

    public void setAcademicYear(String academicYear) {
        this.academicYear = academicYear;
    }

    public String getResultStatus() {
        return resultStatus;
    }

    public void setResultStatus(String resultStatus) {
        this.resultStatus = resultStatus;
    }

    public Student getStudent() {
        return student;
    }

    public void setStudent(Student student) {
        this.student = student;
    }

    public Course getCourse() {
        return course;
    }

    public void setCourse(Course course) {
        this.course = course;
    }
}