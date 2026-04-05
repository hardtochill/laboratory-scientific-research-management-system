package com.ruoyi.experiment.service.impl;

import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.experiment.enums.*;
import com.ruoyi.experiment.mapper.ReviewMapper;
import com.ruoyi.experiment.mapper.SubmissionProcessMapper;
import com.ruoyi.experiment.pojo.dto.DoReviewDTO;
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
        log.info("审核模块-查询审核记录列表：{}", reviewQueryDTO);
        reviewQueryDTO.setReviewerUserId(SecurityUtils.getUserId());
        return reviewMapper.selectReviewVOList(reviewQueryDTO);
    }

    @Override
    public ReviewVO getReviewById(Long id) {
        log.info("审核模块-查询审核记录详情：{}", id);
        return reviewMapper.selectVOById(id);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void doReview(DoReviewDTO doReviewDTO) {
        log.info("审核模块-执行审核：{}", doReviewDTO);
        Long reviewId = doReviewDTO.getReviewId();
        Integer status = doReviewDTO.getStatus();
        String reviewerRemark = doReviewDTO.getReviewerRemark();

        Review review = reviewMapper.selectById(reviewId);
        if (null == review) {
            throw new RuntimeException("审核记录不存在");
        }

        if (!ReviewStatusEnum.PASSED.getValue().equals(status) && !ReviewStatusEnum.FAILED.getValue().equals(status)) {
            throw new RuntimeException("审核状态异常");
        }

        boolean canReview = SecurityUtils.getUserId().equals(review.getReviewerUserId());
        if (!canReview) {
            throw new RuntimeException("您没有权限操作该审核记录");
        }

        if (!ReviewStatusEnum.PENDING.getValue().equals(review.getStatus())) {
            throw new RuntimeException("该审核已处理，无需重复操作");
        }

        if (ReviewTypeEnum.TEACHER.getValue().equals(review.getType())) {
            List<Review> latestReviews = reviewMapper.selectLatestReviewsByProcessId(review.getProcessId());
            Review studentReview = latestReviews.stream()
                    .filter(r -> ReviewTypeEnum.STUDENT.getValue().equals(r.getType()))
                    .findFirst()
                    .orElse(null);
            if (studentReview != null && !ReviewStatusEnum.PASSED.getValue().equals(studentReview.getStatus())) {
                throw new RuntimeException("学生审核未通过，无法进行教师审核");
            }
        }

        review.setStatus(status);
        review.setReviewerRemark(reviewerRemark);
        review.setReviewFinishTime(LocalDateTime.now());
        reviewMapper.update(review);

        updateSubmissionProcessStatus(review.getProcessId());

        if (ReviewTypeEnum.STUDENT.getValue().equals(review.getType()) && ReviewStatusEnum.PASSED.getValue().equals(status)) {
            List<Review> latestReviews = reviewMapper.selectLatestReviewsByProcessId(review.getProcessId());
            Review teacherReview = latestReviews.stream()
                    .filter(r -> ReviewTypeEnum.TEACHER.getValue().equals(r.getType()))
                    .findFirst()
                    .orElse(null);
            if (teacherReview != null) {
                teacherReview.setReviewCreateTime(LocalDateTime.now());
                reviewMapper.update(teacherReview);
            }
        }
    }

    private void updateSubmissionProcessStatus(Long processId) {
        List<Review> latestReviews = reviewMapper.selectLatestReviewsByProcessId(processId);
        if (latestReviews.isEmpty()) {
            return;
        }

        Review studentReview = latestReviews.stream()
                .filter(r -> ReviewTypeEnum.STUDENT.getValue().equals(r.getType()))
                .findFirst()
                .orElse(null);
        Review teacherReview = latestReviews.stream()
                .filter(r -> ReviewTypeEnum.TEACHER.getValue().equals(r.getType()))
                .findFirst()
                .orElse(null);

        Integer newStatus;
        if (studentReview != null && ReviewStatusEnum.FAILED.getValue().equals(studentReview.getStatus())) {
            newStatus = SubmissionProcessStatusEnum.REVIEW_FAILED.getValue();
        } else if (teacherReview != null && ReviewStatusEnum.FAILED.getValue().equals(teacherReview.getStatus())) {
            newStatus = SubmissionProcessStatusEnum.REVIEW_FAILED.getValue();
        } else if (studentReview != null && ReviewStatusEnum.PASSED.getValue().equals(studentReview.getStatus())
                && teacherReview != null && ReviewStatusEnum.PASSED.getValue().equals(teacherReview.getStatus())) {
            newStatus = SubmissionProcessStatusEnum.REVIEW_PASSED.getValue();
        } else {
            newStatus = SubmissionProcessStatusEnum.REVIEWING.getValue();
        }

        submissionProcessMapper.updateStatus(processId, newStatus);
    }

    @Override
    public List<UserForSelectVO> listReviewedUsersForSelect(String nickName) {
        UserForSelectQueryDTO queryDTO = new UserForSelectQueryDTO();
        queryDTO.setNickName(nickName);
        queryDTO.setGraduateFlag(UserGraduateFlagEnum.UNGRADUATED.getValue());
        return userMapper.selectVOForSelect(queryDTO);
    }

    @Override
    public List<UserForSelectVO> listStudentReviewersForSelect(String nickName) {
        UserForSelectQueryDTO queryDTO = new UserForSelectQueryDTO();
        queryDTO.setNickName(nickName);
        queryDTO.setRoleKey(RoleEnums.STUDENT.getRoleKey());
        return userMapper.selectVOForSelect(queryDTO);
    }

    @Override
    public List<UserForSelectVO> listTeacherReviewersForSelect(String nickName) {
        UserForSelectQueryDTO queryDTO = new UserForSelectQueryDTO();
        queryDTO.setNickName(nickName);
        queryDTO.setRoleKey(RoleEnums.TEACHER.getRoleKey());
        return userMapper.selectVOForSelect(queryDTO);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteReview(Long id) {
        log.info("审核模块-删除审核记录：{}", id);
        Review review = reviewMapper.selectById(id);
        if (review == null) {
            throw new RuntimeException("审核记录不存在");
        }

        reviewMapper.deleteById(id);
    }
}
