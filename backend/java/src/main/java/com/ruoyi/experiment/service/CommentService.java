package com.ruoyi.experiment.service;

import com.ruoyi.experiment.pojo.dto.CommentDTO;
import com.ruoyi.experiment.pojo.dto.CommentQueryDTO;
import com.ruoyi.experiment.pojo.vo.CommentVO;

import java.util.List;

/**
 * 文献评论接口
 */
public interface CommentService {
    /**
     * 查询父评论列表
     * @param commentQueryDTO
     * @return
     */
    List<CommentVO> listParentComments(CommentQueryDTO commentQueryDTO);
    /**
     * 查询子评论列表
     * @param parentId
     * @return
     */
    List<CommentVO> listChildComments(Long parentId);
    /**
     * 切换评论点赞状态
     * @param commentId
     * @return
     */
    boolean toggleCommentLike(Long commentId);
    /**
     * 删除评论
     * @param commentId
     */
    void deleteComment(Long commentId);

    /**
     * 新增文献评论
     * @param commentDTO
     */
    void addComment(CommentDTO commentDTO);
}
