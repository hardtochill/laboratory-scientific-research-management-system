package com.ruoyi.experiment.pojo.vo;

import com.ruoyi.project.system.domain.SysUser;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

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
    /**
     * 参与用户组
     */
    private List<SysUser> participantUsers;
    /**
     * 任务创建人
     */
    private Long createUserId;
    /**
     * 任务执行人
     */
    private Long executeUserId;
}
