package com.ruoyi.experiment.service.impl;

import com.ruoyi.experiment.mapper.SubmissionPlanMapper;
import com.ruoyi.experiment.service.SubmissionPlanService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;


@Service
@RequiredArgsConstructor
@Slf4j
public class SubmissionPlanServiceImpl implements SubmissionPlanService {
    private final SubmissionPlanMapper submissionPlanMapper;
}
