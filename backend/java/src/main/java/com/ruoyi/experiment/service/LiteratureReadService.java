package com.ruoyi.experiment.service;

import com.ruoyi.experiment.pojo.dto.LiteratureReadQueryDTO;
import com.ruoyi.experiment.pojo.vo.LiteratureReadVO;

import java.util.List;

/**
 * 文献阅读服务接口
 */
public interface LiteratureReadService {
    /**
     * 获取文献阅读列表
     */
    List<LiteratureReadVO> list(LiteratureReadQueryDTO queryDTO);
}
