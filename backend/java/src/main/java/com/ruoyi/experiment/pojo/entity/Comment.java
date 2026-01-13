package com.ruoyi.experiment.pojo.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * 文献评论
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Comment extends BaseEntity{
    /**
     * id
     */
     private Long id;
    /**
     * 父评论id
     */
     private Long parentId;
    /**
     * 关联文献id
     */
     private Long literatureId;
    /**
     * 发表用户id
     */
     private Long userId;
    /**
     * 发表用户昵称
     */
    private String userNickName;
    /**
     * 接收用户id
     */
    private Long receiveUserId;
    /**
     * 接收用户昵称
     */
    private String receiveUserNickName;
    /**
     * 评论内容
     */
     private String commentContent;
    /**
     * 发表时间
     */
     private LocalDateTime commentTime;
    /**
     * 点赞数
     */
     private Integer likeCount;
    /**
     * 可见类型，1仅自己可见，2对所有用户可见
     */
    private Integer visibleType;
}
