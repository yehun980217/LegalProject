package com.kpaas.kpaasproject;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.kpaas.kpaasproject.mapper")  // MyBatis 매퍼가 있는 패키지 스캔
public class KPaasProjectApplication {

    public static void main(String[] args) {
        SpringApplication.run(KPaasProjectApplication.class, args);
    }
}
