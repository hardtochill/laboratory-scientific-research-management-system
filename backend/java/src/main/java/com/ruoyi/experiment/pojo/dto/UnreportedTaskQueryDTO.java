package com.ruoyi.experiment.pojo.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 待汇报任务查询DTO
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class UnreportedTaskQueryDTO {
    /**
     * 任务执行用户ID（教师角色查询时使用）
     */
    private Long executorUserId;
    
    /**
     * 当前用户ID
     */
    private Long currentUserId;
    
    /**
     * 是否超时（1-已汇报/未超时，2-超时未汇报）
     */
    private Integer timeoutFlag;
    
    /**
     * 用户角色（student/teacher）
     */
    private String userRole;
}
