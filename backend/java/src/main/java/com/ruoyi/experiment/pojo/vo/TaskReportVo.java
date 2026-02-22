package com.ruoyi.experiment.pojo.vo;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 任务汇报VO
 *
 * @author ruoyi
 */
@Data
public class TaskReportVo implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 主键
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
    private String userNickName;

    /**
     * 汇报内容
     */
    private String reportContent;

    /**
     * 汇报时间
     */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime reportTime;

    /**
     * 创建时间
     */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createTime;

    /**
     * 更新时间
     */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime updateTime;
}
