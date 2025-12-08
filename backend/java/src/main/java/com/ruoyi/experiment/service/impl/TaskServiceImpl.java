package com.ruoyi.experiment.service.impl;

import com.ruoyi.experiment.mapper.TaskMapper;
import com.ruoyi.experiment.pojo.entity.Task;
import com.ruoyi.experiment.service.TaskService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@RequiredArgsConstructor
public class TaskServiceImpl implements TaskService {
    private final TaskMapper taskMapper;
}
