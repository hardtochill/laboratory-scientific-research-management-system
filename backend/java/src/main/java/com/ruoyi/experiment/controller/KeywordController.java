package com.ruoyi.experiment.controller;

import com.ruoyi.experiment.pojo.dto.LiteratureNoteQueryDTO;
import com.ruoyi.experiment.service.KeywordService;
import com.ruoyi.experiment.service.NoteService;
import com.ruoyi.framework.web.controller.BaseController;
import com.ruoyi.framework.web.domain.AjaxResult;
import com.ruoyi.framework.web.page.TableDataInfo;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/keyword")
@RequiredArgsConstructor
public class KeywordController extends BaseController {
    private final KeywordService keywordService;

}
