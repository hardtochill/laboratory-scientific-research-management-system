package com.ruoyi.experiment.mapper;

import com.ruoyi.experiment.pojo.dto.LiteratureReadQueryDTO;
import com.ruoyi.experiment.pojo.vo.LiteratureReadVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface LiteratureReadMapper {
    /**
     * 获取文献阅读列表
     */
    List<LiteratureReadVO> selectLiteratureReadList(LiteratureReadQueryDTO queryDTO);
}
