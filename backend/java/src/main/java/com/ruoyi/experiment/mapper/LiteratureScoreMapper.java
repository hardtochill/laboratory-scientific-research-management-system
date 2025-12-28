package com.ruoyi.experiment.mapper;

import com.ruoyi.experiment.annotations.AutoFill;
import com.ruoyi.experiment.enums.OperationTypeEnum;
import com.ruoyi.experiment.pojo.dto.LiteratureQueryDTO;
import com.ruoyi.experiment.pojo.entity.Literature;
import com.ruoyi.experiment.pojo.entity.LiteratureScore;
import com.ruoyi.experiment.pojo.vo.KeywordVO;
import com.ruoyi.experiment.pojo.vo.LiteratureDetailVO;
import com.ruoyi.experiment.pojo.vo.LiteratureVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import java.util.List;
import java.util.Map;

@Mapper
public interface LiteratureScoreMapper {
    /**
     * 根据文献id查询用户评分
     */
    @Select("select score from literature_score where literature_id = #{literatureId} and user_id = #{userId}")
    Integer selectUserScore(@Param("literatureId") Long literatureId, @Param("userId") Long userId);


    /**
     * 插入文献评分记录
     */
    @AutoFill(OperationTypeEnum.INSERT)
    void insertLiteratureScore(LiteratureScore literatureScore);
    
    /**
     * 更新文献的评分记录
     */
    @AutoFill(OperationTypeEnum.UPDATE)
    void updateLiteratureScore(LiteratureScore literatureScore);


    /**
     * 查询文献的教师评分统计
     */
    Map<String, Object> selectTeacherScoreStatistics(@Param("literatureId") Long literatureId);
    
    /**
     * 查询文献的学生评分统计
     */
    Map<String, Object> selectStudentScoreStatistics(@Param("literatureId") Long literatureId);
    
}
