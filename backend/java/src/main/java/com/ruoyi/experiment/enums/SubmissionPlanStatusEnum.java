package com.ruoyi.experiment.enums;
/**
 * 投稿计划状态枚举类
 */
public enum SubmissionPlanStatusEnum {
    /**
     * 待送审
     */
    WAITING_REVIEW(1),
    /**
     * 审核中
     */
    REVIEWING(2),
    /**
     * 发表成功
     */
    PUBLISHED_SUCCESS(3),
    /**
     * 发表失败
     */
    PUBLISHED_FAILED(4);
    /**
     * 状态值
     */
    private final Integer value;
    SubmissionPlanStatusEnum(Integer value) {
        this.value = value;
    }
    public Integer getValue() {
        return value;
    }
}
