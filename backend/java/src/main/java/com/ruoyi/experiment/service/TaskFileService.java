package com.ruoyi.experiment.service;

import com.ruoyi.framework.web.page.TableDataInfo;
import com.ruoyi.experiment.pojo.entity.TaskFile;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * 任务文件服务接口
 */
public interface TaskFileService {

    /**
     * 获取任务关联的文件列表
     *
     * @param taskId 任务ID
     * @return 文件列表
     */
    List<TaskFile> getTaskFiles(Long taskId);

    /**
     * 上传文件
     *
     * @param taskId 任务ID
     * @param file 上传的文件
     */
    void uploadFile(Long taskId, MultipartFile file);

    /**
     * 下载文件
     *
     * @param fileId 文件ID
     * @return 文件字节数组
     */
    void downloadFile(Long fileId, HttpServletResponse response);

    /**
     * 删除文件
     *
     * @param fileId 文件ID
     * @return 是否成功
     */
    void deleteFile(Long fileId);
}
