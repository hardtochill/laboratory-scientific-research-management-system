package com.ruoyi.experiment.controller;

import com.ruoyi.experiment.service.TaskReportFileService;
import com.ruoyi.framework.web.controller.BaseController;
import com.ruoyi.framework.web.domain.AjaxResult;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;

@RestController
@RequestMapping("/taskReportFile")
@RequiredArgsConstructor
public class TaskReportFileController extends BaseController {
    private final TaskReportFileService taskReportFileService;

    /**
     * 获取任务汇报关联的文件列表
     */
    @GetMapping("/list/{taskReportId}")
    public AjaxResult getTaskReportFiles(@PathVariable Long taskReportId) {
        return AjaxResult.success(taskReportFileService.getTaskReportFiles(taskReportId));
    }

    /**
     * 上传文件
     */
    @PostMapping("/upload/{taskReportId}")
    public AjaxResult uploadFile(@PathVariable Long taskReportId, @RequestParam("file") MultipartFile file) {
        taskReportFileService.uploadFile(taskReportId, file);
        return AjaxResult.success();
    }

    /**
     * 下载文件
     */
    @GetMapping("/download/{fileId}")
    public void downloadFile(@PathVariable Long fileId, HttpServletResponse response) {
        taskReportFileService.downloadFile(fileId, response);
    }

    /**
     * 删除文件
     */
    @DeleteMapping("/delete/{fileId}")
    public AjaxResult deleteFile(@PathVariable Long fileId) {
        taskReportFileService.deleteFile(fileId);
        return AjaxResult.success();
    }
}
