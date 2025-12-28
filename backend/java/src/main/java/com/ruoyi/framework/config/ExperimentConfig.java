package com.ruoyi.framework.config;

import lombok.Data;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

@Component
@ConfigurationProperties(prefix = "experiment")
@Data
public class ExperimentConfig {
    /**
     * 任务文件存储路径
     */
    @Value("${experiment.task.baseDir}")
    private String taskBaseDir;
    /**
     * 文献存储路径
     */
    @Value("${experiment.literature.baseDir}")
    private String literatureBaseDir;
}
