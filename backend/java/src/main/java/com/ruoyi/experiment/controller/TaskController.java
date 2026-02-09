package com.ruoyi.experiment.controller;

import com.ruoyi.experiment.annotations.CheckTeacher;
import com.ruoyi.experiment.pojo.dto.TaskDTO;
import com.ruoyi.experiment.pojo.dto.TaskQueryDTO;
import com.ruoyi.experiment.pojo.entity.Task;
import com.ruoyi.experiment.pojo.vo.TaskStatisticsVO;
import com.ruoyi.experiment.pojo.vo.TaskVO;
import com.ruoyi.experiment.service.TaskService;
import com.ruoyi.framework.web.controller.BaseController;
import com.ruoyi.framework.web.domain.AjaxResult;
import com.ruoyi.framework.web.page.TableDataInfo;
import com.ruoyi.project.system.domain.SysUser;
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
     * 分页获取父任务列表（包含统计数据）
     *
     * @return 分页任务列表
     */
    @GetMapping("/listParents")
    public AjaxResult getParentTaskList(TaskQueryDTO taskQueryDTO) {
        TaskStatisticsVO result = taskService.selectParentTaskListWithStatistics(taskQueryDTO);
        return AjaxResult.success(result);
    }

    /**
     * 根据父任务ID获取子任务列表
     *
     * @param parentTaskId 父任务ID
     * @return 子任务列表
     */
    @GetMapping("/listSubs/{parentTaskId}")
    public AjaxResult getSubTaskList(@PathVariable Long parentTaskId) {
        List<TaskVO> subTasks = taskService.selectSubTaskList(parentTaskId);
        return AjaxResult.success(subTasks);
    }

    /**
     * 获取用户列表（用于前端用户选择）
     */
    @GetMapping("/listUsersForSelect")
    public AjaxResult listUsersForSelect(String nickName) {
        return AjaxResult.success(taskService.listUsersForSelect(nickName));
    }

    /**
     * 获取学生列表（用于前端用户选择）
     */
    @GetMapping("/listStudentsForSelect")
    public AjaxResult listStudentsForSelect(String nickName) {
        return AjaxResult.success(taskService.listStudentsForSelect(nickName));
    }

    /**
     * 根据任务ID获取任务详情
     *
     * @param taskId 任务ID
     * @return 任务详情
     */
    @GetMapping("/getDetail/{taskId}")
    public AjaxResult getTaskDetail(@PathVariable Long taskId) {
        Task task = taskService.getTaskById(taskId);
        return AjaxResult.success(task);
    }

    /**
     * 添加任务
     */
    @PostMapping("/add")
    public AjaxResult addTask(@Validated @RequestBody TaskDTO taskDTO) {
        taskService.addTask(taskDTO);
        return AjaxResult.success();
    }
    /**
     * 更新任务
     */
    @PostMapping("/update")
    public AjaxResult updateTask(@Validated @RequestBody TaskDTO taskDTO) {
        taskService.updateTask(taskDTO);
        return AjaxResult.success();
    }


    /**
     * 更新任务状态
     */
    @PostMapping("/updateStatus")
    public AjaxResult updateTaskStatus(Long taskId,Integer status) {
        taskService.updateTaskStatus(taskId,status);
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

    /**
     * 根据任务ID获取参与用户组
     */
    @GetMapping("/getParticipantUsers/{taskId}")
    public AjaxResult getParticipantUsers(@PathVariable Long taskId) {
        List<SysUser> users = taskService.getParticipantUsersByTaskId(taskId);
        return AjaxResult.success(users);
    }
}
