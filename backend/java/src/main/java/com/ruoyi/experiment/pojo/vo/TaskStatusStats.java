package com.ruoyi.experiment.pojo.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class TaskStatusStats {
    /**
     * 未开始任务个数
     */
    private Integer pendingCount;
    
    /**
     * 进行中任务个数
     */
    private Integer processingCount;
    
    /**
     * 已完成任务个数
     */
    private Integer finishedCount;
    
    /**
     * 已跳过任务个数
     */
    private Integer skippedCount;
}