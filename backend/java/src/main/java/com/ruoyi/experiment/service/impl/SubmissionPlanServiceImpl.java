package com.ruoyi.experiment.service.impl;

import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.bean.BeanUtils;
import com.ruoyi.experiment.constant.SubmissionConstants;
import com.ruoyi.experiment.enums.SubmissionPlanStatusEnum;
import com.ruoyi.experiment.enums.SubmissionProcessStatusEnum;
import com.ruoyi.experiment.mapper.SubmissionPlanMapper;
import com.ruoyi.experiment.mapper.SubmissionProcessMapper;
import com.ruoyi.experiment.pojo.dto.SubmissionPlanDTO;
import com.ruoyi.experiment.pojo.dto.SubmissionPlanQueryDTO;
import com.ruoyi.experiment.pojo.entity.SubmissionPlan;
import com.ruoyi.experiment.pojo.entity.SubmissionProcess;
import com.ruoyi.experiment.service.SubmissionPlanService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
@Slf4j
@RequiredArgsConstructor
public class SubmissionPlanServiceImpl implements SubmissionPlanService {
    private final SubmissionPlanMapper submissionPlanMapper;
    private final SubmissionProcessMapper submissionProcessMapper;

    @Override
    public List<SubmissionPlan> listSubmissionPlans(SubmissionPlanQueryDTO submissionPlanQueryDTO) {
        return submissionPlanMapper.selectSubmissionPlanList(submissionPlanQueryDTO);
    }

    @Override
    public SubmissionPlan getSubmissionPlanById(Long id) {
        return submissionPlanMapper.selectById(id);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void createSubmissionPlan(SubmissionPlanDTO submissionPlanDTO) {

        SubmissionPlan submissionPlan = new SubmissionPlan();
        BeanUtils.copyProperties(submissionPlanDTO, submissionPlan);

        // 1.设置用户信息
        submissionPlan.setCreateUserId(SecurityUtils.getUserId());
        submissionPlan.setCreateUserNickName(SecurityUtils.getLoginUser().getUser().getNickName());
        // 2.设置投稿状态
        submissionPlan.setStatus(SubmissionPlanStatusEnum.WAITING_REVIEW.getValue());
        // 3.设置投稿创建时间
        submissionPlan.setSubmissionCreateTime(LocalDateTime.now());
        // 4.保存投稿计划
        submissionPlanMapper.insert(submissionPlan);

        // 5.自动创建第一个投稿流程（一审）
        SubmissionProcess submissionProcess = new SubmissionProcess();
        submissionProcess.setPlanId(submissionPlan.getId());
        submissionProcess.setName(SubmissionConstants.FIRST_PROCESS_NAME);
        submissionProcess.setStatus(SubmissionProcessStatusEnum.WAITING_SUBMIT_REVIEW.getValue());
        submissionProcess.setProcessCreateTime(LocalDateTime.now());
        // 6.保存投稿流程
        submissionProcessMapper.insert(submissionProcess);
    }

    @Override
    public void updateSubmissionPlan(SubmissionPlanDTO submissionPlanDTO) {
        SubmissionPlan submissionPlan = new SubmissionPlan();
        BeanUtils.copyProperties(submissionPlanDTO, submissionPlan);
        submissionPlanMapper.update(submissionPlan);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteSubmissionPlan(Long id) {
        // 删除投稿计划的所有流程
        submissionProcessMapper.deleteByPlanId(id);

        // todo todo 删除投稿流程的关联文件，本地文件+数据库记录

        // 删除投稿计划
        submissionPlanMapper.deleteById(id);
    }
}