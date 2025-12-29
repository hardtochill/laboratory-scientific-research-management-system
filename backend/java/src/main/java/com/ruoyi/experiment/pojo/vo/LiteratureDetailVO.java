package com.ruoyi.experiment.pojo.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 文献详情VO
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class LiteratureDetailVO {
    /**
     * 文献id
     */
    private Long id;
    /**
     * 文献名称
     */
    private String title;
    /**
     * 文献作者，多个作者用逗号分隔
     */
    private String authors;
    /**
     * 期刊/会议名称
     */
    private String journal;
    /**
     * 发表时间
     */
    private LocalDate publishTime;
    /**
     * 文献摘要
     */
    private String abstractText;
    /**
     * 下载次数
     */
    private Integer downloadCount;
    /**
     * 最终得分
     */
    private BigDecimal finalScore;
    /**
     * 上传用户id
     */
    private Long uploadUserId;
    /**
     * 上传用户昵称
     */
    private String uploadUserNickName;
    /**
     * 上传时间
     */
    private LocalDateTime uploadTime;
    /**
     * 关键词列表
     */
    private List<KeywordVO> keywords;
    /**
     * 用户评分
     */
    private Integer userScore;
}