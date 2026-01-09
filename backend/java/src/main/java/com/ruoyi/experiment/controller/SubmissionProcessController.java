package com.ruoyi.experiment.controller;

import com.ruoyi.experiment.pojo.dto.SubmissionProcessDTO;
import com.ruoyi.experiment.pojo.entity.SubmissionProcess;
import com.ruoyi.experiment.pojo.vo.SubmissionProcessVO;
import com.ruoyi.experiment.service.SubmissionProcessService;
import com.ruoyi.framework.web.controller.BaseController;
import com.ruoyi.framework.web.domain.AjaxResult;
import com.ruoyi.framework.web.page.TableDataInfo;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/submissionProcess")
@RequiredArgsConstructor
public class SubmissionProcessController extends BaseController {
    private final SubmissionProcessService submissionProcessService;

    /**
     * 查询投稿计划的所有流程
     */
    @GetMapping("/plan/{planId}")
    public TableDataInfo listSubmissionProcessesByPlanId(@PathVariable("planId") Long planId) {
        startPage();
        List<SubmissionProcessVO> list = submissionProcessService.listSubmissionProcessesByPlanId(planId);
        return getDataTable(list);
    }

    /**
     * 创建投稿流程
     */
    @PostMapping("/add")
    public AjaxResult createSubmissionProcess(@RequestBody SubmissionProcessDTO submissionProcessDTO) {
       submissionProcessService.createSubmissionProcess(submissionProcessDTO);
        return success();
    }

    /**
     * 更新投稿流程
     */
    @PostMapping("/update")
    public AjaxResult updateSubmissionProcess(@RequestBody SubmissionProcessDTO submissionProcessDTO) {
        submissionProcessService.updateSubmissionProcess(submissionProcessDTO);
        return success();
    }

    /**
     * 删除投稿流程
     */
    @DeleteMapping("/{id}")
    public AjaxResult deleteSubmissionProcess(@PathVariable("id") Long id) {
        submissionProcessService.deleteSubmissionProcess(id);
        return success();
    }

    /**
     * 发起内部审核
     */
    @PostMapping("/submitReview")
    public AjaxResult submitForReview(@RequestParam("processId") Long processId, 
                                     @RequestParam(value = "reviewedRemark", required = false) String reviewedRemark) {
        submissionProcessService.submitForReview(processId, reviewedRemark);
        return success();
    }
}
