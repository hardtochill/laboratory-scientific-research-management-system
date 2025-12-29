package com.ruoyi.experiment.service;

import com.ruoyi.experiment.pojo.dto.KeywordDTO;
import com.ruoyi.experiment.pojo.dto.KeywordQueryDTO;
import com.ruoyi.experiment.pojo.entity.Keyword;

import java.util.List;

/**
 * 文献关键词管理服务接口
 */
public interface KeywordService {

    /**
     * 根据查询条件分页查询关键词列表
     * @param keywordQueryDTO 查询条件
     * @return 关键词列表
     */
    List<Keyword> selectKeywordList(KeywordQueryDTO keywordQueryDTO);

    /**
     * 新增关键词
     * @param keywordDTO 关键词信息
     */
    void addKeyword(KeywordDTO keywordDTO);

    /**
     * 修改关键词
     * @param keywordDTO 关键词信息
     */
    void updateKeyword(KeywordDTO keywordDTO);

    /**
     * 删除关键词
     * @param keywordIds 关键词ID数组
     */
    void deleteKeywords(Long[] keywordIds);
}
