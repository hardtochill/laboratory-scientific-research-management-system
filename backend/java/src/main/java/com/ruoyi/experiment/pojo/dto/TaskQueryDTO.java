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
     * 任务可见范围
     */
    private Integer visibleType;

    /**
     * 执行用户名称
     */
    private String executeNickName;

    /**
     * 创建时间开始
     */
    private LocalDateTime createTimeStart;

    /**
     * 创建时间结束
     */
    private LocalDateTime createTimeEnd;
}