package com.ruoyi.experiment.service.impl;

import com.ruoyi.experiment.mapper.SubmissionPlanMapper;
import com.ruoyi.experiment.mapper.SubmissionProcessMapper;
import com.ruoyi.experiment.service.SubmissionPlanService;
import com.ruoyi.experiment.service.SubmissionProcessService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;


@Service
@RequiredArgsConstructor
@Slf4j
public class SubmissionProcessServiceImpl implements SubmissionProcessService {
    private final SubmissionProcessMapper submissionProcessMapper;
}
