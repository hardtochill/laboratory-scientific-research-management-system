package com.ruoyi.experiment.service;

import com.ruoyi.experiment.pojo.entity.CommentFile;
import com.ruoyi.experiment.pojo.vo.CommentFileVO;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * 文献评论接口
 */
public interface CommentFileService {
    /**
     * 获取评论关联的文件列表
     */
    List<CommentFileVO> getCommentFiles(Long commentId);

    /**
     * 上传文件
     */
    void uploadFile(Long commentId, MultipartFile file);

    /**
     * 下载文件
     */
    void downloadFile(Long fileId, HttpServletResponse response);

     /**
      * 删除文件
      */
    void deleteFile(Long fileId);

}
