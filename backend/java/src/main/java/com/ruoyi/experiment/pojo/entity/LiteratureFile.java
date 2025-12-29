package com.ruoyi.experiment.pojo.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotNull;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class LiteratureFile extends BaseEntity {
    /**
     * 文献文件ID
     */
     private Long id;
     /**
      * 文献ID
      */
     private Long literatureId;
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
    /**
     * 上传用户id
     */
     private Long uploadUserId;
    /**
     * 上传时间
     */
     private LocalDateTime uploadTime;
}
