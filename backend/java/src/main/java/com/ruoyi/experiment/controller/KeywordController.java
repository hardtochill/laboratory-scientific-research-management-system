package com.ruoyi.experiment.controller;

import com.ruoyi.experiment.pojo.dto.KeywordDTO;
import com.ruoyi.experiment.pojo.dto.KeywordQueryDTO;
import com.ruoyi.experiment.service.KeywordService;
import com.ruoyi.framework.web.controller.BaseController;
import com.ruoyi.framework.web.domain.AjaxResult;
import com.ruoyi.framework.web.page.TableDataInfo;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/keyword")
@RequiredArgsConstructor
public class KeywordController extends BaseController {
    private final KeywordService keywordService;

    /**
     * 根据关键词查询条件分页查询关键词列表
     */
    @GetMapping("/list")
    public TableDataInfo list(KeywordQueryDTO keywordQueryDTO) {
        startPage();
        return getDataTable(keywordService.selectKeywordList(keywordQueryDTO));
    }

    /**
     * 新增关键词
     */
    @PostMapping("/add")
    public AjaxResult addKeyword(@RequestBody KeywordDTO keywordDTO) {
        keywordService.addKeyword(keywordDTO);
        return AjaxResult.success("新增成功");
    }

    /**
     * 修改关键词
     */
    @PostMapping("/update")
    public AjaxResult updateKeyword(@RequestBody @Validated KeywordDTO keywordDTO) {
        keywordService.updateKeyword(keywordDTO);
        return AjaxResult.success("修改成功");
    }

    /**
     * 删除关键词
     */
    @PostMapping("/delete/{keywordId}")
    public AjaxResult deleteKeyword(@PathVariable Long keywordId) {
        keywordService.deleteKeyword(keywordId);
        return AjaxResult.success("删除成功");
    }
}
