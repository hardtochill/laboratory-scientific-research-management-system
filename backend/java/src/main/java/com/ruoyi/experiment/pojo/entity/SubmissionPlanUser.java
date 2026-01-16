package com.ruoyi.experiment.pojo.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 投稿计划关联用户表
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
public class SubmissionPlanUser extends BaseEntity{
    /**
     * id
     */
    private Long id;
    /**
     * 计划id
     */
    private Long planId;
     /**
     * 用户id
     */
    private Long userId;
}
