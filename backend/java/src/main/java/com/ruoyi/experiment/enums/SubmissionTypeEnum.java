package com.ruoyi.experiment.enums;

/**
 * 投稿类型枚举类
 */
public enum SubmissionTypeEnum {
    /**
     * 期刊论文
     */
    JOURNAL_PAPER(1, "期刊论文"),
    /**
     * 会议论文
     */
    CONFERENCE_PAPER(2, "会议论文"),
    /**
     * 发明专利
     */
    INVENTION_PATENT(3, "发明专利"),
    /**
     * 实用新型专利
     */
    UTILITY_MODEL_PATENT(4, "实用新型专利"),
    /**
     * 软件著作权
     */
    SOFTWARE_COPYRIGHT(5, "软件著作权");
    /**
     * 投稿类型ID
     */
    private final Integer type;
    /**
     * 投稿类型名称
     */
    private final String description;
     /**
      * 构造方法
      */
    SubmissionTypeEnum(Integer type, String description) {
        this.type = type;
        this.description = description;
    }
     /**
      * 获取投稿类型ID
      */
    public Integer getType() {
        return type;
    }
    /**
     * 获取投稿类型名称
     */
    public String getDescription() {
        return description;
    }
}
