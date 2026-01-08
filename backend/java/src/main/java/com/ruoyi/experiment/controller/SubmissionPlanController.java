package com.ruoyi.experiment.controller;

import com.ruoyi.experiment.service.SubmissionPlanService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/submissionPlan")
@RequiredArgsConstructor
public class SubmissionPlanController {
    private final SubmissionPlanService submissionPlanService;
}
