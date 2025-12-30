package com.ruoyi.experiment.service.impl;

import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.experiment.constant.CommentConstants;
import com.ruoyi.experiment.enums.RoleEnums;
import com.ruoyi.experiment.mapper.CommentFileMapper;
import com.ruoyi.experiment.mapper.CommentLikeMapper;
import com.ruoyi.experiment.mapper.CommentMapper;
import com.ruoyi.experiment.pojo.dto.CommentQueryDTO;
import com.ruoyi.experiment.pojo.entity.CommentLike;
import com.ruoyi.experiment.pojo.vo.CommentVO;
import com.ruoyi.experiment.service.CommentService;
import com.ruoyi.experiment.utils.FileUtils;
import com.ruoyi.framework.config.ExperimentConfig;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

@Service
@Slf4j
@RequiredArgsConstructor
public class CommentServiceImpl implements CommentService {
    private final CommentMapper commentMapper;
    private final CommentLikeMapper commentLikeMapper;
    private final CommentFileMapper commentFileMapper;
    private final ExperimentConfig experimentConfig;

    @Override
    public List<CommentVO> listParentComments(CommentQueryDTO commentQueryDTO) {
        Long userId = SecurityUtils.getUserId();
        commentQueryDTO.setUserId(userId);
        commentQueryDTO.setParentId(CommentConstants.FIRST_PARENT_COMMENT_ID);
        // 1.排序字段转化
        if("commentTime".equals(commentQueryDTO.getSortField())){
            commentQueryDTO.setSortField("comment_time");
        }else if("likeCount".equals(commentQueryDTO.getSortField())){
            commentQueryDTO.setSortField("like_count");
        }else if(null!=commentQueryDTO.getSortField()){
            throw new ServiceException("排序字段错误");
        }
        // 2.查询评论列表
        List<CommentVO> commentVOList;
        boolean isTeacher = SecurityUtils.hasRole(RoleEnums.TEACHER.getRoleKey());
        if(isTeacher){
            commentVOList = commentMapper.selectParentCommentListForTeacher(commentQueryDTO);
        }else{
            commentVOList = commentMapper.selectParentCommentListForStudent(commentQueryDTO);
        }
        // 3.查询评论关联文件列表
        // 4.查询评论是否有子评论
        // 5.标记是否点赞
        List<Long> likedCommentIds = commentLikeMapper.selectCommentIdsByUserId(userId);
        for (CommentVO commentVO : commentVOList) {
            commentVO.setCommentFiles(commentFileMapper.selectByCommentId(commentVO.getId()));
            commentVO.setHasChildComments(commentMapper.hasChildComments(commentVO.getId())!=null);
            commentVO.setIsLiked(likedCommentIds.contains(commentVO.getId()));
        }
        return commentVOList;
    }

    @Override
    public List<CommentVO> listChildComments(Long parentId) {
        Long userId = SecurityUtils.getUserId();
        // 1.构造查询参数
        CommentQueryDTO commentQueryDTO = new CommentQueryDTO();
        commentQueryDTO.setUserId(userId);
        commentQueryDTO.setParentId(parentId);
        commentQueryDTO.setSortField(CommentConstants.DEFAULT_SORT_FIELD);
        commentQueryDTO.setSortOrder(CommentConstants.DEFAULT_SORT_ORDER);
        // 2.查询评论列表
        List<CommentVO> commentVOList;
        boolean isTeacher = SecurityUtils.hasRole(RoleEnums.TEACHER.getRoleKey());
        if(isTeacher){
            commentVOList = commentMapper.selectChildCommentListForTeacher(commentQueryDTO);
        }else{
            commentVOList = commentMapper.selectChildCommentListForStudent(commentQueryDTO);
        }
        // 3.查询评论关联文件列表
        // 4.子评论不再关联子评论
        // 5.标记是否点赞
        List<Long> likedCommentIds = commentLikeMapper.selectCommentIdsByUserId(userId);
        for (CommentVO commentVO : commentVOList) {
            commentVO.setCommentFiles(commentFileMapper.selectByCommentId(commentVO.getId()));
            commentVO.setHasChildComments(false);
            commentVO.setIsLiked(likedCommentIds.contains(commentVO.getId()));
        }
        return commentVOList;
    }

    @Override
    @Transactional
    public boolean toggleCommentLike(Long commentId) {
        // 获取当前用户ID
        Long userId = SecurityUtils.getUserId();

        // 查询用户是否已经点赞
        CommentLike commentLike = commentLikeMapper.selectByCommentIdAndUserId(commentId, userId);
        boolean isLiked = commentLike!= null;
        if(isLiked){
            // 已点赞，取消点赞
            commentLikeMapper.deleteById(commentLike.getId());
            commentMapper.updateLikeCount(commentId, -1);
            return false;
        }else{
            // 未点赞，添加点赞
            CommentLike newCommentLike = new CommentLike();
            newCommentLike.setCommentId(commentId);
            newCommentLike.setUserId(userId);
            commentLikeMapper.insert(newCommentLike);
            commentMapper.updateLikeCount(commentId, 1);
            return true;
        }
    }

    @Override
    @Transactional
    public void deleteComment(Long commentId) {
        // 1.删除子评论
        List<Long> childIds = commentMapper.selectChildIds(commentId);
        if(CollectionUtils.isEmpty(childIds)){
            for (Long childId : childIds) {
                deleteComment(childId);
            }
        }
        // 2.删除评论点赞记录
        commentLikeMapper.deleteByCommentId(commentId);
        // 3.删除评论记录
        commentMapper.deleteById(commentId);
        // 4.删除评论关联文件
        List<String> filePaths = commentFileMapper.selectFilePathsByCommentId(commentId);
        if(CollectionUtils.isEmpty(filePaths)){
            return;
        }
        try{
            for (String filePath : filePaths) {
                Path path = Paths.get(FileUtils.getFileAbsolutePath(experimentConfig.getCommentBaseDir(),filePath));
                if (Files.exists(path)) {
                    Files.delete(path);
                }
            }
        }catch (Exception e){
            log.error("删除任务关联文件失败", e);
            throw new ServiceException("删除任务关联文件失败");
        }
        commentFileMapper.deleteByCommentId(commentId);
    }
}
