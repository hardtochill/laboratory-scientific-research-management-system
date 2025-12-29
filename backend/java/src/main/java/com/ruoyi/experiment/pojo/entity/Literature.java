package com.ruoyi.experiment.pojo.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

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
     * 文献标识符
     */
    private String identifier;
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
    private LocalDateTime publishTime;
    /**
     * 文献摘要
     */
    private String abstractText;
    /**
     * 下载次数
     */
    private Integer downloadCount;
    /**
     * 教师打分均值
     */
    private BigDecimal teacherScoreAvg;
    /**
     * 参与打分的教师数量
     */
    private Integer teacherScoreCount;
    /**
     * 学生打分均值
     */
    private BigDecimal studentScoreAvg;
    /**
     * 参与打分的学生数量
     */
    private Integer studentScoreCount;
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
}