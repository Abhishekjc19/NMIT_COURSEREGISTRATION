package com.nmit.portal.dto;

public class ApiResponse {
    
    private Boolean success;
    private String message;
    private Object data;
    
    // Constructors
    public ApiResponse() {}
    
    public ApiResponse(Boolean success, String message) {
        this.success = success;
        this.message = message;
    }
    
    public ApiResponse(Boolean success, String message, Object data) {
        this.success = success;
        this.message = message;
        this.data = data;
    }
    
    // Static methods for common responses
    public static ApiResponse success(String message) {
        return new ApiResponse(true, message);
    }
    
    public static ApiResponse success(String message, Object data) {
        return new ApiResponse(true, message, data);
    }
    
    public static ApiResponse error(String message) {
        return new ApiResponse(false, message);
    }
    
    public static ApiResponse error(String message, Object data) {
        return new ApiResponse(false, message, data);
    }
    
    // Getters and Setters
    public Boolean getSuccess() {
        return success;
    }
    
    public void setSuccess(Boolean success) {
        this.success = success;
    }
    
    public String getMessage() {
        return message;
    }
    
    public void setMessage(String message) {
        this.message = message;
    }
    
    public Object getData() {
        return data;
    }
    
    public void setData(Object data) {
        this.data = data;
    }
}