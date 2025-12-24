package com.ruoyi.experiment.pojo.dto;

import lombok.Data;

/**
 * 文献心得查询DTO
 */
@Data
public class LiteratureNoteQueryDTO {
    /**
     * 文献id
     */
    private Long literatureId;
    /**
     * 排序字段
     */
    private String sortField;
    
    /**
     * 排序顺序
     */
    private String sortOrder;
}