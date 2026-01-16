package com.ruoyi.experiment.mapper;

import com.ruoyi.experiment.annotations.AutoFill;
import com.ruoyi.experiment.enums.OperationTypeEnum;
import com.ruoyi.experiment.pojo.dto.SubmissionPlanQueryDTO;
import com.ruoyi.experiment.pojo.entity.SubmissionPlan;
import com.ruoyi.experiment.pojo.vo.SubmissionPlanDetailVO;
import com.ruoyi.experiment.pojo.vo.SubmissionPlanVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

/**
 * 投稿计划Mapper接口
 */
@Mapper
public interface SubmissionPlanMapper {
    /**
     * 查询投稿计划列表
     * @param submissionPlanQueryDTO 投稿计划查询DTO
     * @return 投稿计划列表
     */
    List<SubmissionPlan> selectSubmissionPlanList(SubmissionPlanQueryDTO submissionPlanQueryDTO);
    
    /**
     * 查询投稿计划
     * @param id 投稿计划ID
     * @return 投稿计划信息
     */
    @Select("select * from submission_plan where id = #{id}")
    SubmissionPlanDetailVO selectById(@Param("id") Long id);
    
    /**
     * 新增投稿计划
     * @param submissionPlan 投稿计划信息
     * @return 影响行数
     */
    @AutoFill(OperationTypeEnum.INSERT)
    int insert(SubmissionPlan submissionPlan);
    
    /**
     * 更新投稿计划
     * @param submissionPlan 投稿计划信息
     * @return 影响行数
     */
    @AutoFill(OperationTypeEnum.UPDATE)
    int update(SubmissionPlan submissionPlan);
    
    /**
     * 删除投稿计划
     * @param id 投稿计划ID
     * @return 影响行数
     */
    int deleteById(@Param("id") Long id);
    /**
     * 查询投稿计划-用于前端选择
     * @param name 投稿计划名称
     * @return 投稿计划列表
     */
    List<SubmissionPlanVO> selectVOList(String name,Long participantUserId);
}
