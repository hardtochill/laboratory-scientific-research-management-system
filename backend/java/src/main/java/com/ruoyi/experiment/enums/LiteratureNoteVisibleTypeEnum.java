package com.ruoyi.experiment.enums;

public enum LiteratureNoteVisibleTypeEnum {
    ONLY_SELF(1,"仅自己可见"),
    ALL(2,"所有用户可见");
    private Integer type;
    private String description;
    LiteratureNoteVisibleTypeEnum(Integer type, String description) {
        this.type = type;
        this.description = description;
    }
    public static LiteratureNoteVisibleTypeEnum getByType(Integer type) {
        for (LiteratureNoteVisibleTypeEnum literatureNoteVisibleTypeEnum : LiteratureNoteVisibleTypeEnum.values()) {
            if (literatureNoteVisibleTypeEnum.getType().equals(type)) {
                return literatureNoteVisibleTypeEnum;
            }
        }
        return null;
    }
    public Integer getType() {
        return type;
    }
    public String getDescription() {
        return description;
    }
}
