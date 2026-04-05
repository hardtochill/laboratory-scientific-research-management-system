package com.ruoyi.experiment.enums;
/**
 * 审核类型枚举类
 */
public enum ReviewTypeEnum {
    /**
     * 学生审核
     */
    STUDENT(1, "学生审核"),
    /**
     * 教师审核
     */
    TEACHER(2, "教师审核");

    private final Integer value;
    /**
     * 描述
     */
    private final String description;

    ReviewTypeEnum(Integer value, String description) {
        this.value = value;
        this.description = description;
    }
    
    public Integer getValue() {
        return value;
    }
    
    public String getDescription() {
        return description;
    }
}
