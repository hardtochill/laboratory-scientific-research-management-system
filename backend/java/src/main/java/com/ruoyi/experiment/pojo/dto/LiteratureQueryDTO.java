package com.ruoyi.experiment.pojo.dto;

import lombok.Data;
import java.time.LocalDateTime;

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
    private LocalDateTime publishTimeStart;
    
    /**
     * 发表时间结束
     */
    private LocalDateTime publishTimeEnd;
    
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