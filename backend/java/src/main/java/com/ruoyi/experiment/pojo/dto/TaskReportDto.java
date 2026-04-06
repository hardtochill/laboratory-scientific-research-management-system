package com.ruoyi.experiment.pojo.dto;

import lombok.Data;
import org.springframework.web.multipart.MultipartFile;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import java.io.Serializable;
import java.util.List;

/**
 * 任务汇报DTO
 *
 * @author ruoyi
 */
@Data
public class TaskReportDto implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 任务id
     */
    @NotNull(message = "任务id不能为空")
    private Long taskId;

    /**
     * 汇报内容
     */
    @NotBlank(message = "汇报内容不能为空")
    private String reportContent;

    /**
     * 文件列表
     */
    private List<MultipartFile> fileList;
}
