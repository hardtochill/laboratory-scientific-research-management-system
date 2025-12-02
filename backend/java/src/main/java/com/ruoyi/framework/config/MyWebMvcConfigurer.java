package com.ruoyi.framework.config;

import com.alibaba.fastjson.TypeReference;
import com.alibaba.fastjson.serializer.SerializeConfig;
import com.alibaba.fastjson.serializer.SerializeWriter;
import com.alibaba.fastjson.serializer.SerializerFeature;
import com.alibaba.fastjson.serializer.ToStringSerializer;
import com.alibaba.fastjson.support.config.FastJsonConfig;
import com.alibaba.fastjson.support.spring.FastJsonHttpMessageConverter;
import org.springframework.context.annotation.Configuration;
import org.springframework.format.FormatterRegistry;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

/**
 * 后台返回的数据中的long类型字段转化为字符串
 *
 * @author LiQiao
 * @since 2022/10/10
 */
@Configuration
public class MyWebMvcConfigurer implements WebMvcConfigurer {

    @Override
    public void configureMessageConverters(List<HttpMessageConverter<?>> converters) {
        FastJsonHttpMessageConverter fastJsonConverter = new FastJsonHttpMessageConverter();
        FastJsonConfig fjc = new FastJsonConfig();
        fjc.setDateFormat("yyyy-MM-dd HH:mm:ss");
        SerializeConfig serializeConfig = SerializeConfig.globalInstance;
        serializeConfig.put(Long.class, ToStringSerializer.instance);
        serializeConfig.put(Long.TYPE, ToStringSerializer.instance);
        fjc.setSerializerFeatures(SerializerFeature.DisableCircularReferenceDetect);
        fjc.setSerializeConfig(serializeConfig);
        fastJsonConverter.setFastJsonConfig(fjc);
        converters.add(0, fastJsonConverter);

    }

    @Override
    public void addFormatters(FormatterRegistry registry) {
        registry.addFormatterForFieldType(LocalDateTime.class, new LocalDateTimeFormatter());
    }

    private static class LocalDateTimeFormatter implements org.springframework.format.Formatter<LocalDateTime> {

        private final DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

        @Override
        public LocalDateTime parse(String text, java.util.Locale locale) {
            return LocalDateTime.parse(text, dateTimeFormatter);
        }

        @Override
        public String print(LocalDateTime object, java.util.Locale locale) {
            return dateTimeFormatter.format(object);
        }
    }
}
