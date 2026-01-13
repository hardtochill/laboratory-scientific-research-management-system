package com.ruoyi.experiment.controller;

import com.ruoyi.experiment.annotations.CheckTeacher;
import com.ruoyi.experiment.pojo.dto.StatisticQueryDTO;
import com.ruoyi.experiment.pojo.vo.LiteratureReadStatisticsVO;
import com.ruoyi.experiment.pojo.vo.StudentReadStatisticsVO;
import com.ruoyi.experiment.service.StatisticService;
import com.ruoyi.framework.web.controller.BaseController;
import com.ruoyi.framework.web.domain.AjaxResult;
import com.ruoyi.framework.web.page.TableDataInfo;
import com.ruoyi.project.system.domain.dto.UserForSelectQueryDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.time.LocalDateTime;

@RestController
@RequestMapping("/statistic")
@RequiredArgsConstructor
public class StatisticController extends BaseController {
    private final StatisticService statisticService;

    @GetMapping("/list")
    @CheckTeacher
    public TableDataInfo list(StatisticQueryDTO queryDTO) {
        startPage();
        return getDataTable(statisticService.selectStudentReadingStatistics(queryDTO));
    }

    @GetMapping("/literature/list")
    @CheckTeacher
    public TableDataInfo literatureList(StatisticQueryDTO queryDTO) {
        startPage();
        return getDataTable(statisticService.selectLiteratureReadingStatistics(queryDTO));
    }

    /**
     * 获取用户列表（用于前端用户选择）
     */
    @GetMapping("/listUsersForSelect")
    public AjaxResult listUsersForSelect(String nickName) {
        return AjaxResult.success(statisticService.listUsersForSelect(nickName));
    }

    @GetMapping("/student/{studentId}")
    @CheckTeacher
    public AjaxResult getStudentReadingDetail(
            @PathVariable Long studentId,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime startTime,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime endTime) {
        return AjaxResult.success(statisticService.selectStudentLiteratureDetail(studentId, startTime, endTime));
    }

    @GetMapping("/literature/{literatureId}")
    @CheckTeacher
    public AjaxResult getLiteratureReadingDetail(
            @PathVariable Long literatureId,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime startTime,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime endTime) {
        return AjaxResult.success(statisticService.selectLiteratureStudentDetail(literatureId, startTime, endTime));
    }

    @GetMapping("/export")
    @CheckTeacher
    public void export(
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime startTime,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime endTime,
            @RequestParam(required = false) Long userId,
            @RequestParam(required = false) Long literatureId,
            HttpServletResponse response) {
        StatisticQueryDTO queryDTO = new StatisticQueryDTO();
        queryDTO.setStartTime(startTime);
        queryDTO.setEndTime(endTime);
        queryDTO.setUserId(userId);
        queryDTO.setLiteratureId(literatureId);
        statisticService.exportStatistics(queryDTO, response);
    }
}
