package com.nmit.portal;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

@SpringBootApplication
@EnableJpaRepositories
@EnableJpaAuditing
public class NmitPortalApplication {

    public static void main(String[] args) {
        SpringApplication.run(NmitPortalApplication.class, args);
    }
}