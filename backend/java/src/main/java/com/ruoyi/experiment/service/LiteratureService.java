package com.ruoyi.experiment.service;

import com.ruoyi.experiment.pojo.dto.LiteratureQueryDTO;
import com.ruoyi.experiment.pojo.dto.LiteratureScoreDTO;
import com.ruoyi.experiment.pojo.vo.LiteratureVO;

import java.util.List;

public interface LiteratureService {
    /**
     * 根据查询条件查询文献列表
     * @param queryDTO 查询条件
     * @return 文献列表
     */
    List<LiteratureVO> selectLiteratureList(LiteratureQueryDTO queryDTO);
    
    /**
     * 根据文献id查询文献详情
     * @param id 文献id
     * @return 文献详情
     */
    Object selectLiteratureDetail(Long id);
    
    /**
     * 下载文献
     * @param id 文献id
     * @return 文献文件路径
     */
    String downloadLiterature(Long id);

    /**
     * 评分文献
     * @param scoreDTO 评分DTO
     */
    void scoreLiterature(LiteratureScoreDTO scoreDTO);
    
    /**
     * 获取用户对文献的评分
     * @param literatureId 文献ID
     * @param userId 用户ID
     * @return 用户评分记录
     */
    Integer getUserLiteratureScore(Long literatureId, Long userId);
}
