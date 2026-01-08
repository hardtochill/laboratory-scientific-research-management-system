package com.ruoyi.experiment.pojo.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * 投稿流程关联文件
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class SubmissionProcessFile extends BaseEntity{
    /**
     * id
     */
    public Long id;
    /**
     * 关联流程id
     */
    private Long processId;
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
     * 上传时间
     */
    public LocalDateTime uploadTime;
}
