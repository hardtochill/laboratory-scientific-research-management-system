package com.ruoyi.experiment.enums;

/**
 * 任务状态枚举
 */
public enum TaskStatusEnum {
    PENDING(0,"未开始"),
    PROCESSING(1,"进行中"),
    FINISHED(2,"已完成"),
    SKIPPED(3,"已跳过");
    private Integer status;
    private String description;
    TaskStatusEnum(Integer status, String description) {
        this.status = status;
        this.description = description;
    }
    public static TaskStatusEnum getByStatus(Integer status) {
        for (TaskStatusEnum taskStatusEnum : TaskStatusEnum.values()) {
            if (taskStatusEnum.getStatus().equals(status)) {
                return taskStatusEnum;
            }
        }
        return null;
    }
    public Integer getStatus() {
        return status;
    }
    public String getDescription() {
        return description;
    }
}
