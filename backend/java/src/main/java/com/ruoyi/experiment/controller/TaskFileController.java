package com.ruoyi.experiment.controller;

import com.ruoyi.experiment.service.TaskFileService;
import com.ruoyi.framework.web.controller.BaseController;
import com.ruoyi.framework.web.domain.AjaxResult;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@RestController
@RequestMapping("/taskFile")
@Slf4j
public class TaskFileController extends BaseController {

    @Autowired
    private TaskFileService taskFileService;

    /**
     * 获取任务关联的文件列表
     */
    @GetMapping("/list/{taskId}")
    public AjaxResult getTaskFiles(@PathVariable Long taskId) {
        return AjaxResult.success(taskFileService.getTaskFiles(taskId));
    }

    /**
     * 上传文件
     */
    @PostMapping("/upload/{taskId}")
    public AjaxResult uploadFile(@PathVariable Long taskId, @RequestParam("file") MultipartFile file) {
        taskFileService.uploadFile(taskId, file);
        return AjaxResult.success();
    }

    /**
     * 下载文件
     */
    @PostMapping("/download/{fileId}")
    public void downloadFile(@PathVariable Long fileId, HttpServletResponse response) {
       taskFileService.downloadFile(fileId, response);
    }

    /**
     * 删除文件
     */
    @DeleteMapping("/delete/{fileId}")
    public AjaxResult deleteFile(@PathVariable Long fileId) {
        taskFileService.deleteFile(fileId);
        return AjaxResult.success();
    }
}
