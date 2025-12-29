package com.ruoyi.experiment.mapper;

import com.ruoyi.experiment.pojo.vo.KeywordVO;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

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

    /**
     * 查询文献的所有关键词
     */
    @Select("select keyword_id from literature_keyword where literature_id = #{literatureId}")
    List<Long> selectKeywordIdsByLiteratureId(Long literatureId);

     /**
     * 根据关键词ID删除文献关键词关联
     */
    void deleteByKeywordIds(Long[] keywordIds);
}
