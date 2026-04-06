package com.ruoyi.experiment.service;

import com.ruoyi.experiment.pojo.vo.TaskReportFileVO;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * 任务汇报文件服务接口
 */
public interface TaskReportFileService {
    /**
     * 获取任务汇报关联的文件列表
     */
    List<TaskReportFileVO> getTaskReportFiles(Long taskReportId);

    /**
     * 上传文件
     */
    void uploadFile(Long taskReportId, MultipartFile file);

    /**
     * 下载文件
     */
    void downloadFile(Long fileId, HttpServletResponse response);

    /**
     * 删除文件
     */
    void deleteFile(Long fileId);

    /**
     * 批量上传文件
     */
    void uploadFiles(Long taskReportId, List<MultipartFile> files);
}
