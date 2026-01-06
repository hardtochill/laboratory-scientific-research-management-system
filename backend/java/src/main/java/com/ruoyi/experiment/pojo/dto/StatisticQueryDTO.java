package com.ruoyi.experiment.pojo.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class StatisticQueryDTO {
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private String searchKey;
    private String sortField;
    private String sortOrder;
}
