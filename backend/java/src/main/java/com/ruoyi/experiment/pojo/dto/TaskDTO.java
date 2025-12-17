package com.ruoyi.experiment.pojo.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.Min;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class TaskDTO {
    /**
     * 任务id
     */
    private Long taskId;
    /**
     * 父任务id
     */
    @NotNull
    @Min(value = 0L)
    private Long parentTaskId;
    /**
     * 任务名称
     */
    @NotBlank
    private String taskName;
    /**
     * 任务描述
     */
    private String taskDescription;
    /**
     * 任务备注
     */
    private String taskRemark;
    /**
     * 任务状态
     */
    @NotNull
    private Integer taskStatus;
    /**
     * 任务可见范围
     */
    @NotNull
    private Integer visibleType;
    /**
     * 执行用户id
     */
    @NotNull
    private Long executeUserId;
    /**
     * 执行用户昵称
     */
    @NotBlank
    private String executeNickName;
    /**
     * 预期完成时间
     */
    private LocalDateTime expectedFinishTime;
    /**
     * 实际完成时间
     */
    private LocalDateTime actualFinishTime;
}
