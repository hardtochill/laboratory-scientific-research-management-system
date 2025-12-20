package com.ruoyi.experiment.pojo.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
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
     * 发表时间
     */
    private LocalDateTime publishTime;
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
}