package com.ruoyi.framework.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;

@Configuration
@EnableWebSocketMessageBroker
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {
    // 注册 WebSocket 端点
    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        // 客户端连接端点 /ws ，支持 SockJS
        registry.addEndpoint("/ws").setAllowedOriginPatterns("*").withSockJS()
                .setClientLibraryUrl("/lib/sockjs.min.js");
    }

    // 设置消息代理
    @Override
    public void configureMessageBroker(MessageBrokerRegistry registry) {
        // 客户端订阅的消息前缀，比如：/topic/chat
        registry.enableSimpleBroker("/topic");

        // 客户端发送消息时的前缀，比如发送到 /app/send
        registry.setApplicationDestinationPrefixes("/app");
    }


}
