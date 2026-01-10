package com.ruoyi.experiment.pojo.dto;

import com.ruoyi.experiment.pojo.entity.BaseEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * 投稿流程审核查询DTO
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ReviewQueryDTO extends BaseEntity {
    /**
     * 所属投稿计划ID
     */
     private Long planId;
    /**
      * 所属投稿流程ID
      */
     private Long processId;
    /**
     * 被审核人ID
     */
     private Long reviewedUserId;
    /**
     * 审核人ID
     */
     private Long reviewerUserId;
    /**
     * 审核状态：1待审核、2审核通过、3审核不通过
     */
     private Integer status;
    /**
     * 审核发起时间-起始
     */
     private LocalDateTime reviewCreateTimeStart;
    /**
     * 审核发起时间-结束
     */
     private LocalDateTime reviewCreateTimeEnd;

}
