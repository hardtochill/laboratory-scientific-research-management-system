package com.ruoyi.experiment.controller;


import com.ruoyi.experiment.pojo.dto.TaskReportDto;
import com.ruoyi.experiment.pojo.vo.TaskReportVo;
import com.ruoyi.experiment.service.TaskReportService;
import com.ruoyi.framework.aspectj.lang.enums.BusinessType;
import com.ruoyi.framework.web.controller.BaseController;
import com.ruoyi.framework.web.domain.AjaxResult;
import com.ruoyi.framework.web.page.TableDataInfo;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 任务汇报Controller
 *
 * @author ruoyi
 */
@RestController
@RequestMapping("/taskReport")
@RequiredArgsConstructor
public class TaskReportController extends BaseController {

    private final TaskReportService taskReportService;

    /**
     * 查询任务汇报列表
     *
     * @param taskId    任务id
     * @param startTime 开始时间
     * @param endTime   结束时间
     * @return 任务汇报列表
     */
    @GetMapping("/list/{taskId}")
    public TableDataInfo list(@PathVariable Long taskId,
                              @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime startTime,
                              @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime endTime) {
        List<TaskReportVo> list = taskReportService.getTaskReportList(taskId, startTime, endTime);
        return getDataTable(list);
    }

    /**
     * 新增任务汇报
     *
     * @param taskReportDto 任务汇报DTO
     * @return 结果
     */
    @PostMapping
    public AjaxResult add(@RequestBody TaskReportDto taskReportDto) {
        return toAjax(taskReportService.addTaskReport(taskReportDto));
    }

    /**
     * 删除任务汇报
     *
     * @param reportId 汇报id
     * @return 结果
     */
    @DeleteMapping("/{reportId}")
    public AjaxResult remove(@PathVariable Long reportId) {
        return toAjax(taskReportService.deleteTaskReport(reportId));
    }
}
