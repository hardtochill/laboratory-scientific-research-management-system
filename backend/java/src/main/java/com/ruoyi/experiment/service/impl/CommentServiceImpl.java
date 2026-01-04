package com.ruoyi.experiment.service.impl;

import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.file.FileUploadUtils;
import com.ruoyi.experiment.constant.CommentConstants;
import com.ruoyi.experiment.enums.CommentVisibleTypeEnum;
import com.ruoyi.experiment.enums.RoleEnums;
import com.ruoyi.experiment.mapper.CommentFileMapper;
import com.ruoyi.experiment.mapper.CommentLikeMapper;
import com.ruoyi.experiment.mapper.CommentMapper;
import com.ruoyi.experiment.mapper.LiteratureMapper;
import com.ruoyi.experiment.pojo.dto.CommentDTO;
import com.ruoyi.experiment.pojo.dto.CommentQueryDTO;
import com.ruoyi.experiment.pojo.entity.Comment;
import com.ruoyi.experiment.pojo.entity.CommentFile;
import com.ruoyi.experiment.pojo.entity.CommentLike;
import com.ruoyi.experiment.pojo.vo.CommentVO;
import com.ruoyi.experiment.service.CommentService;
import com.ruoyi.experiment.utils.FileUtils;
import com.ruoyi.framework.config.ExperimentConfig;
import com.ruoyi.project.system.domain.SysUser;
import com.ruoyi.project.system.mapper.SysUserMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;
import org.springframework.web.multipart.MultipartFile;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Service
@Slf4j
@RequiredArgsConstructor
public class CommentServiceImpl implements CommentService {
    private final CommentMapper commentMapper;
    private final CommentLikeMapper commentLikeMapper;
    private final CommentFileMapper commentFileMapper;
    private final LiteratureMapper literatureMapper;
    private final SysUserMapper sysUserMapper;
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
        // 4.标记是否点赞
        List<Long> likedCommentIds = commentLikeMapper.selectCommentIdsByUserId(userId);
        for (CommentVO commentVO : commentVOList) {
            commentVO.setCommentFiles(commentFileMapper.selectByCommentId(commentVO.getId()));
            // 检查该评论是否有子评论
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
    public void addComment(CommentDTO commentDTO){
        // 1.校验parentId合法性
        Long parentId = commentDTO.getParentId();
        Comment parentComment = commentMapper.selectById(parentId);
        if( null==parentId
                || parentId<CommentConstants.FIRST_PARENT_COMMENT_ID
                || (!parentId.equals(CommentConstants.FIRST_PARENT_COMMENT_ID) && null==parentComment)){
            throw new ServiceException("父评论ID异常");
        }
        // 2.校验文献是否存在
        Long literatureId = commentDTO.getLiteratureId();
        if(null==literatureId || null==literatureMapper.selectLiteratureById(literatureId)){
            throw new ServiceException("文献不存在");
        }
        // 3.对于发表评论，其receiveUser相关信息为null
        if(parentId.equals(CommentConstants.FIRST_PARENT_COMMENT_ID)){
            commentDTO.setReceiveUserId(null);
            commentDTO.setReceiveUserNickName(null);
        }
        // 4.设置评论用户信息、评论时间、点赞数
        Comment comment = new Comment();
        comment.setParentId(commentDTO.getParentId());
        comment.setLiteratureId(commentDTO.getLiteratureId());
        comment.setUserId(SecurityUtils.getUserId());
        comment.setUserNickName(SecurityUtils.getLoginUser().getUser().getNickName());
        comment.setReceiveUserId(commentDTO.getReceiveUserId());
        comment.setReceiveUserNickName(commentDTO.getReceiveUserNickName());
        comment.setCommentContent(commentDTO.getCommentContent());
        comment.setCommentTime(LocalDateTime.now());
        comment.setLikeCount(0);
        // 5.子评论统一可见范围
        if(parentId.equals(CommentConstants.FIRST_PARENT_COMMENT_ID)){
            comment.setVisibleType(commentDTO.getVisibleType());
        }else{
            comment.setVisibleType(CommentVisibleTypeEnum.ALL_USER.getType());
        }
        // 6.插入评论记录
        commentMapper.insert(comment);
        List<MultipartFile> fileList = commentDTO.getFileList();
        List<CommentFile> commentFileList = new ArrayList<>();
        // 7.插入评论文件记录
        if(!CollectionUtils.isEmpty(fileList)){
            try{
                for (MultipartFile file : fileList) {
                    String filePath;
                    filePath = FileUtils.uploadCommentFile(experimentConfig.getCommentBaseDir(), file);
                    // 3.保存文件信息到数据库
                    CommentFile commentFile = new CommentFile();
                    commentFile.setCommentId(comment.getId());
                    commentFile.setFileName(com.ruoyi.common.utils.file.FileUtils.getNameNotSuffix(file.getOriginalFilename()));
                    commentFile.setFilePath(filePath);
                    commentFile.setFileType(FileUploadUtils.getExtension(file));
                    commentFile.setFileSize((int)file.getSize());

                    commentFileList.add(commentFile);
                }
            }catch (Exception e){
                log.error("评论文件上传失败", e);
                throw new ServiceException("评论文件上传失败");
            }
            // 8.保存评论文件
            commentFileMapper.insertBatch(commentFileList);
        }
    }

    @Override
    @Transactional
    public void deleteComment(Long commentId) {
        // 1.删除子评论
        List<Long> childIds = commentMapper.selectChildIds(commentId);
        if(!CollectionUtils.isEmpty(childIds)){
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
