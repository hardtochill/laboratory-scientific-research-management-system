package com.ruoyi.experiment.service;

import com.ruoyi.experiment.pojo.dto.LiteratureQueryDTO;
import com.ruoyi.experiment.pojo.dto.LiteratureScoreDTO;
import com.ruoyi.experiment.pojo.entity.Literature;
import com.ruoyi.experiment.pojo.vo.LiteratureDetailVO;
import com.ruoyi.experiment.pojo.vo.LiteratureVO;

import javax.servlet.http.HttpServletResponse;
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
    LiteratureDetailVO selectLiteratureDetail(Long id);
    
    /**
     * 下载文献
     * @param id 文献id
     * @return 文献对象
     */
    void downloadLiterature(Long id, HttpServletResponse response);

    /**
     * 评分文献
     * @param scoreDTO 评分DTO
     */
    void scoreLiterature(LiteratureScoreDTO scoreDTO);
    
    /**
     * 更新文献的关键词关联
     * @param literatureId 文献ID
     * @param keywordIds 关键词ID列表
     */
    void updateLiteratureKeywords(Long literatureId, List<Long> keywordIds);
}
