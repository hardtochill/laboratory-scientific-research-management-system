package com.ruoyi.experiment.pojo.entity;

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
public class SubmissionPlan extends BaseEntity{
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
    private String createUserNickname;
    /**
     * 投稿类型：学术论文、专利、软件著作权
     */
     private Integer type;
    /**
     * 投稿期刊
     */
     private String journal;
    /**
     * 投稿状态：1待送审、2审核中、3发表成功、4发表失败
     */
     private Integer status;
    /**
     * 备注
     */
     private String remark;
    /**
     * 创建时间
     */
     private LocalDateTime plan_create_time;
}
