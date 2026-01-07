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
public interface LiteratureMapper {
    /**
     * 根据查询条件查询文献列表
     */
    List<LiteratureVO> selectLiteratureList(@Param("queryDTO") LiteratureQueryDTO queryDTO);
    
    /**
     * 根据文献id查询文献详情
     */
    LiteratureDetailVO selectLiteratureDetail(@Param("id") Long id);
    
    /**
     * 根据文献id查询文献对象
     */
    @Select("select * from literature where id = #{id}")
    Literature selectLiteratureById(@Param("id") Long id);
    
    /**
     * 更新文献的下载数
     */
    @Update("update literature set download_count = download_count + 1 where id = #{id}")
    void updateDownloadCount(@Param("id") Long id);

    
    /**
     * 查询用户对某文献的评分记录
     */
    @Select("select * from literature_score where literature_id = #{literatureId} and user_id = #{userId}")
    LiteratureScore selectLiteratureScore(Long literatureId, Long userId);
    
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
     * 根据文献id查询文献标识符
     */
    @Select("select identifier from literature where identifier = #{identifier}")
    String selectIdentifier(String identifier);
     /**
     * 插入文献
     */
    @AutoFill(OperationTypeEnum.INSERT)
    void insertLiterature(Literature literature);
    /**
     * 更新文献
     */
    @AutoFill(OperationTypeEnum.UPDATE)
    void updateLiterature(Literature literature);
     /**
     * 查询可选择的文献列表（用于前端文献选择）
     */
    List<LiteratureVO> selectSelectableLiteratures(String literatureTitle);
}
