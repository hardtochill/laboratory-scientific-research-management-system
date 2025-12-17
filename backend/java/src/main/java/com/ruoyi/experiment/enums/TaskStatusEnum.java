package com.ruoyi.experiment.enums;

/**
 * 任务状态枚举
 */
public enum TaskStatusEnum {
    PENDING(1,"未开始"),
    PROCESSING(2,"进行中"),
    FINISHED(3,"已完成"),
    SKIPPED(4,"已跳过");
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
