package com.ruoyi.experiment.pojo.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * 文献心得VO
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class LiteratureNoteVO {
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
    /**
     * 当前用户是否点赞（true：已点赞，false：未点赞）
     */
    private Boolean likeFlag;
}