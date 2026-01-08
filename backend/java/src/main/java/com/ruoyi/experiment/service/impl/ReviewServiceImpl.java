package com.ruoyi.experiment.service.impl;

import com.ruoyi.experiment.mapper.ReviewMapper;
import com.ruoyi.experiment.service.ReviewService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
@Slf4j
public class ReviewServiceImpl implements ReviewService {
    private final ReviewMapper reviewMapper;
}
