package com.ruoyi.experiment.service.impl;

import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.experiment.enums.TaskStatusEnum;
import com.ruoyi.experiment.mapper.TaskMapper;
import com.ruoyi.experiment.pojo.entity.Task;
import com.ruoyi.experiment.pojo.vo.TaskVO;
import com.ruoyi.experiment.service.TaskService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class TaskServiceImpl implements TaskService {
    private final TaskMapper taskMapper;

    /**
     * 安全地将对象转换为int值
     * 支持Integer、Long、BigDecimal、Double、Float和String类型
     * @param value 要转换的对象
     * @return 转换后的int值，转换失败返回0
     */
    private int safeToInt(Object value) {
        if (value == null) {
            return 0;
        }
        if (value instanceof Integer) {
            return (Integer) value;
        }
        if (value instanceof Long) {
            return ((Long) value).intValue();
        }
        if (value instanceof BigDecimal) {
            return ((BigDecimal) value).intValue();
        }
        if (value instanceof Double) {
            return ((Double) value).intValue();
        }
        if (value instanceof Float) {
            return ((Float) value).intValue();
        }
        if (value instanceof String) {
            try {
                return Integer.parseInt((String) value);
            } catch (NumberFormatException e) {
                return 0;
            }
        }
        return 0;
    }
    @Override
    public List<TaskVO> getParentTasks(Long parentTaskId){
        // 获取仅自己可见+所有可见的任务
        Long userId = SecurityUtils.getUserId();
        // 获取所有父任务
        // 一级父任务按创建时间倒序，二级及以下父任务按任务顺序倒序
        List<TaskVO> tasks = 0L==parentTaskId?taskMapper.selectFirstParentTasks(parentTaskId,userId):taskMapper.selectSubParentTasks(parentTaskId,userId);
        // 获取存在子任务的父任务id列表
        List<Long> parentIdsWithSubTasks = taskMapper.selectParentIdsWithSubTasks(tasks.stream().map(TaskVO::getTaskId).collect(Collectors.toList()));
        // 对于PROCESSING的任务，需要计算完成进度
        for (TaskVO task : tasks) {
            if(parentIdsWithSubTasks.contains(task.getTaskId())){
                task.setHasSubTasks(true);
                // 有子任务&&状态为PROCESSING
                if(TaskStatusEnum.PROCESSING.getStatus().equals(task.getTaskStatus())){
                    Map<String, Object> map = taskMapper.selectCalculatePercentage(task.getTaskId());
                    int completedSubTasks = safeToInt(map.get("completedSubTasks"));
                    int totalSubTasks = safeToInt(map.get("totalSubTasks"));
                    if(totalSubTasks > 0 && completedSubTasks < totalSubTasks){
                        task.setPercentage(completedSubTasks * 100 / totalSubTasks);
                    }else{
                        task.setPercentage(100);
                    }
                }else {
                    // 有子任务&&状态不为PROCESSING
                    task.setPercentage(100);
                }
            }else{
                task.setHasSubTasks(false);
                // 没有子任务，进度条拉满
                task.setPercentage(100);
            }
        }
        return tasks;
    }

    @Override
    public Task getTaskById(Long taskId) {
        return taskMapper.selectTaskById(taskId);
    }
}
