package com.ruoyi.experiment.pojo.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * 文献评论文件
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class CommentFile extends BaseEntity {
    /**
     * 文件ID
     */
     private Long id;
     /**
      * 评论ID
      */
     private Long commentId;
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
     private Long fileSize;
}
