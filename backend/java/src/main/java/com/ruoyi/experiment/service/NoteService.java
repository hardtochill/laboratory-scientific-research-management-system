package com.ruoyi.experiment.service;

import com.ruoyi.experiment.pojo.dto.LiteratureNoteQueryDTO;
import com.ruoyi.experiment.pojo.vo.LiteratureNoteVO;

import java.util.List;

/**
 * 文献心得
 */
public interface NoteService {
    /**
     * 查询文献心得列表
     */
    List<LiteratureNoteVO> selectLiteratureNoteList(LiteratureNoteQueryDTO literatureNoteQueryDTO);
    
    /**
     * 切换心得点赞状态
     */
    boolean toggleNoteLike(Long noteId);
}
