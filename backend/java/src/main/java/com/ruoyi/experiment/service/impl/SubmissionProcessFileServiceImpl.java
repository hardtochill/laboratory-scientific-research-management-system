package com.ruoyi.experiment.service.impl;

import com.ruoyi.experiment.mapper.SubmissionProcessFileMapper;
import com.ruoyi.experiment.mapper.SubmissionProcessMapper;
import com.ruoyi.experiment.service.SubmissionProcessFileService;
import com.ruoyi.experiment.service.SubmissionProcessService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;


@Service
@RequiredArgsConstructor
@Slf4j
public class SubmissionProcessFileServiceImpl implements SubmissionProcessFileService {
    private final SubmissionProcessFileMapper submissionProcessFileMapper;
}
