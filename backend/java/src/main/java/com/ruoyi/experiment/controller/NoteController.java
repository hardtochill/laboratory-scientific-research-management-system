package com.ruoyi.experiment.controller;

import com.ruoyi.experiment.pojo.dto.LiteratureNoteQueryDTO;
import com.ruoyi.experiment.service.NoteService;
import com.ruoyi.framework.web.controller.BaseController;
import com.ruoyi.framework.web.domain.AjaxResult;
import com.ruoyi.framework.web.page.TableDataInfo;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/experiment/note")
@RequiredArgsConstructor
public class NoteController extends BaseController {
    private final NoteService noteService;
    
    /**
     * 查询文献心得列表
     */
    @GetMapping("/list")
    public TableDataInfo list(LiteratureNoteQueryDTO literatureNoteQueryDTO) {
        startPage();
        return getDataTable(noteService.selectLiteratureNoteList(literatureNoteQueryDTO));
    }
}
