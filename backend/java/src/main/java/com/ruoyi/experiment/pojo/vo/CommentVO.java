package com.ruoyi.experiment.pojo.vo;

import com.ruoyi.project.system.domain.SysUser;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CommentVO {
    private Long id;
    private Long parentId;
    private Long userId;
    private String userNickName;
    private Long receiveUserId;
    private String receiveUserNickName;
    private String commentContent;
    private LocalDateTime commentTime;
    private Integer likeCount;
    /**
     * 可见类型，1仅自己可见，2对所有用户可见
     */
    private Integer visibleType;
    /**
     * 文件列表
     */
    private List<CommentFileVO> commentFiles;
    /**
     * 是否有子评论
     */
    private Boolean hasChildComments;
    /**
     * 是否点赞
     */
    private Boolean isLiked;
}
