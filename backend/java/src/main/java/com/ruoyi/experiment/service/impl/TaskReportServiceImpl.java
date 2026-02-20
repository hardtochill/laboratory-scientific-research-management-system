package com.ruoyi.experiment.service.impl;

import com.ruoyi.experiment.mapper.TaskReportMapper;
import com.ruoyi.experiment.service.TaskReportService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
@Slf4j
public class TaskReportServiceImpl implements TaskReportService {
    private final TaskReportMapper taskReportMapper;
}
