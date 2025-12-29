package com.ruoyi.framework.config;

import com.alibaba.fastjson.TypeReference;
import com.alibaba.fastjson.serializer.SerializeConfig;
import com.alibaba.fastjson.serializer.SerializeWriter;
import com.alibaba.fastjson.serializer.SerializerFeature;
import com.alibaba.fastjson.serializer.ToStringSerializer;
import com.alibaba.fastjson.support.config.FastJsonConfig;
import com.alibaba.fastjson.support.spring.FastJsonHttpMessageConverter;
import com.alibaba.fastjson.serializer.JSONSerializer;
import org.springframework.context.annotation.Configuration;
import org.springframework.format.FormatterRegistry;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.io.IOException;
import java.time.LocalDate;
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
        
        // Long类型转换为字符串
        serializeConfig.put(Long.class, ToStringSerializer.instance);
        serializeConfig.put(Long.TYPE, ToStringSerializer.instance);
        
        // LocalDate类型转换为字符串
        serializeConfig.put(LocalDate.class, new LocalDateSerializer());
        
        // LocalDateTime类型转换为字符串
        serializeConfig.put(LocalDateTime.class, new LocalDateTimeSerializer());
        
        fjc.setSerializerFeatures(SerializerFeature.DisableCircularReferenceDetect);
        fjc.setSerializeConfig(serializeConfig);
        fastJsonConverter.setFastJsonConfig(fjc);
        converters.add(0, fastJsonConverter);

    }

    @Override
    public void addFormatters(FormatterRegistry registry) {
        registry.addFormatterForFieldType(LocalDateTime.class, new LocalDateTimeFormatter());
        registry.addFormatterForFieldType(LocalDate.class, new LocalDateFormatter());
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

    private static class LocalDateFormatter implements org.springframework.format.Formatter<LocalDate> {

        private final DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

        @Override
        public LocalDate parse(String text, java.util.Locale locale) {
            return LocalDate.parse(text, dateFormatter);
        }

        @Override
        public String print(LocalDate object, java.util.Locale locale) {
            return dateFormatter.format(object);
        }
    }

    /**
     * LocalDate序列化器
     */
    private static class LocalDateSerializer implements com.alibaba.fastjson.serializer.ObjectSerializer {
        @Override
        public void write(JSONSerializer serializer, Object object, Object fieldName, java.lang.reflect.Type fieldType, int features) throws IOException {
            if (object == null) {
                serializer.writeNull();
            } else {
                LocalDate date = (LocalDate) object;
                serializer.write(date.format(DateTimeFormatter.ofPattern("yyyy-MM-dd")));
            }
        }
    }

    /**
     * LocalDateTime序列化器
     */
    private static class LocalDateTimeSerializer implements com.alibaba.fastjson.serializer.ObjectSerializer {
        @Override
        public void write(JSONSerializer serializer, Object object, Object fieldName, java.lang.reflect.Type fieldType, int features) throws IOException {
            if (object == null) {
                serializer.writeNull();
            } else {
                LocalDateTime dateTime = (LocalDateTime) object;
                serializer.write(dateTime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
            }
        }
    }
}
