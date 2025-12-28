package com.ruoyi.experiment.pojo.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 关键词VO
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class KeywordVO {
    /**
     * 关键词id
     */
    private Long id;
    /**
     * 关键词名称
     */
    private String keywordName;
    /**
     * 关键词描述
     */
    private String description;
    /**
     * 使用次数
     */
    private Integer usageCount;
}