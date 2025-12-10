package com.ruoyi.experiment.service;

import com.ruoyi.experiment.pojo.entity.Task;
import com.ruoyi.experiment.pojo.vo.TaskVO;

import java.util.List;
import java.util.Map;

public interface TaskService {
    /**
     * 获取父任务列表
     */
    List<TaskVO> getParentTasks(Long parentTaskId);

    /**
     * 根据任务ID获取任务详情
     * @param taskId 任务ID
     * @return 任务详情
     */
    Task getTaskById(Long taskId);
}
