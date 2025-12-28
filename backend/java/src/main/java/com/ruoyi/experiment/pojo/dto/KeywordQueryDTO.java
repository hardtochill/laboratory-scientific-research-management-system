package com.ruoyi.experiment.pojo.dto;

import lombok.Data;

import java.time.LocalDateTime;

/**
 * 关键词查询参数DTO
 */
@Data
public class KeywordQueryDTO {
    /**
     * 关键词名称（模糊查询）
     */
    private String keywordName;
}