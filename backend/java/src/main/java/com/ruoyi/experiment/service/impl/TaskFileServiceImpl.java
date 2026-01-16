package com.ruoyi.experiment.service.impl;

import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.file.FileUploadUtils;
import com.ruoyi.experiment.enums.RoleEnums;
import com.ruoyi.experiment.mapper.TaskFileMapper;
import com.ruoyi.experiment.mapper.TaskUserMapper;
import com.ruoyi.experiment.pojo.entity.Task;
import com.ruoyi.experiment.pojo.entity.TaskFile;
import com.ruoyi.experiment.service.TaskFileService;
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
import java.time.LocalDateTime;
import java.util.List;

@Service
@Slf4j
@RequiredArgsConstructor
public class TaskFileServiceImpl implements TaskFileService {
    private final TaskFileMapper taskFileMapper;
    private final TaskUserMapper taskUserMapper;
    private final ExperimentConfig experimentConfig;

    @Override
    public List<TaskFile> getTaskFiles(Long taskId) {
        log.info("任务文件模块-查询任务文件列表：{}",taskId);
        return taskFileMapper.selectByTaskId(taskId);
    }

    @Override
    public void uploadFile(Long taskId, MultipartFile file) {
        log.info("任务文件模块-上传文件：{},{}",taskId,file.getOriginalFilename());
        // 1.检查权限
        if (!canUploadFile(taskId)) {
            throw new ServiceException("用户没有权限上传文件到任务");
        }

        // 2.检查并上传文件
        String filePath;
        try{
            filePath = FileUtils.uploadTaskFile(experimentConfig.getTaskBaseDir(), file);
        }catch (Exception e){
            log.error("任务文件模块-上传文件失败", e);
            throw new ServiceException("文件上传失败");
        }
        // 保存文件信息到数据库
        TaskFile taskFile = new TaskFile();
        taskFile.setFileName(com.ruoyi.common.utils.file.FileUtils.getNameNotSuffix(file.getOriginalFilename()));
        taskFile.setFilePath(filePath);
        taskFile.setFileType(FileUploadUtils.getExtension(file));
        taskFile.setFileSize((int) file.getSize());
        taskFile.setTaskId(taskId);
        taskFile.setUserId(SecurityUtils.getUserId());
        taskFile.setUserNickName(SecurityUtils.getLoginUser().getUser().getNickName());
        taskFile.setUploadTime(LocalDateTime.now());

        taskFileMapper.insert(taskFile);
    }

    @Override
    public void downloadFile(Long fileId, HttpServletResponse response) {
        log.info("任务文件模块-下载文件：{}",fileId);
        String filePath = taskFileMapper.selectFilePathById(fileId);
        if(null == filePath){
            throw new ServiceException("文件不存在");
        }
        try{
            FileUtils.downloadFile(experimentConfig.getTaskBaseDir(), filePath, response);
        }catch (Exception e){
            log.error("任务文件模块-下载文件失败", e);
            throw new ServiceException("文件下载失败");
        }
    }

    @Override
    public void deleteFile(Long fileId) {
        log.info("任务文件模块-删除文件：{}",fileId);
        // 1.文件校验
        TaskFile taskFile = taskFileMapper.selectById(fileId);
        if(null == taskFile){
            throw new ServiceException("文件不存在");
        }

        // 2.权限校验
        boolean canDelete = SecurityUtils.hasRole(RoleEnums.TEACHER.getRoleKey()) || taskFile.getUserId().equals(SecurityUtils.getUserId());
        if(!canDelete){
            throw new ServiceException("用户没有权限删除文件");
        }

        // 2.删除数据库记录
        taskFileMapper.deleteById(fileId);

        // 3.删除物理文件
        Path filePath = Paths.get(FileUtils.getFileAbsolutePath(experimentConfig.getTaskBaseDir(),taskFile.getFilePath()));
        try{
            if (Files.exists(filePath)) {
                Files.delete(filePath);
            }
        }catch (Exception e){
            log.error("任务文件模块-删除文件失败", e);
            throw new ServiceException("文件删除失败");
        }
    }

    /**
     * 检查用户是否有权限上传文件到任务
     */
    private boolean canUploadFile(Long taskId) {
        // 检查是否为teacher身份
        if (SecurityUtils.hasRole(RoleEnums.TEACHER.getRoleKey())) {
            return true;
        }
        // 检查是否为任务参与组中的用户
        List<Long> userIds = taskUserMapper.selectUserIdsByTaskId(taskId);
        return userIds.contains(SecurityUtils.getUserId());
    }
}
