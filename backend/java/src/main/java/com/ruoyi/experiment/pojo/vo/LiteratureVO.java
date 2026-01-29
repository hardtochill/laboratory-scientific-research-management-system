package com.ruoyi.experiment.pojo.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 文献展示VO
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class LiteratureVO {
    /**
     * 文献id
     */
    private Long id;
    /**
     * 文献名称
     */
    private String title;
    /**
     * 文献作者
     */
    private String authors;
    /**
     * 期刊/会议名称
     */
    private String journal;
     /**
     * 文献doi
     */
    private String doi;
    /**
     * 发表时间
     */
    private LocalDate publishTime;
    /**
     * 下载次数
     */
    private Integer downloadCount;
    /**
     * 最终得分
     */
    private BigDecimal finalScore;
    /**
     * 用户评分
     */
    private Integer score;
    /**
     * 关键词列表（以逗号分隔的字符串）
     */
    private String keywords;
}