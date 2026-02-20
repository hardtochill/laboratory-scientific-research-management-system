package com.ruoyi.experiment.pojo.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import net.sf.cglib.core.Local;

import java.time.LocalDateTime;

/**
 * 任务汇报
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class TaskReport extends BaseEntity{
    /**
     * 主键id
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
    /**
     * 用户昵称
     */
    private String userNickname;
    /**
     * 汇报内容
     */
    private String reportContent;
    /**
     * 汇报时间
     */
    private LocalDateTime reportTime;
}
