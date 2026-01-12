package com.ruoyi.experiment.service;

import com.ruoyi.experiment.pojo.dto.SubmissionPlanDTO;
import com.ruoyi.experiment.pojo.dto.SubmissionPlanQueryDTO;
import com.ruoyi.experiment.pojo.entity.SubmissionPlan;
import com.ruoyi.experiment.pojo.entity.SubmissionProcess;
import com.ruoyi.experiment.pojo.vo.SubmissionPlanVO;

import java.util.List;

/**
 * 投稿计划Service接口
 */
public interface SubmissionPlanService {
    /**
     * 查询投稿计划列表
     * @param submissionPlanQueryDTO 投稿计划查询信息
     * @return 投稿计划列表
     */
    List<SubmissionPlan> listSubmissionPlans(SubmissionPlanQueryDTO submissionPlanQueryDTO);
    
    /**
     * 查询投稿计划详情
     * @param id 投稿计划ID
     * @return 投稿计划信息
     */
    SubmissionPlan getSubmissionPlanById(Long id);

    /**
     * 创建投稿计划
     * @param submissionPlanDTO 投稿计划信息
     */
    void createSubmissionPlan(SubmissionPlanDTO submissionPlanDTO);
    
    /**
     * 更新投稿计划
     * @param submissionPlanDTO 投稿计划信息
     */
    void updateSubmissionPlan(SubmissionPlanDTO submissionPlanDTO);
    
    /**
     * 删除投稿计划
     * @param id 投稿计划ID
     */
    void deleteSubmissionPlan(Long id);
    /**
     * 查询投稿计划-用于前端选择
     * @param name 投稿计划名称
     * @return 投稿计划列表
     */
    List<SubmissionPlanVO> listSubmissionPlansForSelect(String name);
}
