package com.ruoyi.experiment.enums;
/**
 * 用户毕业状态枚举
 */
public enum UserGraduateFlagEnum {
    /**
     * 未毕业
     */
    UNGRADUATED(1),
    /**
     * 已毕业
     */
    GRADUATED(2);
    /**
     * 状态值
     */
    private final int value;
    UserGraduateFlagEnum(int value) {
        this.value = value;
    }
    public int getValue() {
        return value;
    }
}
