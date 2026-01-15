package com.ruoyi.experiment.pojo.vo;

import com.ruoyi.experiment.pojo.entity.BaseEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class SubmissionProcessVO{
    /**
     * 投稿流程ID
     */
    private Long id;
    /**
     * 所属投稿计划ID
     */
    private Long planId;
    /**
     * 流程名称，例如：一审、二审等
     */
     private String name;
     /**
      * 审核状态：1待发起内部审核、2内部审核中、3内部审核通过、4内部审核不通过
      */
     private Integer status;
    /**
     * 流程创建时间
     */
    private LocalDateTime processCreateTime;
    /**
     * 一审/n审-提交给期刊的文件
     */
    private List<SubmissionProcessFileVO> journalSubmissionFiles;
     /**
      * 一审-原始数据与程序
      */
    private List<SubmissionProcessFileVO> rawDataAndProgramFiles;
    /**
     * n审-审稿意见
     */
     private List<SubmissionProcessFileVO> reviewCommentsFiles;
     /**
      * n审-补充数据
      */
     private List<SubmissionProcessFileVO> supplementaryDataFiles;
    /**
     * 校稿-最终稿
     */
     private List<SubmissionProcessFileVO> finalDraftFiles;
}
