package com.ruoyi.experiment.controller;

import com.ruoyi.experiment.service.SubmissionProcessFileService;
import com.ruoyi.framework.web.controller.BaseController;
import com.ruoyi.framework.web.domain.AjaxResult;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;

@RestController
@RequestMapping("/submissionProcessFile")
@RequiredArgsConstructor
public class SubmissionProcessFileController extends BaseController {
    private final SubmissionProcessFileService submissionProcessFileService;
    /**
     * 获取流程关联的所有文件
     */
    @GetMapping("/list/{processId}")
    public AjaxResult getSubmissionProcessFiles(@PathVariable Long processId) {
        return success(submissionProcessFileService.getProcessFiles(processId));
    }

    /**
     * 上传投稿流程文件
     */
    @PostMapping("/upload")
    public AjaxResult uploadSubmissionProcessFile(@RequestParam("processId") Long processId, 
                                                @RequestParam("file") MultipartFile file,
                                                @RequestParam("tag") Integer tag) {
        submissionProcessFileService.uploadFile(processId, file, tag);
        return success();
    }
    /**
     * 下载文件
     */
    @PostMapping("/download/{fileId}")
    public void downloadFile(@PathVariable Long fileId, HttpServletResponse response) {
        submissionProcessFileService.downloadFile(fileId, response);
    }

    /**
     * 删除投稿流程文件
     */
    @DeleteMapping("/{id}")
    public AjaxResult deleteSubmissionProcessFile(@PathVariable("id") Long id) {
        submissionProcessFileService.deleteFile(id);
        return success();
    }
}
