package com.ruoyi.experiment.enums;
/**
 * 审核状态枚举类
 */
public enum ReviewStatusEnum {
    /**
     * 待审核
     */
    PENDING(1),
    /**
     * 审核通过
     */
    PASSED(2),
    /**
     * 审核不通过
     */
    FAILED(3);;

    private final Integer value;
     ReviewStatusEnum(Integer value) {
        this.value = value;
    }
    public Integer getValue() {
        return value;
    }
}
