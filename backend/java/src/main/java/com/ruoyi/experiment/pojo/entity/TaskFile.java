package com.ruoyi.experiment.pojo.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * 任务文件表
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class TaskFile extends BaseEntity{
    /**
     * id
     */
    public Long id;
    /**
     * 文件名
     */
    public String fileName;
    /**
     * 文件路径
     */
    public String filePath;
    /**
     * 文件类型
     */
    public String fileType;
    /**
     * 文件大小，单位是B
     */
    public Integer fileSize;
    /**
     * 任务id
     */
    public Long taskId;
    /**
     * 用户id
     */
    public Long userId;
    /**
     * 用户昵称
     */
    public String userNickName;
    /**
     * 上传时间
     */
    public LocalDateTime uploadTime;
}
