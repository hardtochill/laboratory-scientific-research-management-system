package com.ruoyi.experiment.service.impl;

import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.file.FileUploadUtils;
import com.ruoyi.experiment.enums.RoleEnums;
import com.ruoyi.experiment.mapper.CommentFileMapper;
import com.ruoyi.experiment.mapper.CommentMapper;
import com.ruoyi.experiment.pojo.entity.Comment;
import com.ruoyi.experiment.pojo.entity.CommentFile;
import com.ruoyi.experiment.pojo.entity.TaskFile;
import com.ruoyi.experiment.pojo.vo.CommentFileVO;
import com.ruoyi.experiment.service.CommentFileService;
import com.ruoyi.experiment.service.CommentService;
import com.ruoyi.experiment.utils.FileUtils;
import com.ruoyi.framework.config.ExperimentConfig;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

@Service
@Slf4j
@RequiredArgsConstructor
public class CommentFileServiceImpl implements CommentFileService {
    private final CommentFileMapper commentFileMapper;
    private final CommentMapper commentMapper;
    private final ExperimentConfig experimentConfig;


    @Override
    public List<CommentFileVO> getCommentFiles(Long commentId) {
        log.info("文献评论模块-查询评论文件：{}",commentId);
        return commentFileMapper.selectByCommentId(commentId);
    }

    @Override
    public void uploadFile(Long commentId, MultipartFile file) {
        log.info("文献评论模块-上传评论文件：{}",commentId);
        // 1.检查权限，仅评论发表用户有权限上传
        Comment comment = commentMapper.selectById(commentId);
        if (!comment.getUserId().equals(SecurityUtils.getUserId())) {
            throw new ServiceException("用户没有权限上传文件到评论");
        }
        // 2.保存文件到本地
        String filePath;
        try{
            filePath = FileUtils.uploadCommentFile(experimentConfig.getCommentBaseDir(), file);
        }catch (Exception e){
            log.error("文件上传失败", e);
            throw new ServiceException("文件上传失败");
        }
        // 3.保存文件信息到数据库
        CommentFile commentFile = new CommentFile();
        commentFile.setCommentId(commentId);
        commentFile.setFileName(com.ruoyi.common.utils.file.FileUtils.getNameNotSuffix(file.getOriginalFilename()));
        commentFile.setFilePath(filePath);
        commentFile.setFileType(FileUploadUtils.getExtension(file));
        commentFile.setFileSize((int)file.getSize());
        commentFileMapper.insert(commentFile);
    }

    @Override
    public void downloadFile(Long fileId, HttpServletResponse response) {
        log.info("文献评论模块-下载评论文件：{}",fileId);
        String filePath = commentFileMapper.selectFilePathById(fileId);
        if(null == filePath){
            throw new ServiceException("文件不存在");
        }
        try{
            FileUtils.downloadFile(experimentConfig.getCommentBaseDir(), filePath, response);
        }catch (Exception e){
            log.error("文件下载失败", e);
            throw new ServiceException("文件下载失败");
        }
    }

    @Override
    public void deleteFile(Long fileId) {
        log.info("文献评论模块-删除评论文件：{}",fileId);
        // 1.文件校验
        CommentFile commentFile = commentFileMapper.selectById(fileId);
        if(null == commentFile){
            throw new ServiceException("文件不存在");
        }

        // 2.权限校验
        Comment comment = commentMapper.selectById(commentFile.getCommentId());
        boolean canDelete = SecurityUtils.hasRole(RoleEnums.TEACHER.getRoleKey()) || comment.getUserId().equals(SecurityUtils.getUserId());
        if(!canDelete){
            throw new ServiceException("用户没有权限删除文件");
        }

        // 2.删除数据库记录
        commentFileMapper.deleteById(fileId);

        // 3.删除物理文件
        Path filePath = Paths.get(FileUtils.getFileAbsolutePath(experimentConfig.getCommentBaseDir(),commentFile.getFilePath()));
        try{
            if (Files.exists(filePath)) {
                Files.delete(filePath);
            }
        }catch (Exception e){
            log.error("文件删除失败", e);
            throw new ServiceException("文件删除失败");
        }
    }
}
