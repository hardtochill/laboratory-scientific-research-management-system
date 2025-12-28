package com.ruoyi.experiment.service.impl;

import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.experiment.mapper.KeywordMapper;
import com.ruoyi.experiment.mapper.NoteMapper;
import com.ruoyi.experiment.pojo.dto.LiteratureNoteQueryDTO;
import com.ruoyi.experiment.pojo.entity.LiteratureNote;
import com.ruoyi.experiment.pojo.vo.LiteratureNoteVO;
import com.ruoyi.experiment.service.KeywordService;
import com.ruoyi.experiment.service.NoteService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class KeywordServiceImpl implements KeywordService {
    private final KeywordMapper keywordMapper;

}
