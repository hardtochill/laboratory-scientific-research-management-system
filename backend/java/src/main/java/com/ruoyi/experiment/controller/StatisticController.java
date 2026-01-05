package com.ruoyi.experiment.controller;

import com.ruoyi.experiment.pojo.dto.KeywordDTO;
import com.ruoyi.experiment.pojo.dto.KeywordQueryDTO;
import com.ruoyi.experiment.service.KeywordService;
import com.ruoyi.experiment.service.StatisticService;
import com.ruoyi.framework.web.controller.BaseController;
import com.ruoyi.framework.web.domain.AjaxResult;
import com.ruoyi.framework.web.page.TableDataInfo;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/statistic")
@RequiredArgsConstructor
public class StatisticController extends BaseController {
    private final StatisticService statisticService;



}
