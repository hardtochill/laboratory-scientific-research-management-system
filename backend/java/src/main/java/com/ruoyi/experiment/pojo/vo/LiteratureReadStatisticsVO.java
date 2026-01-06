package com.ruoyi.experiment.pojo.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class LiteratureReadStatisticsVO {
    private Long literatureId;
    private String title;
    private String keywords;
    private Long studentCount;
    private List<StudentReadDetail> studentList;

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class StudentReadDetail {
        private Long userId;
        private String userNickName;
        private LocalDateTime lastReadTime;
        private Long readCount;
    }
}
