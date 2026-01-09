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
     * 主键ID
     */
    private Long id;
    /**
     * 所属的投稿流程ID
     */
    private Long processId;
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
     * 文件大小，单位是B
     */
    private Integer fileSize;
    /**
     * 上传时间
     */
    private LocalDateTime uploadTime;
}
