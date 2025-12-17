package com.ruoyi.experiment.pojo.entity;

import com.ruoyi.framework.web.domain.BaseEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Task extends BaseEntity {
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
     * 任务描述
     */
    private String taskDescription;
    /**
     * 任务备注
     */
    private String taskRemark;
    /**
     * 任务排序
     */
    private Integer taskOrder;
     /**
     * 任务深度
     */
    private Integer taskDepth;
     /**
     * 任务状态
     */
    private Integer taskStatus;
     /**
     * 任务可见范围
     */
    private Integer visibleType;
     /**
     * 创建用户id
     */
    private Long createUserId;
     /**
     * 创建用户昵称
     */
    private String createNickName;
     /**
     * 执行用户id
     */
    private Long executeUserId;
     /**
     * 执行用户昵称
     */
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
