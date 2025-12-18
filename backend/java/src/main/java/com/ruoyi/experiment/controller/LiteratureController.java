package com.ruoyi.experiment.controller;

import com.ruoyi.experiment.service.LiteratureService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/literature")
@RequiredArgsConstructor
public class LiteratureController {
    private final LiteratureService literatureService;
}
