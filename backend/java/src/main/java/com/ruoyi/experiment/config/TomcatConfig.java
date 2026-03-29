package com.ruoyi.experiment.config;

import org.apache.catalina.connector.Connector;
import org.springframework.boot.web.embedded.tomcat.TomcatConnectorCustomizer;
import org.springframework.boot.web.embedded.tomcat.TomcatServletWebServerFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * Tomcat配置类，用于解决文件上传时的文件数量限制问题
 */
@Configuration
public class TomcatConfig {

    @Bean
    public TomcatServletWebServerFactory tomcatServletWebServerFactory() {
        TomcatServletWebServerFactory factory = new TomcatServletWebServerFactory();
        factory.addConnectorCustomizers(new TomcatConnectorCustomizer() {
            @Override
            public void customize(Connector connector) {
                // 设置最大参数数量限制为1000，解决文件数量限制问题
                connector.setProperty("maxParameterCount", "1000");
                // 设置最大POST请求大小为20MB
                connector.setProperty("maxPostSize", "20971520");
                // 设置最大保存POST请求大小为20MB
                connector.setProperty("maxSavePostSize", "20971520");
                // 设置连接超时时间
                connector.setProperty("connectionTimeout", "60000");
            }
        });
        return factory;
    }
}