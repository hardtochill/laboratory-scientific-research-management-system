package com.ruoyi.experiment.mapper;

import com.ruoyi.experiment.annotations.AutoFill;
import com.ruoyi.experiment.enums.OperationTypeEnum;
import com.ruoyi.experiment.pojo.entity.Review;
import com.ruoyi.experiment.pojo.vo.ReviewVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

/**
 * 审核Mapper接口
 */
@Mapper
public interface ReviewMapper {
    /**
     * 查询审核列表
     * @param review 审核信息
     * @return 审核列表
     */
    List<ReviewVO> selectReviewList(Review review);
    
    /**
     * 查询审核
     * @param id 审核ID
     * @return 审核信息
     */
    @Select("select * from review where id = #{id}")
    Review selectById(@Param("id") Long id);

    /**
     * 新增审核
     * @param review 审核信息
     * @return 影响行数
     */
    @AutoFill(OperationTypeEnum.INSERT)
    int insert(Review review);
    
    /**
     * 更新审核
     * @param review 审核信息
     * @return 影响行数
     */
    @AutoFill(OperationTypeEnum.UPDATE)
    int update(Review review);
    
    /**
     * 删除审核
     * @param id 审核ID
     * @return 影响行数
     */
    int deleteReviewById(@Param("id") Long id);
    
    /**
     * 删除投稿流程的审核记录
     * @param processId 投稿流程ID
     * @return 影响行数
     */
    int deleteReviewByProcessId(@Param("processId") Long processId);
}
