package com.ruoyi.experiment.service.impl;

import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.file.FileUploadUtils;
import com.ruoyi.experiment.enums.RoleEnums;
import com.ruoyi.experiment.mapper.SubmissionPlanMapper;
import com.ruoyi.experiment.mapper.SubmissionProcessFileMapper;
import com.ruoyi.experiment.mapper.SubmissionProcessMapper;
import com.ruoyi.experiment.pojo.entity.SubmissionPlan;
import com.ruoyi.experiment.pojo.entity.SubmissionProcess;
import com.ruoyi.experiment.pojo.entity.SubmissionProcessFile;
import com.ruoyi.experiment.pojo.vo.SubmissionPlanDetailVO;
import com.ruoyi.experiment.pojo.vo.SubmissionProcessFileVO;
import com.ruoyi.experiment.service.SubmissionProcessFileService;
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
public class SubmissionProcessFileServiceImpl implements SubmissionProcessFileService {
    private final SubmissionPlanMapper submissionPlanMapper;
    private final SubmissionProcessFileMapper submissionProcessFileMapper;
    private final SubmissionProcessMapper submissionProcessMapper;
    private final ExperimentConfig experimentConfig;
    @Override
    public void uploadFile(Long processId, MultipartFile file, Integer tag) {
        log.info("投稿流程模块-上传文件：{}",processId);
        // 1.校验流程是否存在
         SubmissionProcess process = submissionProcessMapper.selectByProcessId(processId);
        if (process == null) {
            throw new ServiceException("投稿流程不存在");
        }
        // 2. 保存文件到本地
        String filePath;
        try {
            filePath = FileUtils.uploadSubmissionFile(experimentConfig.getSubmissionBaseDir(), file);
        } catch (Exception e) {
            log.error("投稿流程模块-上传文件失败", e);
            throw new ServiceException("文件上传失败");
        }
        
        // 2. 保存文件信息到数据库
        SubmissionProcessFile submissionProcessFile = new SubmissionProcessFile();
        submissionProcessFile.setProcessId(processId);
        submissionProcessFile.setTag(tag);
        submissionProcessFile.setFileName(com.ruoyi.common.utils.file.FileUtils.getNameNotSuffix(file.getOriginalFilename()));
        submissionProcessFile.setFilePath(filePath);
        submissionProcessFile.setFileType(FileUploadUtils.getExtension(file));
        submissionProcessFile.setFileSize((int) file.getSize());
        submissionProcessFile.setUploadTime(LocalDateTime.now());

        submissionProcessFileMapper.insert(submissionProcessFile);
    }

    @Override
    public void downloadFile(Long fileId, HttpServletResponse response) {
        log.info("投稿流程模块-下载文件：{}",fileId);
        String filePath = submissionProcessFileMapper.selectFilePathById(fileId);
        if (filePath == null) {
            throw new ServiceException("文件不存在");
        }
        try{
            FileUtils.downloadFile(experimentConfig.getSubmissionBaseDir(), filePath, response);
        }catch (Exception e){
            log.error("投稿流程模块-下载文件失败", e);
            throw new ServiceException("文件下载失败");
        }
    }

    @Override
    public void deleteFile(Long id) {
        log.info("投稿流程模块-删除文件：{}",id);
        // 1. 校验文件是否存在
        SubmissionProcessFile submissionProcessFile = submissionProcessFileMapper.selectByFileId(id);
        if (submissionProcessFile == null) {
            throw new ServiceException("文件不存在");
        }
        // 2.校验用户权限
        SubmissionProcess submissionProcess = submissionProcessMapper.selectByProcessId(submissionProcessFile.getProcessId());
        SubmissionPlanDetailVO submissionPlan = submissionPlanMapper.selectById(submissionProcess.getPlanId());

        boolean canDelete = SecurityUtils.isTeacher() || SecurityUtils.getUserId().equals(submissionPlan.getCreateUserId());
        if (!canDelete) {
            throw new ServiceException("用户没有权限删除文件");
        }

        // 2. 删除数据库记录
        submissionProcessFileMapper.delete(id);
        
        // 3. 删除物理文件
        Path filePath = Paths.get(FileUtils.getFileAbsolutePath(experimentConfig.getSubmissionBaseDir(), submissionProcessFile.getFilePath()));
        try {
            if (Files.exists(filePath)) {
                Files.delete(filePath);
            }
        } catch (Exception e) {
            log.error("投稿流程模块-删除文件失败", e);
            throw new ServiceException("文件删除失败");
        }
    }

    @Override
    public List<SubmissionProcessFile> getProcessFiles(Long processId) {
        log.info("投稿流程模块-查询投稿流程下的文件列表：{}",processId);
        return submissionProcessFileMapper.selectByProcessId(processId);
    }
}