package com.ruoyi.experiment.pojo.dto;

import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 文献查询参数DTO
 */
@Data
public class LiteratureQueryDTO {
    /**
     * 文献名称（模糊查询）
     */
    private String title;
    
    /**
     * 发表时间开始
     */
    private LocalDate publishTimeStart;
    
    /**
     * 发表时间结束
     */
    private LocalDate publishTimeEnd;
    
    /**
     * 关键词ID列表（用于根据关键词筛选文献）
     */
    private List<Long> keywordIds;
    
    /**
     * 关键词ID列表大小（用于AND逻辑查询）
     */
    private Integer keywordIdsSize;
    
    /**
     * 排序字段（publishTime, downloadCount, finalScore）
     */
    private String sortField;
    
    /**
     * 排序方式（asc, desc）
     */
    private String sortOrder;
     /**
     * 用户id
     */
    private Long userId;
}