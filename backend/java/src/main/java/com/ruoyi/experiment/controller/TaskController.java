package com.ruoyi.experiment.controller;

import com.ruoyi.experiment.pojo.entity.Task;
import com.ruoyi.experiment.service.TaskService;
import com.ruoyi.framework.aspectj.lang.annotation.Anonymous;
import com.ruoyi.framework.web.domain.AjaxResult;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/task")
@RequiredArgsConstructor
@Anonymous
public class TaskController {
    private final TaskService taskService;

    /**
     * 获取所有父任务
     * @return 父任务列表
     */
    @GetMapping("/parent-tasks")
    public AjaxResult getParentTasks() {
        List<Task> parentTasks = taskService.getAllTasksWithHierarchy();
        return AjaxResult.success(parentTasks);
    }

    /**
     * 根据父任务ID获取子任务列表
     * @param parentTaskId 父任务ID
     * @return 子任务列表
     */
    @GetMapping("/sub-tasks/{parentTaskId}")
    public AjaxResult getSubTasks(@PathVariable Long parentTaskId) {
        List<Task> subTasks = taskService.getSubTasksByParentId(parentTaskId);
        return AjaxResult.success(subTasks);
    }

    /**
     * 根据任务ID获取任务详情
     * @param taskId 任务ID
     * @return 任务详情
     */
    @GetMapping("/{taskId}")
    public AjaxResult getTaskDetail(@PathVariable Long taskId) {
        Task task = taskService.getTaskById(taskId);
        return AjaxResult.success(task);
    }
}
