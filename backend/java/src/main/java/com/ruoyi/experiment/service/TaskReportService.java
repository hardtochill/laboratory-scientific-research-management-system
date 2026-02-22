package com.ruoyi.experiment.service;

import com.ruoyi.experiment.pojo.dto.TaskReportDto;
import com.ruoyi.experiment.pojo.vo.TaskReportVo;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 任务汇报服务接口
 *
 * @author ruoyi
 */
public interface TaskReportService {

    /**
     * 查询任务汇报列表
     *
     * @param taskId    任务id
     * @param startTime 开始时间
     * @param endTime   结束时间
     * @return 任务汇报列表
     */
    List<TaskReportVo> getTaskReportList(Long taskId, LocalDateTime startTime, LocalDateTime endTime);

    /**
     * 新增任务汇报
     *
     * @param taskReportDto 任务汇报DTO
     * @return 结果
     */
    int addTaskReport(TaskReportDto taskReportDto);

    /**
     * 删除任务汇报
     *
     * @param reportId 汇报id
     * @return 结果
     */
    int deleteTaskReport(Long reportId);
}
