package com.ruoyi.experiment.pojo.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotNull;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class SubmitReviewDTO {
    /**
     * 投稿流程ID
     */
    @NotNull(message = "投稿流程ID不能为空")
    private Long processId;
    /**
     * 学生审核人ID
     */
    @NotNull(message = "学生审核人不能为空")
    private Long studentReviewerUserId;
    /**
     * 教师审核人ID
     */
    @NotNull(message = "教师审核人不能为空")
    private Long teacherReviewerUserId;
    /**
     * 被审核人备注
     */
    private String reviewedRemark;
}
