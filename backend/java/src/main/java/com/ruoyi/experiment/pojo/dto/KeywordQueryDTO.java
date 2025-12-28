package com.ruoyi.experiment.pojo.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * 关键词查询参数DTO
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class KeywordQueryDTO {
    /**
     * 关键词名称（模糊查询）
     */
    private String keywordName;
}