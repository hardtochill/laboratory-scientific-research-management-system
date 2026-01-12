package com.ruoyi.experiment.controller;

import com.ruoyi.experiment.pojo.dto.SubmissionPlanDTO;
import com.ruoyi.experiment.pojo.dto.SubmissionPlanQueryDTO;
import com.ruoyi.experiment.pojo.entity.SubmissionPlan;
import com.ruoyi.experiment.pojo.vo.SubmissionPlanVO;
import com.ruoyi.experiment.service.SubmissionPlanService;
import com.ruoyi.framework.web.controller.BaseController;
import com.ruoyi.framework.web.domain.AjaxResult;
import com.ruoyi.framework.web.page.TableDataInfo;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/submissionPlan")
@RequiredArgsConstructor
public class SubmissionPlanController extends BaseController {
    private final SubmissionPlanService submissionPlanService;

    /**
     * 查询投稿计划列表
     */
    @GetMapping("/list")
    public TableDataInfo listSubmissionPlans(SubmissionPlanQueryDTO submissionPlanQueryDTO) {
        startPage();
        List<SubmissionPlan> list = submissionPlanService.listSubmissionPlans(submissionPlanQueryDTO);
        return getDataTable(list);
    }
    /**
     * 查询投稿计划-用于前端选择
     */
    @GetMapping("/listForSelect")
    public AjaxResult listSubmissionPlansForSelect(String name) {
        return success(submissionPlanService.listSubmissionPlansForSelect(name));
    }

    /**
     * 创建投稿计划
     */
    @PostMapping("/add")
    public AjaxResult createSubmissionPlan(@RequestBody SubmissionPlanDTO submissionPlanDTO) {
        submissionPlanService.createSubmissionPlan(submissionPlanDTO);
        return success();
    }

    /**
     * 更新投稿计划
     */
    @PostMapping("/update")
    public AjaxResult updateSubmissionPlan(@RequestBody SubmissionPlanDTO submissionPlanDTO) {
        submissionPlanService.updateSubmissionPlan(submissionPlanDTO);
        return success();
    }


    /**
     * 查询投稿计划详情
     */
    @GetMapping("/{id}")
    public AjaxResult getSubmissionPlanById(@PathVariable("id") Long id) {
        return success(submissionPlanService.getSubmissionPlanById(id));
    }

    /**
     * 删除投稿计划
     */
    @DeleteMapping("/{id}")
    public AjaxResult deleteSubmissionPlan(@PathVariable("id") Long id) {
        submissionPlanService.deleteSubmissionPlan(id);
        return success();
    }
}
