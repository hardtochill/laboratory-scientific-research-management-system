package com.ruoyi.framework.interceptor;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Component
public class ShutdownInterceptor implements HandlerInterceptor {
    @Value("${expirationDate}")
    private String expirationDate;
    private final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime shutdownTime = LocalDateTime.parse(expirationDate, formatter);
        if (now.isAfter(shutdownTime)) {
            response.setStatus(HttpStatus.FORBIDDEN.value());
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"code\":403,\"msg\":\"系统已停止服务，请联系管理员。\"}");
            return false;
        }
        return true;
    }
}
