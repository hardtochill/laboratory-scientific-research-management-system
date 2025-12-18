package com.ruoyi.experiment.pojo.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 文献
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Literature extends BaseEntity {
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
     * 文献的期刊/会议名称
     */
     private String journal;
      /**
     * 文献的出版年份
     */
     private Integer publishYear;
    /**
     * 文献摘要
     */
     private String abstractText;
    /**
     * 下载次数
     */
     private Integer downloadCount;
    /**
     * 教师打分平均值
     */
     private BigDecimal teacherScoreAvg;
    /**
     * 参与打分的教师数量
     */
    private Integer teacherScoreCount;
    /**
     * 学生打分平均值
     */
     private BigDecimal studentScoreAvg;
     /**
     * 参与打分的学生数量
     */
    private Integer studentScoreCount;
    /**
     * 最终评分
     */
     private BigDecimal finalScore;
    /**
     * 上传文献的用户id
     */
     private Long uploadUserId;
    /**
     * 上传时间
     */
    private LocalDateTime uploadTime;
}
