package com.ruoyi.experiment.enums;

/**
 * 投稿流程文件标签枚举
 */
public enum SubmissionProcessFileTagEnum {
    /**
     * 提交给期刊的文件
     */
    JOURNAL_SUBMISSION(1, "提交给期刊的文件"),

    /**
     * 原始数据与程序
     */
    RAW_DATA_AND_PROGRAM(2, "原始数据与程序"),

    /**
     * 审稿意见
     */
    REVIEW_COMMENTS(3, "审稿意见"),

    /**
     * 补充数据
     */
    SUPPLEMENTARY_DATA(4, "补充数据"),

    /**
     * 最终稿
     */
    FINAL_DRAFT(5, "最终稿");

    private final Integer tag;
    private final String desc;
    SubmissionProcessFileTagEnum(Integer tag, String desc) {
        this.tag = tag;
        this.desc = desc;
    }
    /**
     * 获取标签值
     */
    public Integer getTag() {
        return tag;
    }
     /**
      * 获取标签描述
      */
    public String getDesc() {
        return desc;
    }
}
