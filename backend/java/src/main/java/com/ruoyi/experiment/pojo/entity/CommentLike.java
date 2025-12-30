package com.ruoyi.experiment.pojo.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 文献评论点赞
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class CommentLike extends BaseEntity{
    private Long id;
    private Long commentId;
    private Long userId;
}
