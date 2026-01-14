package com.ruoyi.experiment.pojo.dto;

import com.ruoyi.experiment.pojo.entity.BaseEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 文献阅读查询参数DTO
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class LiteratureReadQueryDTO {
    /**
     * 文献id
     */
    private Long literatureId;
    /**
     * 关键词ID列表（用于根据关键词筛选文献）
     */
    private List<Long> keywordIds;

    /**
     * 关键词ID列表大小（用于AND逻辑查询）
     */
    private Integer keywordIdsSize;
    /**
     * 起始时间
     */
    private LocalDateTime startTime;
    /**
     * 结束时间
     */
    private LocalDateTime endTime;
    /**
     * 用户id
     */
    private Long userId;
}