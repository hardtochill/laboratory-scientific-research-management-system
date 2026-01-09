package com.ruoyi.experiment.pojo.dto;

import com.ruoyi.experiment.pojo.entity.BaseEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotNull;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class SubmissionProcessDTO{
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
     * 流程备注
     */
     private String remark;
}
