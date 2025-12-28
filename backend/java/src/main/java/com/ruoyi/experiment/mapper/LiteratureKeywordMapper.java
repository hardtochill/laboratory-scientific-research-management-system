package com.ruoyi.experiment.mapper;

import com.ruoyi.experiment.pojo.vo.KeywordVO;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface LiteratureKeywordMapper {
    /**
     * 为文献添加关键词关联
     */
    void insertBatch(@Param("literatureId") Long literatureId, @Param("keywordIds") List<Long> keywordIds);

    /**
     * 移除文献的所有关键词关联
     */
    @Delete("delete from literature_keyword where literature_id = #{literatureId}")
    void deleteBatch(Long literatureId);

}
