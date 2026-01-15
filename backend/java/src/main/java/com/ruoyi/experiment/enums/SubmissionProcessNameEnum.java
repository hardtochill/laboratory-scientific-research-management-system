package com.ruoyi.experiment.enums;

/**
 * 投稿流程名称枚举
 */
public enum SubmissionProcessNameEnum {
    /**
     * 一审
     */
    FIRST_REVIEW("一审"),
    /**
     * 二审
     */
    SECOND_REVIEW("二审"),
    /**
     * 三审
     */
    THIRD_REVIEW("三审"),
    /**
     * 四审
     */
    FOURTH_REVIEW("四审"),
    /**
     * 五审
     */
    FIFTH_REVIEW("五审"),
    /**
     * 六审
     */
    SIXTH_REVIEW("六审"),
    /**
     * 校稿
     */
    JOURNAL_EDITOR_REVIEW("校稿");
    private final String name;
    SubmissionProcessNameEnum(String name) {
        this.name = name;
    }
    /**
     * 获取流程名称
     * @return 流程名称
     */
    public String getName() {
        return name;
    }
}
