package com.ruoyi.experiment.service;

import com.ruoyi.experiment.pojo.entity.Task;

import java.util.List;
import java.util.Map;

public interface TaskService {
    /**
     * 获取所有父任务及其子任务层级结构
     * @return 层级任务列表
     */
    List<Task> getAllTasksWithHierarchy();

    /**
     * 根据父任务ID获取子任务列表
     * @param parentTaskId 父任务ID
     * @return 子任务列表
     */
    List<Task> getSubTasksByParentId(Long parentTaskId);

    /**
     * 根据任务ID获取任务详情
     * @param taskId 任务ID
     * @return 任务详情
     */
    Task getTaskById(Long taskId);
}
