package com.ruoyi.experiment.pojo.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class LiteratureScore extends BaseEntity {
    /**
     * 文献打分id
     */
    private Long id;
    /**
     * 文献id
     */
    private Long literatureId;
    /**
     * 用户id
     */
    private Long userId;
    /**
     * 打分
     */
    private Integer score;
}