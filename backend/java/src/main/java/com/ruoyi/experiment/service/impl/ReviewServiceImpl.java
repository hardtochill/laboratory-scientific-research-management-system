package com.ruoyi.experiment.service.impl;

import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.experiment.enums.RoleEnums;
import com.ruoyi.experiment.enums.SubmissionProcessStatusEnum;
import com.ruoyi.experiment.enums.ReviewStatusEnum;
import com.ruoyi.experiment.enums.UserGraduateFlagEnum;
import com.ruoyi.experiment.mapper.ReviewMapper;
import com.ruoyi.experiment.mapper.SubmissionProcessMapper;
import com.ruoyi.experiment.pojo.dto.ReviewQueryDTO;
import com.ruoyi.experiment.pojo.entity.Review;
import com.ruoyi.experiment.pojo.entity.SubmissionProcess;
import com.ruoyi.experiment.pojo.vo.ReviewVO;
import com.ruoyi.experiment.service.ReviewService;
import com.ruoyi.project.system.domain.dto.UserForSelectQueryDTO;
import com.ruoyi.project.system.domain.vo.UserForSelectVO;
import com.ruoyi.project.system.mapper.SysUserMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
@Slf4j
@RequiredArgsConstructor
public class ReviewServiceImpl implements ReviewService {
    private final ReviewMapper reviewMapper;
    private final SubmissionProcessMapper submissionProcessMapper;
    private final SysUserMapper userMapper;

    @Override
    public List<ReviewVO> listReviews(ReviewQueryDTO reviewQueryDTO) {
        log.info("审核模块-查询审核记录列表：{}",reviewQueryDTO);
        reviewQueryDTO.setReviewerUserId(SecurityUtils.getUserId());
        return reviewMapper.selectReviewVOList(reviewQueryDTO);
    }

    @Override
    public ReviewVO getReviewById(Long id) {
        log.info("审核模块-查询审核记录详情：{}",id);
        return reviewMapper.selectVOById(id);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void approveReview(Long id, String reviewerRemark) {
        log.info("审核模块-通过审核记录：{}",id);
        // 1.只有教师或指定审核人有权限操作
        Review review = reviewMapper.selectById(id);
        if(null==review){
            throw new RuntimeException("审核记录不存在");
        }
        boolean canReview = SecurityUtils.hasRole(RoleEnums.TEACHER.getRoleKey()) || SecurityUtils.getUserId().equals(review.getReviewerUserId());
        if(!canReview){
            throw new RuntimeException("您没有权限操作该审核记录");
        }

        // 2. 更新审核状态为通过
        review.setStatus(ReviewStatusEnum.PASSED.getValue());
        review.setReviewerRemark(reviewerRemark);
        review.setReviewFinishTime(LocalDateTime.now());
        reviewMapper.update(review);
        
        // 3. 更新投稿流程状态为内部审核通过
        SubmissionProcess submissionProcess = submissionProcessMapper.selectByProcessId(review.getProcessId());
        if (submissionProcess == null) {
            throw new RuntimeException("投稿流程不存在");
        }
        submissionProcessMapper.updateStatus(submissionProcess.getId(), SubmissionProcessStatusEnum.REVIEW_PASSED.getValue());
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void rejectReview(Long id, String reviewerRemark) {
        log.info("审核模块-拒绝审核记录：{}",id);
        // 1.只有教师或指定审核人有权限操作
        Review review = reviewMapper.selectById(id);
        if(null==review){
            throw new RuntimeException("审核记录不存在");
        }
        boolean canReview = SecurityUtils.hasRole(RoleEnums.TEACHER.getRoleKey()) || SecurityUtils.getUserId().equals(review.getReviewerUserId());
        if(!canReview){
            throw new RuntimeException("您没有权限操作该审核记录");
        }

        // 2. 更新审核状态为不通过
        review.setStatus(ReviewStatusEnum.FAILED.getValue());
        review.setReviewerRemark(reviewerRemark);
        review.setReviewFinishTime(LocalDateTime.now());
        reviewMapper.update(review);
        
        // 3. 更新投稿流程状态为内部审核不通过
        SubmissionProcess submissionProcess = submissionProcessMapper.selectByProcessId(review.getProcessId());
        if (submissionProcess == null) {
            throw new RuntimeException("投稿流程不存在");
        }
        submissionProcessMapper.updateStatus(submissionProcess.getId(), SubmissionProcessStatusEnum.REVIEW_FAILED.getValue());
    }

    @Override
    public List<UserForSelectVO> listReviewedUsersForSelect(String nickName) {
        UserForSelectQueryDTO queryDTO = new UserForSelectQueryDTO();
        queryDTO.setNickName(nickName);
        queryDTO.setGraduateFlag(UserGraduateFlagEnum.UNGRADUATED.getValue());
        return userMapper.selectVOForSelect(queryDTO);
    }
}