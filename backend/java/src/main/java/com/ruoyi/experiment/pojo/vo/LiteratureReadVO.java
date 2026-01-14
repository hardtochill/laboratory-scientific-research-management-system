package com.ruoyi.experiment.pojo.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class LiteratureReadVO {
    private Long literatureId;
    private String title;
    private String keywords;
    private Long readCount;
    private LocalDateTime lastReadTime;
}
