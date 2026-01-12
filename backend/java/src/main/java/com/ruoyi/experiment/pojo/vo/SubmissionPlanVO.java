package com.ruoyi.experiment.pojo.vo;

import com.ruoyi.experiment.pojo.entity.BaseEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * 投稿计划
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class SubmissionPlanVO{
    /**
     * 投稿计划ID
     */
    private Long id;
     /**
     * 投稿计划名称
     */
    private String name;
}
