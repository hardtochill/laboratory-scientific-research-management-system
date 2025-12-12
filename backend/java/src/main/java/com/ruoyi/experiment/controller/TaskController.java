package com.ruoyi.experiment.controller;

import com.ruoyi.experiment.pojo.dto.TaskDTO;
import com.ruoyi.experiment.pojo.entity.Task;
import com.ruoyi.experiment.pojo.vo.TaskVO;
import com.ruoyi.experiment.service.TaskService;
import com.ruoyi.framework.web.controller.BaseController;
import com.ruoyi.framework.web.domain.AjaxResult;
import com.ruoyi.framework.web.page.TableDataInfo;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/task")
@RequiredArgsConstructor
public class TaskController extends BaseController {
    private final TaskService taskService;
    /**
     * 分页获取父任务列表
     * @return 分页任务列表
     */
    @GetMapping("/list")
    public TableDataInfo getTaskList(TaskDTO taskDTO) {
        startPage();
        List<TaskVO> list = taskService.selectParentTaskList(taskDTO);
        return getDataTable(list);
    }

    /**
     * 根据父任务ID获取子任务列表
     * @param parentTaskId 父任务ID
     * @return 子任务列表
     */
    @GetMapping("/sub-tasks/{parentTaskId}")
    public AjaxResult getSubTasks(@PathVariable Long parentTaskId) {
        List<TaskVO> subTasks = taskService.selectSubTaskList(parentTaskId);
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
