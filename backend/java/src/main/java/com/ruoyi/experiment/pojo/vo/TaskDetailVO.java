package com.ruoyi.experiment.pojo.vo;

import com.ruoyi.experiment.pojo.entity.BaseEntity;
import com.ruoyi.project.system.domain.SysUser;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class TaskDetailVO extends BaseEntity {
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
     * 任务状态
     */
    private Integer taskStatus;
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
    private Long executorUserId;
    /**
     * 执行用户昵称
     */
     private String executorNickName;
     /**
     * 预期完成时间
     */
    private LocalDateTime expectedFinishTime;
     /**
     * 实际完成时间
     */
    private LocalDateTime actualFinishTime;
     /**
     * 参与用户组
     */
    private List<SysUser> participantUsers;
}
