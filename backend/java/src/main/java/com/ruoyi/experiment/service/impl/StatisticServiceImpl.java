package com.ruoyi.experiment.service.impl;

import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.experiment.mapper.CommentMapper;
import com.ruoyi.experiment.mapper.KeywordMapper;
import com.ruoyi.experiment.mapper.LiteratureKeywordMapper;
import com.ruoyi.experiment.pojo.dto.KeywordDTO;
import com.ruoyi.experiment.pojo.dto.KeywordQueryDTO;
import com.ruoyi.experiment.pojo.entity.Keyword;
import com.ruoyi.experiment.service.KeywordService;
import com.ruoyi.experiment.service.StatisticService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 文献统计管理服务实现类
 */
@Service
@RequiredArgsConstructor
public class StatisticServiceImpl implements StatisticService {
    private final CommentMapper commentMapper;
}
