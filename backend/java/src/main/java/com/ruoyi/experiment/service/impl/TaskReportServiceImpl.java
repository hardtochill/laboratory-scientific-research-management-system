package com.ruoyi.experiment.service.impl;

import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.experiment.mapper.TaskReportMapper;
import com.ruoyi.experiment.pojo.dto.TaskReportDto;
import com.ruoyi.experiment.pojo.entity.TaskReport;
import com.ruoyi.experiment.pojo.vo.TaskReportVo;
import com.ruoyi.experiment.service.TaskReportService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
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
        return taskReportMapper.selectTaskReportList(taskId, startTime, endTime);
    }

    /**
     * 新增任务汇报
     *
     * @param taskReportDto 任务汇报DTO
     * @return 结果
     */
    @Override
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
    public int deleteTaskReport(Long reportId) {
        log.info("删除任务汇报, reportId: {}", reportId);
        int result = taskReportMapper.deleteTaskReportById(reportId);
        return result;
    }
}
