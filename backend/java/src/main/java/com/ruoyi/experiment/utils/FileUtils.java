package com.ruoyi.experiment.utils;

import com.ruoyi.common.exception.file.FileNameLengthLimitExceededException;
import com.ruoyi.common.utils.file.FileUploadUtils;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.nio.file.Paths;
import java.util.Objects;

public class FileUtils {
    // 任务文件允许的扩展名 - null表示不限制
    public static final String[] TASK_ALLOWED_EXTENSION = null;

    // 文献文件允许的扩展名 - null表示不限制
    public static final String[] LITERATURE_ALLOWED_EXTENSION = null;
    //评论文件允许的扩展名 - null表示不限制
    public static final String[] Comment_ALLOWED_EXTENSION = null;
    
    // 投稿文件允许的扩展名 - null表示不限制
    public static final String[] SUBMISSION_ALLOWED_EXTENSION = null;
    // 任务汇报文件允许的扩展名 - null表示不限制
    public static final String[] TASK_REPORT_ALLOWED_EXTENSION = null;
    /**
     * 上传任务文件
     */
    public static final String uploadTaskFile(String taskBaseDir,MultipartFile file) throws Exception{
        return uploadFile(taskBaseDir,file,TASK_ALLOWED_EXTENSION);
    }
    /**
     * 上传文献文件
     */
    public static String uploadLiteratureFile(String literatureBaseDir, MultipartFile file) throws Exception{
        return uploadFile(literatureBaseDir,file,LITERATURE_ALLOWED_EXTENSION);
    }
    /**
     * 上传评论文件
     */
    public static String uploadCommentFile(String commentBaseDir, MultipartFile file) throws Exception{
        return uploadFile(commentBaseDir,file,Comment_ALLOWED_EXTENSION);
    }
    
    /**
     * 上传投稿文件
     */
    public static String uploadSubmissionFile(String submissionBaseDir, MultipartFile file) throws Exception{
        return uploadFile(submissionBaseDir,file,SUBMISSION_ALLOWED_EXTENSION);
    }
    
    /**
     * 上传任务汇报文件
     */
    public static String uploadTaskReportFile(String taskReportBaseDir, MultipartFile file) throws Exception{
        return uploadFile(taskReportBaseDir,file,TASK_REPORT_ALLOWED_EXTENSION);
    }
    public static String uploadFile(String baseDir, MultipartFile file,String[] allowedExtension) throws Exception{
        // 文件名称长度校验
        int fileNameLength = Objects.requireNonNull(file.getOriginalFilename()).length();
        if (fileNameLength > FileUploadUtils.DEFAULT_FILE_NAME_LENGTH) {
            throw new FileNameLengthLimitExceededException(FileUploadUtils.DEFAULT_FILE_NAME_LENGTH);
        }
        // 文件大小和格式校验
        FileUploadUtils.assertAllowed(file, allowedExtension);
        // 文件相对路径使用日期+uuid
        String filePath = FileUploadUtils.uuidFilename(file);
        // 写入本地
        String absPath = FileUploadUtils.getAbsoluteFile(baseDir, filePath).getAbsolutePath();
        file.transferTo(Paths.get(absPath));
        // 数据库存储相对路径
        return filePath;
    }
    /**
     * 下载文件
     */
    public static void downloadFile(String baseDir,String filePath,HttpServletResponse response)throws Exception{
        String absPath = getFileAbsolutePath(baseDir, filePath);
        com.ruoyi.common.utils.file.FileUtils.setAttachmentResponseHeader(response, absPath);
        com.ruoyi.common.utils.file.FileUtils.writeBytes(absPath, response.getOutputStream());
    }
     /**
     * 获取文件绝对路径
     */
    public static final String getFileAbsolutePath(String baseDir, String filePath){
        return baseDir + File.separator + filePath;
    }
}
