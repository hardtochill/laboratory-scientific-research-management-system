package com.ruoyi.experiment.mapper;

import com.ruoyi.experiment.annotations.AutoFill;
import com.ruoyi.experiment.enums.OperationTypeEnum;
import com.ruoyi.experiment.pojo.entity.SubmissionProcess;
import com.ruoyi.experiment.pojo.vo.SubmissionProcessVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import java.util.List;

/**
 * 投稿流程Mapper接口
 */
@Mapper
public interface SubmissionProcessMapper {
    /**
     * 根据id查
     */
     @Select("select * from submission_process where id = #{id}")
     SubmissionProcess selectByProcessId(@Param("id") Long id);

    /**
     * 查询投稿计划的所有流程
     * @param planId 投稿计划ID
     * @return 投稿流程列表
     */
    @Select("select * from submission_process where plan_id = #{planId} order by create_time asc")
    List<SubmissionProcessVO> selectByPlanId(@Param("planId") Long planId);
    
    /**
     * 新增投稿流程
     * @param submissionProcess 投稿流程信息
     * @return 影响行数
     */
    @AutoFill(OperationTypeEnum.INSERT)
    void insert(SubmissionProcess submissionProcess);
    
    /**
     * 更新投稿流程
     * @param submissionProcess 投稿流程信息
     * @return 影响行数
     */
    @AutoFill(OperationTypeEnum.UPDATE)
    void update(SubmissionProcess submissionProcess);
    
    /**
     * 删除投稿流程
     * @param id 投稿流程ID
     * @return 影响行数
     */
    int deleteByProcessId(@Param("id") Long id);
    
    /**
     * 删除投稿计划的所有流程
     * @param planId 投稿计划ID
     * @return 影响行数
     */
    int deleteByPlanId(@Param("planId") Long planId);

    /**
     * 更新投稿流程状态
     */
    @Update("update submission_process set status = #{status} where id = #{id}")
    void updateStatus(@Param("id") Long id, @Param("status") Integer status);
}
