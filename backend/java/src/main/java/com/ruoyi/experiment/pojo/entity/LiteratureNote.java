package com.ruoyi.experiment.pojo.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * 文献心得
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class LiteratureNote extends BaseEntity {
    /**
     * 心得id
     */
    private Long id;
    /**
     * 文献id
     */
     private Long literatureId;
    /**
     * 用户id
     */
     private Long userId;
    /**
     * 用户昵称
     */
     private String userNickName;
     /**
      * 心得内容
      */
     private String noteContent;
    /**
     * 点赞数
     */
     private Integer likeCount;
    /**
     * 可见范围
     */
    private Integer visibleType;
    /**
     * 发表时间
     */
     private LocalDateTime publishTime;
}
