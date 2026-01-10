package com.ruoyi.experiment.controller;

import com.ruoyi.experiment.pojo.dto.ReviewQueryDTO;
import com.ruoyi.experiment.pojo.entity.Review;
import com.ruoyi.experiment.pojo.vo.ReviewVO;
import com.ruoyi.experiment.service.ReviewService;
import com.ruoyi.framework.web.controller.BaseController;
import com.ruoyi.framework.web.domain.AjaxResult;
import com.ruoyi.framework.web.page.TableDataInfo;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/review")
@RequiredArgsConstructor
public class ReviewController extends BaseController {
    private final ReviewService reviewService;

    /**
     * 查询审核列表
     */
    @GetMapping("/list")
    public TableDataInfo listReviews(ReviewQueryDTO reviewQueryDTO) {
        startPage();
        List<ReviewVO> list = reviewService.listReviews(reviewQueryDTO);
        return getDataTable(list);
    }

    /**
     * 查询审核详情
     */
    @GetMapping("/{id}")
    public AjaxResult getReviewById(@PathVariable("id") Long id) {
        return success(reviewService.getReviewById(id));
    }

    /**
     * 审核通过
     */
    @PostMapping("/approve/{id}")
    public AjaxResult approveReview(@PathVariable("id") Long id, @RequestParam(value = "reviewerRemark", required = false) String reviewerRemark) {
        reviewService.approveReview(id, reviewerRemark);
        return success();
    }

    /**
     * 审核不通过
     */
    @PostMapping("/reject/{id}")
    public AjaxResult rejectReview(@PathVariable("id") Long id, @RequestParam(value = "reviewerRemark", required = false) String reviewerRemark) {
        reviewService.rejectReview(id, reviewerRemark);
        return success();
    }
}
