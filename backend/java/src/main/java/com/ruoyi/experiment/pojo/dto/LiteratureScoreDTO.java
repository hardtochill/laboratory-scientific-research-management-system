package com.ruoyi.experiment.pojo.dto;

import lombok.Data;

/**
 * 文献评分请求DTO
 */
@Data
public class LiteratureScoreDTO {
    /**
     * 文献id
     */
    private Long literatureId;
    /**
     * 评分（0-10）
     */
    private Integer score;
}