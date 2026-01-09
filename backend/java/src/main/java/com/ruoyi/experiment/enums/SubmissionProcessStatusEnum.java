package com.ruoyi.experiment.enums;
/**
 * 投稿流程状态枚举类
 */
public enum SubmissionProcessStatusEnum {
    /**
     * 待发起内部审核
     */
    WAITING_SUBMIT_REVIEW(1, "待发起内部审核"),
    /**
     * 内部审核中
     */
    REVIEWING(2, "内部审核中"),
    /**
     * 内部审核通过
     */
    REVIEW_PASSED(3, "内部审核通过"),
    /**
     * 内部审核不通过
     */
    REVIEW_FAILED(4, "内部审核不通过");
    /**
     * 状态值
     */
    private final Integer value;
    /**
     * 描述
     */
    private final String description;
    
    SubmissionProcessStatusEnum(Integer value, String description) {
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
