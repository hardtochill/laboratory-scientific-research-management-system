package com.ruoyi.experiment.controller;

import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.experiment.pojo.dto.UnreportedTaskQueryDTO;
import com.ruoyi.experiment.pojo.vo.UnreportedTaskVO;
import com.ruoyi.experiment.service.UnreportedTaskService;
import com.ruoyi.framework.web.controller.BaseController;
import com.ruoyi.framework.web.domain.AjaxResult;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 待汇报任务Controller
 */
@RestController
@RequestMapping("/unreportedTask")
@RequiredArgsConstructor
@Slf4j
public class UnreportedTaskController extends BaseController {

    private final UnreportedTaskService unreportedTaskService;

    /**
     * 查询待汇报任务列表
     *
     * @param timeoutFlag 1-已汇报/未超时，2-超时未汇报
     * @param executorUserId 任务执行用户ID（教师角色查询时使用）
     * @param taskType 任务类型（学生角色使用：1-我的待汇报任务，2-我的待接收汇报任务）
     * @return 任务列表
     */
    @GetMapping("/list/{timeoutFlag}")
    public AjaxResult listUnreportedTasks(
            @PathVariable Integer timeoutFlag,
            @RequestParam(required = false) Long executorUserId,
            @RequestParam(required = false) Integer taskType) {
        UnreportedTaskQueryDTO queryDTO = new UnreportedTaskQueryDTO();
        queryDTO.setTimeoutFlag(timeoutFlag);
        queryDTO.setCurrentUserId(SecurityUtils.getUserId());
        queryDTO.setExecutorUserId(executorUserId);
        queryDTO.setTaskType(taskType);
        
        // 判断用户角色
        if (SecurityUtils.isTeacher()) {
            queryDTO.setUserRole("teacher");
        } else {
            queryDTO.setUserRole("student");
        }
        
        List<UnreportedTaskVO> list = unreportedTaskService.selectUnreportedTaskList(queryDTO);
        return AjaxResult.success(list);
    }

    /**
     * 根据任务ID查询任务的所有父任务
     *
     * @param taskId 任务ID
     * @return 父任务列表
     */
    @GetMapping("/parentTasks/{taskId}")
    public AjaxResult getParentTasks(@PathVariable Long taskId) {
        List<UnreportedTaskVO> parentList = unreportedTaskService.selectParentTasksByTaskId(taskId);
        return AjaxResult.success(parentList);
    }
}
