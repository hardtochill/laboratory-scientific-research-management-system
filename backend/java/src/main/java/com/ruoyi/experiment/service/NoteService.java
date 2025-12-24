package com.ruoyi.experiment.service;

import com.ruoyi.experiment.pojo.dto.LiteratureNoteQueryDTO;
import com.ruoyi.experiment.pojo.entity.LiteratureNote;

import java.util.List;

/**
 * 文献心得
 */
public interface NoteService {
    /**
     * 查询文献心得列表
     */
    List<LiteratureNote> selectLiteratureNoteList(LiteratureNoteQueryDTO literatureNoteQueryDTO);
}
