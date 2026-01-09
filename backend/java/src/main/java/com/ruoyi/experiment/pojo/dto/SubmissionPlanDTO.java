package com.ruoyi.experiment.pojo.dto;

import com.ruoyi.experiment.pojo.entity.BaseEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotBlank;
import java.time.LocalDateTime;

/**
 * 投稿计划DTO
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class SubmissionPlanDTO{
    /**
     * 投稿计划ID
     */
    private Long id;
     /**
     * 投稿计划名称
     */
     @NotBlank
    private String name;
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
     * 投稿创建时间
     */
    private LocalDateTime submissionCreateTime;
}
