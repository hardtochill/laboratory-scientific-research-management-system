package com.ruoyi.experiment.pojo.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class StudentReadStatisticsVO {
    private Long userId;
    private String userNickName;
    private Long literatureCount;
    private LocalDateTime lastReadTime;
    private List<LiteratureReadDetail> literatureList;

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class LiteratureReadDetail {
        private Long literatureId;
        private String title;
        private String keywords;
        private LocalDateTime lastReadTime;
        private Long readCount;
    }
}
