package com.ruoyi.experiment.pojo.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 文献心得点赞
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class LiteratureNoteLike extends BaseEntity{
    private Long id;
    private Long userId;
    private Long noteId;
}
