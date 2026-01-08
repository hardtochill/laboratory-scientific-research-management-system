package com.ruoyi.experiment.controller;

import com.ruoyi.experiment.service.ReviewService;
import com.ruoyi.experiment.service.SubmissionPlanService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/review")
@RequiredArgsConstructor
public class ReviewController {
    private final ReviewService reviewService;
}
