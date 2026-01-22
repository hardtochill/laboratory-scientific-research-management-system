package com.ruoyi.experiment.service;

import com.ruoyi.experiment.pojo.dto.SubmissionProcessDTO;
import com.ruoyi.experiment.pojo.entity.SubmissionProcess;
import com.ruoyi.experiment.pojo.entity.SubmissionProcessFile;
import com.ruoyi.experiment.pojo.vo.SubmissionProcessDetailVO;
import com.ruoyi.experiment.pojo.vo.SubmissionProcessVO;
import com.ruoyi.project.system.domain.vo.UserForSelectVO;

import java.util.List;

/**
 * 投稿流程Service接口
 */
public interface SubmissionProcessService {
    /**
     * 查询投稿计划的所有流程
     * @param planId 投稿计划ID
     * @return 投稿流程列表
     */
    List<SubmissionProcessVO> listSubmissionProcessesByPlanId(Long planId);
    
    /**
     * 创建投稿流程
     * @param submissionProcessDTO 投稿流程信息
     * @return 投稿流程ID
     */
    void createSubmissionProcess(SubmissionProcessDTO submissionProcessDTO);

    /**
     * 更新投稿流程
     * @param submissionProcessDTO 投稿流程信息
     */
    void updateSubmissionProcess(SubmissionProcessDTO submissionProcessDTO);
    
    /**
     * 删除投稿流程
     * @param id 投稿流程ID
     */
    void deleteSubmissionProcess(Long id);
    
    /**
     * 发起内部审核
     * @param processId 投稿流程ID
     * @param reviewedRemark 被审核人备注
     */
    void submitForReview(Long processId, String reviewedRemark);

     /**
     * 查询投稿计划详情
     * @param id 投稿流程ID
     * @return 投稿计划详情
     */
    SubmissionProcessDetailVO getSubmissionProcessDetail(Long id);

    /**
     * 获取审核人用户列表（用于前端用户选择）
     */
    List<UserForSelectVO> listReviewerUsersForSelect(Long planId,String nickName);
}
