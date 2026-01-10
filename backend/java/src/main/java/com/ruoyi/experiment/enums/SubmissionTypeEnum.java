package com.ruoyi.experiment.enums;

/**
 * 投稿类型枚举类
 */
public enum SubmissionTypeEnum {
    /**
     * 学术论文
     */
    ACADEMIC_PAPER(1, "学术论文"),
    /**
     * 专利
     */
    PATENT(2, "专利"),
    /**
     * 软件著作权
     */
    SOFTWARE_COPYRIGHT(3, "软件著作权");
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
