package com.ruoyi.experiment.pojo.vo;

import com.ruoyi.experiment.pojo.entity.BaseEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 投稿流程文件VO
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class SubmissionProcessFileVO{
    /**
     * 文件ID
     */
     private Long id;
     /**
      * 文件名
      */
     private String fileName;
    /**
     * 文件类型
     */
     private String fileType;
    /**
     * 文件大小
     */
     private Integer fileSize;
    /**
     * 文件标签
     */
     private Integer tag;
}
