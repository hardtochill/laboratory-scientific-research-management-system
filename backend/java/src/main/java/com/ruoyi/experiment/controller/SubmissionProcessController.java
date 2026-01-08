package com.ruoyi.experiment.controller;

import com.ruoyi.experiment.service.SubmissionPlanService;
import com.ruoyi.experiment.service.SubmissionProcessService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/submissionProcess")
@RequiredArgsConstructor
public class SubmissionProcessController {
    private final SubmissionProcessService submissionProcessService;
}
