package com.ruoyi.experiment.controller;


import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.file.FileUtils;
import com.ruoyi.experiment.pojo.dto.LiteratureQueryDTO;
import com.ruoyi.experiment.pojo.dto.LiteratureScoreDTO;
import com.ruoyi.experiment.pojo.entity.Literature;
import com.ruoyi.experiment.pojo.vo.LiteratureVO;
import com.ruoyi.experiment.service.LiteratureService;
import com.ruoyi.framework.web.controller.BaseController;
import com.ruoyi.framework.web.domain.AjaxResult;
import com.ruoyi.framework.web.page.TableDataInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import javax.servlet.http.HttpServletResponse;

import java.util.List;

/**
 * 文献管理Controller
 *
 * @author ruoyi
 * @date 2023-10-15
 */
@RestController
@RequestMapping("/experiment/literature")
public class LiteratureController extends BaseController {
    @Autowired
    private LiteratureService literatureService;
    
    /**
     * 查询文献列表
     */
    @GetMapping("/list")
    public TableDataInfo list(LiteratureQueryDTO literatureQueryDTO) {
        startPage();
        List<LiteratureVO> list = literatureService.selectLiteratureList(literatureQueryDTO);
        return getDataTable(list);
    }

    /**
     * 获取文献详情
     */
    @GetMapping("/detail/{id}")
    public AjaxResult detail(@PathVariable("id") Long id) {
        return AjaxResult.success(literatureService.selectLiteratureDetail(id));
    }

    /**
     * 下载文献
     */
    @PostMapping("/download/{id}")
    public void download(@PathVariable("id") Long id, HttpServletResponse response){
        literatureService.downloadLiterature(id,response);
    }

    /**
     * 评分文献
     */
    @PostMapping("/score")
    public AjaxResult score(@RequestBody LiteratureScoreDTO literatureScoreDTO) {
        literatureService.scoreLiterature(literatureScoreDTO);
        return AjaxResult.success("评分成功");
    }

    /**
     * 获取用户对文献的评分
     */
    @GetMapping("/getUserScore/{literatureId}")
    public AjaxResult getUserScore(@PathVariable("literatureId") Long literatureId) {
        Long userId = SecurityUtils.getUserId();
        Integer score = literatureService.getUserLiteratureScore(literatureId, userId);
        return AjaxResult.success(score);
    }
}