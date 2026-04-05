package com.ruoyi.experiment.service;

import com.ruoyi.experiment.pojo.dto.DoReviewDTO;
import com.ruoyi.experiment.pojo.dto.ReviewQueryDTO;
import com.ruoyi.experiment.pojo.entity.Review;
import com.ruoyi.experiment.pojo.vo.ReviewVO;
import com.ruoyi.project.system.domain.vo.UserForSelectVO;

import java.util.List;

/**
 * 审核Service接口
 */
public interface ReviewService {
    /**
     * 查询审核列表
     * @param reviewQueryDTO 审核信息
     * @return 审核列表
     */
    List<ReviewVO> listReviews(ReviewQueryDTO reviewQueryDTO);

    /**
     * 查询审核详情
     * @param id 审核ID
     * @return 审核信息
     */
    ReviewVO getReviewById(Long id);

    /**
     * 执行审核
     * @param doReviewDTO 审核信息
     */
    void doReview(DoReviewDTO doReviewDTO);

    /**
     * 删除审核记录
     * @param id 审核ID
     */
    void deleteReview(Long id);

    /**
     * 获取用户列表（用于前端用户选择）
     */
    List<UserForSelectVO> listReviewedUsersForSelect(String nickName);

    /**
     * 获取学生用户列表（用于前端用户选择）
     */
    List<UserForSelectVO> listStudentReviewersForSelect(String nickName);

    /**
     * 获取教师用户列表（用于前端用户选择）
     */
    List<UserForSelectVO> listTeacherReviewersForSelect(String nickName);
}
