package com.ruoyi.experiment.pojo.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class LiteratureStatisticQueryDTO {
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    // 目标用户ID
    private Long userId;
    // 目标文献ID
    private Long literatureId;
}
