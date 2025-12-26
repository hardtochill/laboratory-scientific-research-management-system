package com.ruoyi.experiment.pojo.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class TaskUser extends BaseEntity{
    /**
     * id
     */
    private Long id;
    /**
     * 任务id
     */
    private Long taskId;
     /**
     * 用户id
     */
    private Long userId;
}
