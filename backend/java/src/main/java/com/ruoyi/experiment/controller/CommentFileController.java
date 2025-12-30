package com.ruoyi.experiment.controller;

import com.ruoyi.experiment.service.CommentFileService;
import com.ruoyi.framework.web.controller.BaseController;
import com.ruoyi.framework.web.domain.AjaxResult;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;

@RestController
@RequestMapping("/commentFile")
@RequiredArgsConstructor
public class CommentFileController extends BaseController {
    private final CommentFileService commentFileService;

    /**
     * 获取评论关联的文件列表
     */
    @GetMapping("/list/{commentId}")
    public AjaxResult getCommentFiles(@PathVariable Long commentId) {
        return AjaxResult.success(commentFileService.getCommentFiles(commentId));
    }

    /**
     * 上传文件
     */
    @PostMapping("/upload/{commentId}")
    public AjaxResult uploadFile(@PathVariable Long commentId, @RequestParam("file") MultipartFile file) {
        commentFileService.uploadFile(commentId, file);
        return AjaxResult.success();
    }
    /**
     * 下载文件
     */
    @PostMapping("/download/{fileId}")
    public void downloadFile(@PathVariable Long fileId, HttpServletResponse response) {
        commentFileService.downloadFile(fileId, response);
    }
    /**
     * 删除文件
     */
    @DeleteMapping("/delete/{fileId}")
    public AjaxResult deleteFile(@PathVariable Long fileId) {
        commentFileService.deleteFile(fileId);
        return AjaxResult.success();
    }
}
