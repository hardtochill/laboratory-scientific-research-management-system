package com.ruoyi.experiment.controller;

import com.ruoyi.experiment.service.CommentFileService;
import com.ruoyi.experiment.service.CommentService;
import com.ruoyi.framework.web.controller.BaseController;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/commentFile")
@RequiredArgsConstructor
public class CommentFileController extends BaseController {
    private final CommentFileService commentFileService;
}
