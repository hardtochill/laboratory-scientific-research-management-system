package com.ruoyi.experiment.pojo.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

/**
 * 新增文献评论DTO
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class CommentDTO {
    /**
     * 父评论ID
     */
    private Long parentId;
    /**
     * 文献ID
     */
    private Long literatureId;
    /**
     * 用于回复评论，表示被回复评论的userId
     */
    private Long receiveUserId;
    /**
     * 用于回复评论，表示被回复评论的用户昵称
     */
    private String receiveUserNickName;
    /**
     * 评论内容
     */
    private String commentContent;
    /**
     * 可见类型，1仅自己可见，2所有人可见
     */
    private Integer visibleType;
    /**
     * 关联文件列表
     */
    private List<MultipartFile> fileList;
}
