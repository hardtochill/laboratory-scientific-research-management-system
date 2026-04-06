package com.ruoyi.experiment.service.impl;

import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.file.FileUploadUtils;
import com.ruoyi.experiment.mapper.TaskReportFileMapper;
import com.ruoyi.experiment.mapper.TaskReportMapper;
import com.ruoyi.experiment.pojo.entity.TaskReport;
import com.ruoyi.experiment.pojo.entity.TaskReportFile;
import com.ruoyi.experiment.pojo.vo.TaskReportFileVO;
import com.ruoyi.experiment.service.TaskReportFileService;
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
import java.util.ArrayList;
import java.util.List;

@Service
@Slf4j
@RequiredArgsConstructor
public class TaskReportFileServiceImpl implements TaskReportFileService {
    private final TaskReportFileMapper taskReportFileMapper;
    private final TaskReportMapper taskReportMapper;
    private final ExperimentConfig experimentConfig;

    @Override
    public List<TaskReportFileVO> getTaskReportFiles(Long taskReportId) {
        log.info("任务汇报模块-查询汇报文件：{}", taskReportId);
        return taskReportFileMapper.selectVOByTaskReportId(taskReportId);
    }

    @Override
    public void uploadFile(Long taskReportId, MultipartFile file) {
        log.info("任务汇报模块-上传汇报文件：{}", taskReportId);
        // 1.检查权限，仅汇报发表用户有权限上传
        TaskReport taskReport = taskReportMapper.selectById(taskReportId);
        if (!taskReport.getUserId().equals(SecurityUtils.getUserId())) {
            throw new ServiceException("用户没有权限上传文件到该汇报");
        }
        // 2.保存文件到本地
        String filePath;
        try {
            filePath = FileUtils.uploadTaskReportFile(experimentConfig.getTaskReportBaseDir(), file);
        } catch (Exception e) {
            log.error("文件上传失败", e);
            throw new ServiceException("文件上传失败");
        }
        // 3.保存文件信息到数据库
        TaskReportFile taskReportFile = new TaskReportFile();
        taskReportFile.setTaskReportId(taskReportId);
        taskReportFile.setFileName(com.ruoyi.common.utils.file.FileUtils.getNameNotSuffix(file.getOriginalFilename()));
        taskReportFile.setFilePath(filePath);
        taskReportFile.setFileType(FileUploadUtils.getExtension(file));
        taskReportFile.setFileSize((int) file.getSize());
        taskReportFile.setUserId(SecurityUtils.getUserId());
        taskReportFile.setUserNickName(SecurityUtils.getLoginUser().getUser().getNickName());
        taskReportFile.setUploadTime(LocalDateTime.now());
        taskReportFileMapper.insert(taskReportFile);
    }

    @Override
    public void downloadFile(Long fileId, HttpServletResponse response) {
        log.info("任务汇报模块-下载汇报文件：{}", fileId);
        String filePath = taskReportFileMapper.selectFilePathById(fileId);
        if (null == filePath) {
            throw new ServiceException("文件不存在");
        }
        try {
            FileUtils.downloadFile(experimentConfig.getTaskReportBaseDir(), filePath, response);
        } catch (Exception e) {
            log.error("文件下载失败", e);
            throw new ServiceException("文件下载失败");
        }
    }

    @Override
    public void deleteFile(Long fileId) {
        log.info("任务汇报模块-删除汇报文件：{}", fileId);
        // 1.文件校验
        TaskReportFile taskReportFile = taskReportFileMapper.selectById(fileId);
        if (null == taskReportFile) {
            throw new ServiceException("文件不存在");
        }

        // 2.权限校验
        TaskReport taskReport = taskReportMapper.selectById(taskReportFile.getTaskReportId());
        boolean canDelete = SecurityUtils.isTeacher() || taskReport.getUserId().equals(SecurityUtils.getUserId());
        if (!canDelete) {
            throw new ServiceException("用户没有权限删除文件");
        }

        // 2.删除数据库记录
        taskReportFileMapper.deleteById(fileId);

        // 3.删除物理文件
        Path filePath = Paths.get(FileUtils.getFileAbsolutePath(experimentConfig.getTaskReportBaseDir(), taskReportFile.getFilePath()));
        try {
            if (Files.exists(filePath)) {
                Files.delete(filePath);
            }
        } catch (Exception e) {
            log.error("文件删除失败", e);
            throw new ServiceException("文件删除失败");
        }
    }

    @Override
    public void uploadFiles(Long taskReportId, List<MultipartFile> files) {
        if (files == null || files.isEmpty()) {
            return;
        }

        log.info("任务汇报模块-批量上传汇报文件：{}，文件数量：{}", taskReportId, files.size());

        // 1.检查权限，仅汇报发表用户有权限上传
        TaskReport taskReport = taskReportMapper.selectById(taskReportId);
        if (!taskReport.getUserId().equals(SecurityUtils.getUserId())) {
            throw new ServiceException("用户没有权限上传文件到该汇报");
        }

        List<TaskReportFile> taskReportFileList = new ArrayList<>();
        List<String> filePaths = new ArrayList<>();

        try {
            for (MultipartFile file : files) {
                // 保存文件到本地
                String filePath = FileUtils.uploadTaskReportFile(experimentConfig.getTaskReportBaseDir(), file);
                filePaths.add(filePath);

                // 构建文件实体
                TaskReportFile taskReportFile = new TaskReportFile();
                taskReportFile.setTaskReportId(taskReportId);
                taskReportFile.setFileName(com.ruoyi.common.utils.file.FileUtils.getNameNotSuffix(file.getOriginalFilename()));
                taskReportFile.setFilePath(filePath);
                taskReportFile.setFileType(FileUploadUtils.getExtension(file));
                taskReportFile.setFileSize((int) file.getSize());
                taskReportFile.setUserId(SecurityUtils.getUserId());
                taskReportFile.setUserNickName(SecurityUtils.getLoginUser().getUser().getNickName());
                taskReportFile.setUploadTime(LocalDateTime.now());
                taskReportFileList.add(taskReportFile);
            }

            // 批量保存到数据库
            if (!taskReportFileList.isEmpty()) {
                taskReportFileMapper.insertBatch(taskReportFileList);
            }
        } catch (Exception e) {
            log.error("批量文件上传失败，回滚已上传的文件", e);
            // 回滚：删除已上传的文件
            for (String filePath : filePaths) {
                try {
                    Path path = Paths.get(FileUtils.getFileAbsolutePath(experimentConfig.getTaskReportBaseDir(), filePath));
                    if (Files.exists(path)) {
                        Files.delete(path);
                    }
                } catch (Exception ex) {
                    log.error("回滚文件删除失败", ex);
                }
            }
            throw new ServiceException("文件上传失败");
        }
    }
}
