package com.ruoyi.experiment.controller;

import com.ruoyi.experiment.pojo.dto.LiteratureNoteQueryDTO;
import com.ruoyi.experiment.service.NoteService;
import com.ruoyi.framework.web.controller.BaseController;
import com.ruoyi.framework.web.domain.AjaxResult;
import com.ruoyi.framework.web.page.TableDataInfo;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/note")
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
    
    /**
     * 切换心得点赞状态
     */
    @PostMapping("/toggle-like/{noteId}")
    public AjaxResult toggleLike(@PathVariable("noteId") Long noteId) {
        boolean newLikeStatus = noteService.toggleNoteLike(noteId);
        return success(newLikeStatus);
    }
}
