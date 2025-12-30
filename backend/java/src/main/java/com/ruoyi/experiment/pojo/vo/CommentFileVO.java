package com.ruoyi.experiment.pojo.vo;

import com.ruoyi.experiment.pojo.entity.BaseEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 文献评论文件VO
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class CommentFileVO extends BaseEntity {
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
}
