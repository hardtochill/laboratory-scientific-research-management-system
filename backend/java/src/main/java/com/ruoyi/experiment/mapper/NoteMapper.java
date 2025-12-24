package com.ruoyi.experiment.mapper;

import com.ruoyi.experiment.pojo.dto.LiteratureNoteQueryDTO;
import com.ruoyi.experiment.pojo.entity.LiteratureNote;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface NoteMapper {
    /**
     * 查询文献心得列表
     */
    List<LiteratureNote> selectLiteratureNoteList(LiteratureNoteQueryDTO literatureNoteQueryDTO);
}
