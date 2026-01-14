package com.ruoyi.experiment.controller;

import com.ruoyi.experiment.pojo.dto.LiteratureReadQueryDTO;
import com.ruoyi.experiment.service.LiteratureReadService;
import com.ruoyi.framework.web.controller.BaseController;
import com.ruoyi.framework.web.domain.AjaxResult;
import com.ruoyi.framework.web.page.TableDataInfo;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/literatureRead")
@RequiredArgsConstructor
public class LiteratureReadController extends BaseController {
    private final LiteratureReadService literatureReadService;

    @GetMapping("/list")
    public TableDataInfo list(LiteratureReadQueryDTO literatureReadQueryDTO) {
        startPage();
        return getDataTable(literatureReadService.list(literatureReadQueryDTO));
    }
}
