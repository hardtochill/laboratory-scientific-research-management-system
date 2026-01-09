package com.ruoyi.experiment.pojo.dto;

import com.ruoyi.experiment.pojo.entity.BaseEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * 投稿计划查询DTO
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class SubmissionPlanQueryDTO{
    /**
     * 投稿计划ID
     */
    private Long id;
     /**
     * 投稿计划名称
     */
    private String name;
    /**
     * 创建用户id
     */
    private Long createUserId;
    /**
     * 创建用户昵称
     */
    private String createUserNickName;
    /**
     * 投稿状态：1待送审、2审核中、3发表成功、4发表失败
     */
    private Integer status;
}
