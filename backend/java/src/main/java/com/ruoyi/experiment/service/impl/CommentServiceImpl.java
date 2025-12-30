package com.ruoyi.experiment.service.impl;

import com.ruoyi.experiment.mapper.CommentMapper;
import com.ruoyi.experiment.service.CommentService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Service
@Slf4j
@RequiredArgsConstructor
public class CommentServiceImpl implements CommentService {
    private final CommentMapper commentMapper;
}
