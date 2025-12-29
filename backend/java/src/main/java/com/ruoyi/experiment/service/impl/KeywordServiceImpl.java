package com.ruoyi.experiment.service.impl;

import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.experiment.mapper.KeywordMapper;
import com.ruoyi.experiment.mapper.LiteratureKeywordMapper;
import com.ruoyi.experiment.pojo.dto.KeywordDTO;
import com.ruoyi.experiment.pojo.dto.KeywordQueryDTO;
import com.ruoyi.experiment.pojo.entity.Keyword;
import com.ruoyi.experiment.service.KeywordService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 关键词管理服务实现类
 */
@Service
@RequiredArgsConstructor
public class KeywordServiceImpl implements KeywordService {

    private final KeywordMapper keywordMapper;
    private final LiteratureKeywordMapper literatureKeywordMapper;

    @Override
    public List<Keyword> selectKeywordList(KeywordQueryDTO keywordQueryDTO) {
        return keywordMapper.selectKeywordList(keywordQueryDTO);
    }

    @Override
    @Transactional
    public void addKeyword(KeywordDTO keywordDTO) {
        // 校验关键词名称是否已存在
        if (keywordMapper.selectByKeywordName(keywordDTO.getKeywordName()) != null) {
            throw new ServiceException("关键词名称已存在");
        }
        Keyword keyword = new Keyword();
        keyword.setKeywordName(keywordDTO.getKeywordName());
        keyword.setDescription(keywordDTO.getDescription());
        keyword.setUsageCount(0);
        keywordMapper.insertKeyword(keyword);
    }

    @Override
    @Transactional
    public void updateKeyword(KeywordDTO keywordDTO) {
        // 校验关键词是否存在
        Keyword originKeyword = keywordMapper.selectById(keywordDTO.getId());
        if (originKeyword == null) {
            throw new ServiceException("关键词不存在");
        }
        Keyword nameKeyword = keywordMapper.selectByKeywordName(keywordDTO.getKeywordName());
        if(nameKeyword != null && !nameKeyword.getId().equals(keywordDTO.getId())) {
            throw new ServiceException("关键词已存在");
        }
        Keyword keyword = new Keyword();
        keyword.setId(keywordDTO.getId());
        keyword.setKeywordName(keywordDTO.getKeywordName());
        keyword.setDescription(keywordDTO.getDescription());
        keywordMapper.updateKeyword(keyword);
    }

    @Override
    @Transactional
    public void deleteKeywords(Long[] keywordIds) {
        // 删除关键词
        keywordMapper.deleteKeywords(keywordIds);
        // 删除文献关键词关联
        literatureKeywordMapper.deleteByKeywordIds(keywordIds);
    }
}
