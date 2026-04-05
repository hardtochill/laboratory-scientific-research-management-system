package com.ruoyi.experiment.controller;

import com.ruoyi.experiment.pojo.dto.DoReviewDTO;
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
     * 获取可选申请人用户列表（用于前端用户选择）
     */
    @GetMapping("/listReviewedUsersForSelect")
    public AjaxResult listReviewedUsersForSelect(String nickName) {
        return AjaxResult.success(reviewService.listReviewedUsersForSelect(nickName));
    }

    /**
     * 获取学生审核人列表（用于前端用户选择）
     */
    @GetMapping("/listStudentReviewersForSelect")
    public AjaxResult listStudentReviewersForSelect(String nickName) {
        return AjaxResult.success(reviewService.listStudentReviewersForSelect(nickName));
    }

    /**
     * 获取教师审核人列表（用于前端用户选择）
     */
    @GetMapping("/listTeacherReviewersForSelect")
    public AjaxResult listTeacherReviewersForSelect(String nickName) {
        return AjaxResult.success(reviewService.listTeacherReviewersForSelect(nickName));
    }

    /**
     * 查询审核详情
     */
    @GetMapping("/{id}")
    public AjaxResult getReviewById(@PathVariable("id") Long id) {
        return success(reviewService.getReviewById(id));
    }

    /**
     * 执行审核
     */
    @PostMapping("/doReview")
    public AjaxResult doReview(@RequestBody DoReviewDTO doReviewDTO) {
        reviewService.doReview(doReviewDTO);
        return success();
    }

    /**
     * 删除审核记录
     */
    @DeleteMapping("/{id}")
    public AjaxResult deleteReview(@PathVariable("id") Long id) {
        reviewService.deleteReview(id);
        return success("删除成功");
    }
}
