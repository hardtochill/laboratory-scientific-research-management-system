package com.ruoyi.experiment.controller;

import com.ruoyi.experiment.pojo.dto.TaskDTO;
import com.ruoyi.experiment.pojo.dto.TaskQueryDTO;
import com.ruoyi.experiment.pojo.entity.Task;
import com.ruoyi.experiment.pojo.vo.TaskVO;
import com.ruoyi.experiment.service.TaskService;
import com.ruoyi.framework.web.controller.BaseController;
import com.ruoyi.framework.web.domain.AjaxResult;
import com.ruoyi.framework.web.page.TableDataInfo;
import io.swagger.models.auth.In;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/task")
@RequiredArgsConstructor
public class TaskController extends BaseController {
    private final TaskService taskService;

    /**
     * 分页获取父任务列表
     *
     * @return 分页任务列表
     */
    @GetMapping("/list")
    public TableDataInfo getTaskList(TaskQueryDTO taskQueryDTO) {
        startPage();
        List<TaskVO> list = taskService.selectParentTaskList(taskQueryDTO);
        return getDataTable(list);
    }

    /**
     * 根据父任务ID获取子任务列表
     *
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
     *
     * @param taskId 任务ID
     * @return 任务详情
     */
    @GetMapping("/{taskId}")
    public AjaxResult getTaskDetail(@PathVariable Long taskId) {
        Task task = taskService.getTaskById(taskId);
        return AjaxResult.success(task);
    }

    /**
     * 添加或更新任务
     *
     * @param taskDTO 任务DTO
     * @return 成功响应
     */
    @PostMapping("/addOrUpdate")
    public AjaxResult addOrUpdateTask(@Validated @RequestBody TaskDTO taskDTO) {
        if (null == taskDTO.getTaskId()) {
            // 新增
            taskService.addTask(taskDTO);
        } else {
            // 修改
            taskService.updateTask(taskDTO);
        }
        return AjaxResult.success();
    }

    /**
     * 更新任务状态
     */
    @PostMapping("/updateTaskStatus")
    public AjaxResult updateTaskStatus(@RequestBody Task task) {
        taskService.updateTaskStatus(task);
        return AjaxResult.success();
    }

    /**
     * 删除任务
     */
    @DeleteMapping("/delete/{taskId}")
    public AjaxResult deleteTask(@PathVariable Long taskId) {
        taskService.deleteTask(taskId);
        return AjaxResult.success();
    }
}
