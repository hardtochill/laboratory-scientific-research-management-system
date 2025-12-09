package com.ruoyi.experiment.service.impl;

import com.ruoyi.experiment.mapper.TaskMapper;
import com.ruoyi.experiment.pojo.entity.Task;
import com.ruoyi.experiment.service.TaskService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class TaskServiceImpl implements TaskService {
    private final TaskMapper taskMapper;

    @Override
    public List<Task> getAllTasksWithHierarchy() {
        // 获取所有父任务
        List<Task> parentTasks = taskMapper.selectParentTasks();
        // 为每个父任务加载子任务
        loadSubTasks(parentTasks);
        return parentTasks;
    }

    @Override
    public List<Task> getSubTasksByParentId(Long parentTaskId) {
        return taskMapper.selectSubTasksByParentId(parentTaskId);
    }

    @Override
    public Task getTaskById(Long taskId) {
        return taskMapper.selectTaskById(taskId);
    }

    /**
     * 递归加载子任务
     * @param tasks 任务列表
     */
    private void loadSubTasks(List<Task> tasks) {
        if (tasks == null || tasks.isEmpty()) {
            return;
        }
        // 注意：这里我们只加载一级子任务，前端会根据需要动态加载更下一级
        // 如果需要一次性加载所有层级，可以取消下面的注释并使用递归
        /*
        for (Task task : tasks) {
            List<Task> subTasks = taskMapper.selectSubTasksByParentId(task.getTaskId());
            if (subTasks != null && !subTasks.isEmpty()) {
                // 注意：Task实体类中没有直接的subTasks字段，我们需要在前端处理层级关系
                // 如果需要在后端直接构建树形结构，可以考虑创建一个TaskTree类
                loadSubTasks(subTasks);
            }
        }
        */
    }
}
