package com.ruoyi.experiment.service;

import com.ruoyi.experiment.pojo.dto.ReviewQueryDTO;
import com.ruoyi.experiment.pojo.entity.Review;
import com.ruoyi.experiment.pojo.vo.ReviewVO;

import java.util.List;

/**
 * 审核Service接口
 */
public interface ReviewService {
    /**
     * 查询审核列表
     * @param review 审核信息
     * @return 审核列表
     */
    List<ReviewVO> listReviews(ReviewQueryDTO reviewQueryDTO);
    
    /**
     * 查询审核详情
     * @param id 审核ID
     * @return 审核信息
     */
    Review getReviewById(Long id);

    /**
     * 审核通过
     * @param id 审核ID
     * @param reviewerRemark 审核人备注
     */
    void approveReview(Long id, String reviewerRemark);
    
    /**
     * 审核不通过
     * @param id 审核ID
     * @param reviewerRemark 审核人备注
     */
    void rejectReview(Long id, String reviewerRemark);
}
