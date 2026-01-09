package com.ruoyi.experiment.enums;
/**
 * 投稿计划状态枚举类
 */
public enum SubmissionPlanStatusEnum {
    /**
     * 待送审
     */
    WAITING_REVIEW(1, "待送审"),
    /**
     * 审核中
     */
    REVIEWING(2, "审核中"),
    /**
     * 发表成功
     */
    PUBLISHED_SUCCESS(3, "发表成功"),
    /**
     * 发表失败
     */
    PUBLISHED_FAILED(4, "发表失败");
    /**
     * 状态值
     */
    private final Integer value;
    /**
     * 描述
     */
    private final String description;
    
    SubmissionPlanStatusEnum(Integer value, String description) {
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
