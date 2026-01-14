package com.ruoyi.experiment.service.impl;

import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.experiment.mapper.LiteratureReadMapper;
import com.ruoyi.experiment.pojo.dto.LiteratureReadQueryDTO;
import com.ruoyi.experiment.pojo.vo.LiteratureReadVO;
import com.ruoyi.experiment.service.LiteratureReadService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;

import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class LiteratureReadServiceImpl implements LiteratureReadService {
    private final LiteratureReadMapper literatureReadMapper;

    @Override
    public List<LiteratureReadVO> list(LiteratureReadQueryDTO queryDTO) {
        queryDTO.setUserId(SecurityUtils.getUserId());
        // 设置关键词数量，用于AND逻辑查询
        if (!CollectionUtils.isEmpty(queryDTO.getKeywordIds())) {
            queryDTO.setKeywordIdsSize(queryDTO.getKeywordIds().size());
        } else {
            queryDTO.setKeywordIdsSize(0);
        }
        return literatureReadMapper.selectLiteratureReadList(queryDTO);
    }
}
