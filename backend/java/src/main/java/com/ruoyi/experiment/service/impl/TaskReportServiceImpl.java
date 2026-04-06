package com.ruoyi.experiment.service.impl;

import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.experiment.mapper.TaskReportFileMapper;
import com.ruoyi.experiment.mapper.TaskReportMapper;
import com.ruoyi.experiment.pojo.dto.TaskReportDto;
import com.ruoyi.experiment.pojo.entity.TaskReport;
import com.ruoyi.experiment.pojo.entity.TaskReportFile;
import com.ruoyi.experiment.pojo.vo.TaskReportVo;
import com.ruoyi.experiment.service.TaskReportFileService;
import com.ruoyi.experiment.service.TaskReportService;
import com.ruoyi.experiment.utils.FileUtils;
import com.ruoyi.framework.config.ExperimentConfig;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
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

/**
 * 任务汇报服务实现类
 *
 * @author ruoyi
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class TaskReportServiceImpl implements TaskReportService {

    private final TaskReportMapper taskReportMapper;
    private final TaskReportFileMapper taskReportFileMapper;
    private final TaskReportFileService taskReportFileService;
    private final ExperimentConfig experimentConfig;

    /**
     * 查询任务汇报列表
     *
     * @param taskId    任务id
     * @param startTime 开始时间
     * @param endTime   结束时间
     * @return 任务汇报列表
     */
    @Override
    public List<TaskReportVo> getTaskReportList(Long taskId, LocalDateTime startTime, LocalDateTime endTime) {
        log.info("查询任务汇报列表, taskId: {}, startTime: {}, endTime: {}", taskId, startTime, endTime);
        List<TaskReportVo> taskReportVoList = taskReportMapper.selectTaskReportList(taskId, startTime, endTime);
        // 查询每个汇报关联的文件列表
        for (TaskReportVo taskReportVo : taskReportVoList) {
            taskReportVo.setTaskReportFiles(taskReportFileMapper.selectVOByTaskReportId(taskReportVo.getId()));
        }
        return taskReportVoList;
    }

    /**
     * 新增任务汇报
     *
     * @param taskReportDto 任务汇报DTO
     * @return 结果
     */
    @Override
    @Transactional
    public int addTaskReport(TaskReportDto taskReportDto) {
        log.info("新增任务汇报, taskId: {}", taskReportDto.getTaskId());
        TaskReport taskReport = new TaskReport();
        BeanUtils.copyProperties(taskReportDto, taskReport);
        taskReport.setUserId(SecurityUtils.getUserId());
        taskReport.setUserNickName(SecurityUtils.getLoginUser().getUser().getNickName());
        taskReport.setReportTime(LocalDateTime.now());
        taskReport.setCreateTime(LocalDateTime.now());
        taskReport.setUpdateTime(LocalDateTime.now());
        int result = taskReportMapper.insertTaskReport(taskReport);
        
        // 如果有文件，则上传文件
        List<MultipartFile> fileList = taskReportDto.getFileList();
        if (!CollectionUtils.isEmpty(fileList)) {
            taskReportFileService.uploadFiles(taskReport.getId(), fileList);
        }
        
        log.info("新增任务汇报成功, reportId: {}", taskReport.getId());
        return result;
    }

    /**
     * 删除任务汇报
     *
     * @param reportId 汇报id
     * @return 结果
     */
    @Override
    @Transactional
    public int deleteTaskReport(Long reportId) {
        log.info("删除任务汇报, reportId: {}", reportId);
        
        // 先删除关联的文件
        List<String> filePaths = taskReportFileMapper.selectFilePathsByTaskReportId(reportId);
        if (!CollectionUtils.isEmpty(filePaths)) {
            try {
                for (String filePath : filePaths) {
                    Path path = Paths.get(FileUtils.getFileAbsolutePath(experimentConfig.getTaskReportBaseDir(), filePath));
                    if (Files.exists(path)) {
                        Files.delete(path);
                    }
                }
            } catch (Exception e) {
                log.error("删除任务汇报关联文件失败", e);
            }
            taskReportFileMapper.deleteByTaskReportId(reportId);
        }
        
        // 再删除汇报
        int result = taskReportMapper.deleteTaskReportById(reportId);
        return result;
    }
}
