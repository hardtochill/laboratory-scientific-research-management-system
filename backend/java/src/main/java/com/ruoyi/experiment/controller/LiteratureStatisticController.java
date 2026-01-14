package com.ruoyi.experiment.controller;

import com.ruoyi.experiment.annotations.CheckTeacher;
import com.ruoyi.experiment.pojo.dto.LiteratureStatisticQueryDTO;
import com.ruoyi.experiment.service.LiteratureStatisticService;
import com.ruoyi.framework.web.controller.BaseController;
import com.ruoyi.framework.web.domain.AjaxResult;
import com.ruoyi.framework.web.page.TableDataInfo;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.time.LocalDateTime;

@RestController
@RequestMapping("/statistic")
@RequiredArgsConstructor
public class LiteratureStatisticController extends BaseController {
    private final LiteratureStatisticService literatureStatisticService;

    @GetMapping("/list")
    @CheckTeacher
    public TableDataInfo list(LiteratureStatisticQueryDTO queryDTO) {
        startPage();
        return getDataTable(literatureStatisticService.selectStudentReadingStatistics(queryDTO));
    }

    @GetMapping("/literature/list")
    @CheckTeacher
    public TableDataInfo literatureList(LiteratureStatisticQueryDTO queryDTO) {
        startPage();
        return getDataTable(literatureStatisticService.selectLiteratureReadingStatistics(queryDTO));
    }

    /**
     * 获取用户列表（用于前端用户选择）
     */
    @GetMapping("/listUsersForSelect")
    public AjaxResult listUsersForSelect(String nickName) {
        return AjaxResult.success(literatureStatisticService.listUsersForSelect(nickName));
    }

    @GetMapping("/student/{studentId}")
    @CheckTeacher
    public AjaxResult getStudentReadingDetail(
            @PathVariable Long studentId,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime startTime,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime endTime) {
        return AjaxResult.success(literatureStatisticService.selectStudentLiteratureDetail(studentId, startTime, endTime));
    }

    @GetMapping("/literature/{literatureId}")
    @CheckTeacher
    public AjaxResult getLiteratureReadingDetail(
            @PathVariable Long literatureId,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime startTime,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime endTime) {
        return AjaxResult.success(literatureStatisticService.selectLiteratureStudentDetail(literatureId, startTime, endTime));
    }

    @GetMapping("/export")
    @CheckTeacher
    public void export(
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime startTime,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime endTime,
            @RequestParam(required = false) Long userId,
            @RequestParam(required = false) Long literatureId,
            HttpServletResponse response) {
        LiteratureStatisticQueryDTO queryDTO = new LiteratureStatisticQueryDTO();
        queryDTO.setStartTime(startTime);
        queryDTO.setEndTime(endTime);
        queryDTO.setUserId(userId);
        queryDTO.setLiteratureId(literatureId);
        literatureStatisticService.exportStatistics(queryDTO, response);
    }
}
