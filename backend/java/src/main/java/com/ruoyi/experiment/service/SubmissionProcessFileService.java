package com.ruoyi.experiment.service;

import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;

/**
 * 投稿流程文件Service接口
 */
public interface SubmissionProcessFileService {
    /**
     * 上传投稿流程文件
     * @param processId 投稿流程ID
     * @param file 上传的文件
     * @return 投稿流程文件信息
     */
    void uploadFile(Long processId, MultipartFile file);

    /**
     * 下载文件
     */
    void downloadFile(Long fileId, HttpServletResponse response);

    /**
     * 删除投稿流程文件
     * @param id 投稿流程文件ID
     */
    void deleteFile(Long id);
}
