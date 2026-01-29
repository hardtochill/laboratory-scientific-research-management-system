package com.ruoyi.experiment.pojo.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.web.multipart.MultipartFile;

import javax.validation.constraints.Max;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 新增或修改文献DTO
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
public class LiteratureDTO {
    /**
     * id
     */
    @NotNull
    private Long id;
    /**
     * 文献名称
     */
    @NotBlank(message = "文献名称不能为空")
    private String title;
    /**
     * 文献作者，多个作者用逗号分隔
     */
    private String authors;
    /**
     * 期刊名称
     */
    private String journal;
     /**
     * 文献doi
     */
    private String doi;
    /**
     * 文献发表时间
     */
    private LocalDate publishTime;
    /**
     * 文献摘要
     */
    private String abstractText;
    /**
     * 关键字列表
     */
    private List<Long> keywordIds;
    /**
     * 文献文件
     */
     private MultipartFile file;
    /**
     * 第一条评论
     */
    private String firstComment;
    /**
     * 评论关联文件
     */
    private List<MultipartFile> commentFiles;
    /**
     * 评论可见范围
     */
    private Integer commentVisibleType;
}
