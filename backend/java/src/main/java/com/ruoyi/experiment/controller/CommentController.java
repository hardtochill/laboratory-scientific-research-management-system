package com.ruoyi.experiment.controller;

import com.ruoyi.experiment.service.CommentService;
import com.ruoyi.framework.web.controller.BaseController;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/comment")
@RequiredArgsConstructor
public class CommentController extends BaseController {
    private final CommentService commentService;
}
