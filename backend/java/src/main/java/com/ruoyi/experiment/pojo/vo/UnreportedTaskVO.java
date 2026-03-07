package com.ruoyi.experiment.pojo.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * 待汇报任务VO
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class UnreportedTaskVO {
    /**
     * 任务id
     */
    private Long taskId;
    
    /**
     * 父任务id
     */
    private Long parentTaskId;
    
    /**
     * 任务名称
     */
    private String taskName;
    
    /**
     * 任务状态
     */
    private Integer taskStatus;
    
    /**
     * 任务深度
     */
    private Integer taskDepth;
    
    /**
     * 任务进度百分比
     */
    private Integer percentage;

    /**
     * 子任务数量（用于计算进度）
     */
    private Long subTaskCount;

    /**
     * 已完成子任务数量（用于计算进度）
     */
    private Long completedSubTaskCount;

    /**
     * 定时汇报频率（天）
     */
    private Integer reportFrequency;
    
    /**
     * 最后汇报时间
     */
    private LocalDateTime lastReportTime;
    
    /**
     * 任务创建人ID
     */
    private Long createUserId;
    
    /**
     * 任务执行人ID
     */
    private Long executorUserId;
    
    /**
     * 创建时间
     */
    private LocalDateTime createTime;
    
    /**
     * 创建人姓名
     */
    private String createUserName;
    
    /**
     * 创建人昵称
     */
    private String createUserNickName;
    
    /**
     * 执行人姓名
     */
    private String executorUserName;
    
    /**
     * 执行人昵称
     */
    private String executorNickName;
}
