package com.ruoyi.experiment.pojo.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class SubmissionProcess extends BaseEntity{
    /**
     * 投稿流程ID
     */
    private Long id;
    /**
     * 所属投稿计划ID
     */
    private Long planId;
    /**
     * 流程名称，例如：一审、、二审等
     */
     private String name;
    /**
     * 审核人ID
     */
     private Long reviewerUserId;
     /**
      * 审核人昵称
      */
     private String reviewerUserNickName;
     /**
      * 审核状态：1待发起内部审核、2内部审核中、3内部审核通过、4内部审核不通过
      */
     private Integer status;
    /**
     * 审核备注
     */
     private String remark;
    /**
     * 流程创建时间
     */
     private LocalDateTime process_create_time;
}
