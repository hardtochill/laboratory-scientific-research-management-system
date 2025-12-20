package com.ruoyi.experiment.mapper;

import com.ruoyi.experiment.annotations.AutoFill;
import com.ruoyi.experiment.enums.OperationTypeEnum;
import com.ruoyi.experiment.pojo.dto.LiteratureQueryDTO;
import com.ruoyi.experiment.pojo.entity.Literature;
import com.ruoyi.experiment.pojo.entity.LiteratureScore;
import com.ruoyi.experiment.pojo.vo.LiteratureVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;
import java.util.Map;

@Mapper
public interface LiteratureMapper {
    /**
     * 根据查询条件查询文献列表
     */
    List<LiteratureVO> selectLiteratureList(@Param("queryDTO") LiteratureQueryDTO queryDTO);
    
    /**
     * 根据文献id查询文献详情
     */
    @Select("select * from literature where id = #{id}")
    Literature selectLiteratureById(@Param("id") Long id);
    
    /**
     * 更新文献的下载数
     */
    void updateDownloadCount(@Param("id") Long id);
    
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
     * 查询用户对某文献的评分记录
     */
    @Select("select * from literature_score where literature_id = #{literatureId} and user_id = #{userId}")
    LiteratureScore selectLiteratureScore(@Param("literatureId") Long literatureId, @Param("userId") Long userId);
    
    /**
     * 更新文献的教师评分均值和数量
     */
    void updateTeacherScore(@Param("literatureId") Long literatureId, @Param("avgScore") Double avgScore, @Param("count") Integer count);
    
    /**
     * 更新文献的学生评分均值和数量
     */
    void updateStudentScore(@Param("literatureId") Long literatureId, @Param("avgScore") Double avgScore, @Param("count") Integer count);
    
    /**
     * 更新文献的最终得分
     */
    void updateFinalScore(@Param("literatureId") Long literatureId, @Param("finalScore") Double finalScore);
    
    /**
     * 查询系统内所有文献的最大下载数
     */
    Integer selectMaxDownloadCount();
    
    /**
     * 根据文献id列表查询文献信息
     */
    List<Literature> selectLiteratureByIds(@Param("ids") List<Long> ids);
    
    /**
     * 查询文献的教师评分统计
     */
    Map<String, Object> selectTeacherScoreStatistics(@Param("literatureId") Long literatureId);
    
    /**
     * 查询文献的学生评分统计
     */
    Map<String, Object> selectStudentScoreStatistics(@Param("literatureId") Long literatureId);
}
