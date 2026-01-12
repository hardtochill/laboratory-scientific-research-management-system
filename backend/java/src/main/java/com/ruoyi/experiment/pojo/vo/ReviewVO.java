package com.ruoyi.experiment.pojo.vo;

import com.ruoyi.experiment.pojo.entity.BaseEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * 投稿流程审核表
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ReviewVO{
    /**
     * 审核ID
     */
     private Long id;
    /**
     * 所属投稿计划ID
     */
     private Long planId;
    /**
     * 所属投稿计划名称
     */
     private String planName;
    /**
      * 所属投稿流程ID
      */
     private Long processId;
    /**
     * 所属投稿流程名称
     */
     private String processName;
    /**
     * 被审核人ID
     */
     private Long reviewedUserId;
     /**
      * 被审核人昵称
      */
     private String reviewedUserNickName;
    /**
     * 审核人ID
     */
     private Long reviewerUserId;
      /**
       * 审核人昵称
       */
     private String reviewerUserNickName;
    /**
     * 审核状态：1待审核、2审核通过、3审核不通过
     */
     private Integer status;
    /**
     * 被审核人备注
     */
    private String reviewedRemark;
    /**
     * 审核人备注
     */
    private String reviewerRemark;
    /**
     * 审核发起时间
     */
    private LocalDateTime reviewCreateTime;
    /**
     * 审核结束时间
     */
     private LocalDateTime reviewFinishTime;
}
