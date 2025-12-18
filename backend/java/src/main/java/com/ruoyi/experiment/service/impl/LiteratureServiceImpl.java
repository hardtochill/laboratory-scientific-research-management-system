package com.ruoyi.experiment.service.impl;

import com.ruoyi.experiment.mapper.LiteratureMapper;
import com.ruoyi.experiment.service.LiteratureService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class LiteratureServiceImpl implements LiteratureService {
    private final LiteratureMapper literatureMapper;
}
