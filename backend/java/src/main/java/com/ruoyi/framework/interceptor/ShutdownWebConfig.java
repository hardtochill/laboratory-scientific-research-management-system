package com.ruoyi.framework.interceptor;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class ShutdownWebConfig implements WebMvcConfigurer {
    @Autowired
    private ShutdownInterceptor shutdownInterceptor;

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(shutdownInterceptor)
                .addPathPatterns("/**"); // 拦截所有接口
    }
}
