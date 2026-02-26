package com.ruoyi.experiment.service.impl;

import com.ruoyi.experiment.mapper.UnreportedTaskMapper;
import com.ruoyi.experiment.pojo.dto.UnreportedTaskQueryDTO;
import com.ruoyi.experiment.pojo.vo.UnreportedTaskVO;
import com.ruoyi.experiment.service.UnreportedTaskService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;

/**
 * 待汇报任务Service实现
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class UnreportedTaskServiceImpl implements UnreportedTaskService {

    private final UnreportedTaskMapper unreportedTaskMapper;

    @Override
    public List<UnreportedTaskVO> selectUnreportedTaskList(UnreportedTaskQueryDTO queryDTO) {
        log.info("待汇报任务查询：{}", queryDTO);
        List<UnreportedTaskVO> taskList = unreportedTaskMapper.selectUnreportedTaskList(queryDTO);
        // 计算任务进度
        for (UnreportedTaskVO task : taskList) {
            task.setPercentage(calculatePercentage(task));
        }
        return taskList;
    }

    @Override
    public List<UnreportedTaskVO> selectParentTasksByTaskId(Long taskId) {
        log.info("查询任务的父任务列表：taskId={}", taskId);
        List<UnreportedTaskVO> parentList = unreportedTaskMapper.selectParentTasksByTaskId(taskId);
        // 计算任务进度
        for (UnreportedTaskVO task : parentList) {
            task.setPercentage(calculatePercentage(task));
        }
        return parentList;
    }

    /**
     * 计算任务进度百分比
     *
     * @param task 任务
     * @return 进度百分比
     */
    private Integer calculatePercentage(UnreportedTaskVO task) {
        Long subTaskCount = task.getSubTaskCount();
        Long completedSubTaskCount = task.getCompletedSubTaskCount();

        if (subTaskCount == null || subTaskCount == 0) {
            // 没有子任务，根据任务状态判断
            if (task.getTaskStatus() != null && task.getTaskStatus() >= 3) {
                return 100;
            }
            return 0;
        }

        // 有子任务，根据子任务完成情况计算进度
        BigDecimal percentage = new BigDecimal(completedSubTaskCount)
                .multiply(new BigDecimal(100))
                .divide(new BigDecimal(subTaskCount), 0, RoundingMode.HALF_UP);
        return percentage.intValue();
    }
}
