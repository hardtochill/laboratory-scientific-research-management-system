package com.ruoyi.experiment.service.impl;

import com.ruoyi.experiment.mapper.UnreportedTaskMapper;
import com.ruoyi.experiment.pojo.dto.UnreportedTaskQueryDTO;
import com.ruoyi.experiment.pojo.vo.UnreportedTaskVO;
import com.ruoyi.experiment.service.UnreportedTaskService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;

/**
 * 待汇报任务Service实现
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class UnreportedTaskServiceImpl implements UnreportedTaskService {

    private final UnreportedTaskMapper unreportedTaskMapper;

    @Override
    public List<UnreportedTaskVO> selectUnreportedTaskList(UnreportedTaskQueryDTO queryDTO) {
        log.info("待汇报任务查询：{}", queryDTO);
        return unreportedTaskMapper.selectUnreportedTaskList(queryDTO);
    }

    @Override
    public List<UnreportedTaskVO> selectParentTasksByTaskId(Long taskId) {
        log.info("查询任务的父任务列表：taskId={}", taskId);
        return unreportedTaskMapper.selectParentTasksByTaskId(taskId);
    }
}
