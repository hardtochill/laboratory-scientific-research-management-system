package com.ruoyi.experiment.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;

/**
 * 文件上传配置类，用于解决Tomcat 9.0.106+版本的文件数量限制问题
 */
@Configuration
public class MultipartConfig {

    @Bean(name = "multipartResolver")
    public CommonsMultipartResolver multipartResolver() {
        CommonsMultipartResolver resolver = new CommonsMultipartResolver();
        // 设置最大上传文件大小为10MB
        resolver.setMaxUploadSize(10 * 1024 * 1024);
        // 设置单个文件大小为10MB
        resolver.setMaxUploadSizePerFile(10 * 1024 * 1024);
        // 设置最大文件数量限制为1000
        resolver.setMaxInMemorySize(4096);
        // 设置默认编码
        resolver.setDefaultEncoding("UTF-8");
        return resolver;
    }
}