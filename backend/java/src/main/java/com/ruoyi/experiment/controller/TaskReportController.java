package com.ruoyi.experiment.controller;

import com.ruoyi.experiment.service.TaskReportService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/taskReport")
@RequiredArgsConstructor
public class TaskReportController {
    private final TaskReportService taskReportService;
}
