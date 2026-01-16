package com.ruoyi.experiment.pojo.dto;

import lombok.Data;
import java.time.LocalDateTime;

/**
 * 任务查询参数DTO
 * @author ruoyi
 */
@Data
public class TaskQueryDTO {
    /**
     * 任务名称
     */
    private String taskName;

    /**
     * 任务状态
     */
    private Integer taskStatus;

    /**
     * 创建时间开始
     */
    private LocalDateTime createTimeStart;

    /**
     * 创建时间结束
     */
    private LocalDateTime createTimeEnd;
    /**
     * 父任务ID
     */
    private Long parentTaskId;
    /**
     * 当前用户ID，用于查询当前用户参与的任务
     */
    private Long userId;
    /**
     * 排序字段
     */
    private String orderBy;
     /**
      * 排序方向
      */
     private String orderDirection;
}