package com.ruoyi.experiment.pojo.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class TaskVO {
    private Long taskId;
    private String taskName;
    private Integer taskStatus;
    /**
     * 是否有子任务
     */
    private Boolean hasSubTasks;
    /**
     * 任务进度
     */
    private Integer percentage;
}
