package com.ruoyi.experiment.pojo.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotNull;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class DoReviewDTO {
    /**
     * 审核ID
     */
    @NotNull(message = "审核ID不能为空")
    private Long reviewId;
    /**
     * 审核状态：2审核通过、3审核不通过
     */
    @NotNull(message = "审核状态不能为空")
    private Integer status;
    /**
     * 审核人备注
     */
    private String reviewerRemark;
}
