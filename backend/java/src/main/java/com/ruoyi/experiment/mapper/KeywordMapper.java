package com.ruoyi.experiment.mapper;

import com.ruoyi.experiment.annotations.AutoFill;
import com.ruoyi.experiment.enums.OperationTypeEnum;
import com.ruoyi.experiment.pojo.dto.KeywordDTO;
import com.ruoyi.experiment.pojo.dto.KeywordQueryDTO;
import com.ruoyi.experiment.pojo.entity.Keyword;
import com.ruoyi.experiment.pojo.vo.KeywordVO;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 关键词数据访问层
 */
@Mapper
public interface KeywordMapper {

    /**
     * 根据查询条件分页查询关键词列表
     * @param keywordQueryDTO 查询条件
     * @return 关键词列表
     */
    List<Keyword> selectKeywordList(KeywordQueryDTO keywordQueryDTO);

    /**
     * 根据关键词ID查询关键词
     * @param keywordId 关键词ID
     * @return 关键词信息
     */
    @Select("select * from keyword where id = #{keywordId}")
    Keyword selectById(Long keywordId);

     /**
     * 根据关键词名称查询关键词
     * @param keywordName 关键词名称
     * @return 关键词信息
     */
    @Select("select * from keyword where keyword_name = #{keywordName}")
    Keyword selectByKeywordName(String keywordName);
    /**
     * 新增关键词
     * @param keyword 关键词信息
     */
    @AutoFill(OperationTypeEnum.INSERT)
    void insertKeyword(Keyword keyword);

    /**
     * 修改关键词
     * @param keyword 关键词信息
     */
    @AutoFill(OperationTypeEnum.UPDATE)
    void updateKeyword(Keyword keyword);

    /**
     * 删除关键词
     * @param keywordId 关键词ID
     */
    @Delete("delete from keyword where id = #{keywordId}")
    void deleteKeyword(Long keywordId);
    /**
     * 批量更新关键词使用次数
     * @param keywordIds 关键词ID列表
     * @param value 增量值
     */
    void updateUsageCountBatch(@Param("keywordIds") List<Long> keywordIds, @Param("value") int value);

    /**
     * 根据文献id查询关键词列表
     */
    List<KeywordVO> selectKeywordsByLiteratureId(@Param("literatureId") Long literatureId);
}
