package com.nmit.portal.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api")
public class NoticeController {

    @GetMapping("/notices")
    public ResponseEntity<List<Map<String, Object>>> getNotices() {
        // Return sample notices for the login page
        List<Map<String, Object>> notices = new ArrayList<>();
        
        Map<String, Object> notice1 = new HashMap<>();
        notice1.put("id", 1);
        notice1.put("message", "Welcome to NMIT Course Registration Portal");
        notices.add(notice1);
        
        Map<String, Object> notice2 = new HashMap<>();
        notice2.put("id", 2);
        notice2.put("message", "Course registration for Semester 5 is now open");
        notices.add(notice2);
        
        Map<String, Object> notice3 = new HashMap<>();
        notice3.put("id", 3);
        notice3.put("message", "Please verify your attendance percentage before registration");
        notices.add(notice3);
        
        return ResponseEntity.ok(notices);
    }
}
