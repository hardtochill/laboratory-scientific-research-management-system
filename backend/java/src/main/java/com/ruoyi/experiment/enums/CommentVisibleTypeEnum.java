package com.ruoyi.experiment.enums;

/**
 * 评论可见范围枚举
 */
public enum CommentVisibleTypeEnum {
    /**
     * 仅自己可见
     */
     ONLY_SELF(1,"仅自己可见"),
     /**
      * 所有用户可见
      */
     ALL_USER(2,"所有用户可见");

    private final Integer type;
    private final String description;

    CommentVisibleTypeEnum(Integer type, String description) {
        this.type = type;
        this.description = description;
    }

    public Integer getType() {
        return type;
    }

    public String getDescription() {
        return description;
    }
}
