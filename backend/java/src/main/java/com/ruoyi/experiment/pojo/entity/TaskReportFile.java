package com.ruoyi.experiment.pojo.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * 任务汇报文件
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class TaskReportFile extends BaseEntity {
    /**
     * 文件ID
     */
    private Long id;
    /**
     * 任务汇报ID
     */
    private Long taskReportId;
    /**
     * 文件名
     */
    private String fileName;
    /**
     * 文件路径
     */
    private String filePath;
    /**
     * 文件类型
     */
    private String fileType;
    /**
     * 文件大小
     */
    private Integer fileSize;
    /**
     * 用户ID
     */
    private Long userId;
    /**
     * 用户昵称
     */
    private String userNickName;
    /**
     * 上传时间
     */
    private LocalDateTime uploadTime;
}
