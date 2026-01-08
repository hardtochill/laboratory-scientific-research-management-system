package com.ruoyi.experiment.controller;

import com.ruoyi.experiment.service.SubmissionProcessFileService;
import com.ruoyi.experiment.service.SubmissionProcessService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/submissionProcessFile")
@RequiredArgsConstructor
public class SubmissionProcessFileController {
    private final SubmissionProcessFileService submissionProcessFileService;
}
