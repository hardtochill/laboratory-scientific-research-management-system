package com.ruoyi.experiment.enums;
/**
 * 审核状态枚举类
 */
public enum ReviewStatusEnum {
    /**
     * 待审核
     */
    PENDING(1, "待审核"),
    /**
     * 审核通过
     */
    PASSED(2, "审核通过"),
    /**
     * 审核不通过
     */
    FAILED(3, "审核不通过");

    private final Integer value;
    /**
     * 描述
     */
    private final String description;
    
    ReviewStatusEnum(Integer value, String description) {
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
