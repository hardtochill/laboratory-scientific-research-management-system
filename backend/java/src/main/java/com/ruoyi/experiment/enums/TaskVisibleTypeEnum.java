package com.ruoyi.experiment.enums;

/**
 * 任务可见范围枚举
 */
public enum TaskVisibleTypeEnum {
    ONLY_SELF(0,"仅自己可见"),
    ALL(1,"所有用户可见");
    private Integer type;
    private String description;
    TaskVisibleTypeEnum(Integer type, String description) {
        this.type = type;
        this.description = description;
    }
    public static TaskVisibleTypeEnum getByType(Integer type) {
        for (TaskVisibleTypeEnum taskVisibleTypeEnum : TaskVisibleTypeEnum.values()) {
            if (taskVisibleTypeEnum.getType().equals(type)) {
                return taskVisibleTypeEnum;
            }
        }
        return null;
    }
    public Integer getType() {
        return type;
    }
    public String getDescription() {
        return description;
    }
}
