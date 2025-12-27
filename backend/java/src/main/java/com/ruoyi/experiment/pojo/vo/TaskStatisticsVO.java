package com.ruoyi.experiment.pojo.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class TaskStatisticsVO {
    /**
     * 分页查询结果
     */
    private List<TaskVO> list;
    
    /**
     * 未开始任务个数
     */
    private Long pendingCount;
    
    /**
     * 进行中任务个数
     */
    private Long processingCount;
    
    /**
     * 已完成任务个数
     */
    private Long finishedCount;
    
    /**
     * 已跳过任务个数
     */
    private Long skippedCount;
    
    /**
     * 总记录数
     */
    private Long total;
}