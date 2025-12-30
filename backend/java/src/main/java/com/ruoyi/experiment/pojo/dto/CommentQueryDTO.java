package com.ruoyi.experiment.pojo.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.util.List;

/**
 * 文献评论查询参数DTO
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class CommentQueryDTO {
    /**
     * 父评论id
     */
    private Long parentId;
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
    /**
     * 发表用户id
     */
    private Long userId;
}