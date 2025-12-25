package com.ruoyi.experiment.service.impl;

import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.experiment.mapper.NoteMapper;
import com.ruoyi.experiment.pojo.dto.LiteratureNoteQueryDTO;
import com.ruoyi.experiment.pojo.entity.LiteratureNote;
import com.ruoyi.experiment.service.NoteService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class NoteServiceImpl implements NoteService {
    private final NoteMapper noteMapper;
    
    @Override
    public List<LiteratureNote> selectLiteratureNoteList(LiteratureNoteQueryDTO literatureNoteQueryDTO) {
        // 排序字段转化
        if("publishTime".equals(literatureNoteQueryDTO.getSortField())){
            literatureNoteQueryDTO.setSortField("publish_time");
        }else if("likeCount".equals(literatureNoteQueryDTO.getSortField())){
            literatureNoteQueryDTO.setSortField("like_count");
        }else if(null!=literatureNoteQueryDTO.getSortField()){
            throw new ServiceException("排序字段错误");
        }
        return noteMapper.selectLiteratureNoteList(literatureNoteQueryDTO);
    }
}
